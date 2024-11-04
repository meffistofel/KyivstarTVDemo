//
//  HomeVM.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import OSLog
import Foundation

private let logger = Logger(subsystem: "DemoApp", category: "HomeVM")

final class HomeVM: HomeVMProtocol {

    let outputStream: AsyncStreamResult<Output>
    private let inputStream: AsyncStreamResult<Input>

    weak var coordinatorDelegate: (any HomeVMCoordinatorDelegate)?
    private let homeWebService: any HomeWebServiceProtocol

    private var seriesChannels: [Asset.ID: Asset] = [:]
    private var liveChannels: [Asset.ID: Asset] = [:]
    private var epgsChannels: [Asset.ID: Asset] = [:]
    private var categories: [Category.ID: Category] = [:]
    private var promotions: [Promotion.ID: Promotion] = [:]
    private var sectionTitles: [Section: String] = [:]

    init(coordinatorDelegate: (any HomeVMCoordinatorDelegate)? = nil, homeWebService: any HomeWebServiceProtocol) {
        self.coordinatorDelegate = coordinatorDelegate
        self.homeWebService = homeWebService

        inputStream = AsyncStream.makeStream(of: Input.self)
        outputStream = AsyncStream.makeStream(of: Output.self)

        subscribeToTerminationStreams()

        Task {
            await handleInputEvents()
        }
    }

}

// MARK: HomeVMProtocol methods
extension HomeVM {

    func send(input: Input) {
        inputStream.continuation.yield(input)
    }

    func getPromotion(id: Promotion.ID) -> Promotion? {
        promotions[id]
    }

    func getCategory(id: Category.ID) -> Category? {
        categories[id]
    }

    func getContentGroup(section: Section, id: Asset.ID) -> Asset? {
        switch section {
        case .series:
            seriesChannels[id]
        case .liveChannel:
            liveChannels[id]
        case .epg:
            epgsChannels[id]
        default: nil
        }
    }

    func getSectionTitle(section: Section) -> String? {
        sectionTitles[section]
    }
}

// MARK: Input / Output
private extension HomeVM {

    func send(output: Output) {
        outputStream.continuation.yield(output)
    }

    func subscribeToTerminationStreams() {
        inputStream.continuation.onTermination = { @Sendable [weak self] _ in
            self?.inputStream.continuation.finish()
        }

        outputStream.continuation.onTermination = { @Sendable [weak self] _ in
            self?.outputStream.continuation.finish()
        }
    }

    func handleInputEvents() async {
        for await event in inputStream.stream {
            switch event {
            case .appear:
                logger.debug("Handling appear event")
                send(output: .idle)
            case .fetchResource:
                logger.debug("Handling fetchResource event")
                let output = await prepareDataSource()
                send(output: output)
            case let .showAssetDetail(section, id):
                logger.debug("Did Tap show detail asset")
                guard let asset = getContentGroup(section: section, id: id), asset.purchased else {
                    break
                }

                await coordinatorDelegate?.pushAssetDetailView(with: asset.id)
            }
        }
    }
}


private extension HomeVM {
    func prepareDataSource() async -> Output {
        do {
            async let groupsRequest = homeWebService.getContentGroups()
            async let promotionsRequest = homeWebService.getPromotions()
            async let categoriesRequest = homeWebService.getCategories()

            let (fetchedGroups, fetchedPromotions, fetchedCategories) = try await (groupsRequest, promotionsRequest, categoriesRequest)

            var channels: [GroupType: [Asset.ID: Asset]] = [:]

            sectionTitles = [
                .promotions: fetchedPromotions.name,
                .categories: "Categories", // немає в запиті поля,

            ]

            fetchedGroups.forEach { contentGroup in
                contentGroup.type.forEach { contentType in
                    if let section = Section(group: contentType) {
                        sectionTitles[section] = contentType.rawValue
                    }

                    if let existingAssets = channels[contentType] {
                        let newAssets = Dictionary(uniqueKeysWithValues: contentGroup.assets.map { ($0.id, $0) })
                        channels[contentType] = existingAssets.merging(newAssets) { (current, _) in current }
                    } else {
                        channels[contentType] = Dictionary(uniqueKeysWithValues: contentGroup.assets.map { ($0.id, $0) })
                    }
                }
            }

            self.seriesChannels = channels[.series] ?? [:]
            self.liveChannels = channels[.liveChannel] ?? [:]
            self.epgsChannels = channels[.epg] ?? [:]

            self.categories = Dictionary(uniqueKeysWithValues: fetchedCategories.categories.map { ($0.id, $0) })
            self.promotions = Dictionary(uniqueKeysWithValues: fetchedPromotions.promotions.map { ($0.id, $0) })

            let promotionsIds = promotions.keys.map { SectionItem.promotions($0) }
            let categoriesIds = categories.keys.map { SectionItem.categories($0) }
            let seriesIds = seriesChannels.keys.map { SectionItem.series($0) }
            let livesIds = liveChannels.keys.map { SectionItem.liveChannel($0) }
            let epgsIds = epgsChannels.keys.map { SectionItem.epg($0) }

            let sectionsData: [SectionData] = [
                SectionData(key: .promotions, values: promotionsIds),
                SectionData(key: .categories, values: categoriesIds),
                SectionData(key: .series, values: seriesIds),
                SectionData(key: .liveChannel, values: livesIds),
                SectionData(key: .epg, values: epgsIds)
            ]

            return .fetchedResource(sectionsData)
        } catch {
            return .error(error)
        }
    }
}

extension HomeVM {
    enum Input {
        case appear
        case fetchResource
        case showAssetDetail(Section, Asset.ID)
    }

    enum Output {
        case idle
        case error(Error)
        case fetchedResource([SectionData])
    }
}

private extension Section {
    init?(group: GroupType) {
        switch group {
        case .series:
            self = .series
        case .liveChannel:
            self = .liveChannel
        case .epg:
            self = .epg
        case .unknown: return nil
        }
    }
}

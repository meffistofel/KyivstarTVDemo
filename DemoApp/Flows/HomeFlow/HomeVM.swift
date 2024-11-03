//
//  HomeVM.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import OSLog
import Foundation

typealias AsyncStreamResult<T> = (stream: AsyncStream<T>, continuation: AsyncStream<T>.Continuation)

private let logger = Logger(subsystem: "DemoApp", category: "HomeVM")

final class HomeVM: HomeVMProtocol {

    let outputStream: AsyncStreamResult<HomeVMOutput>
    private let inputStream: AsyncStreamResult<HomeVMInput>

    weak var coordinatorDelegate: (any HomeVMCoordinatorDelegate)?
    private let HomeWebService: any HomeWebServiceProtocol

    private var seriesChannels: [Asset.ID: Asset] = [:]
    private var liveChannels: [Asset.ID: Asset] = [:]
    private var epgsChannels: [Asset.ID: Asset] = [:]
    private var categories: [Category.ID: Category] = [:]
    private var promotions: [Promotion.ID: Promotion] = [:]
    private var sectionTitles: [Section: String] = [:]

    init(coordinatorDelegate: (any HomeVMCoordinatorDelegate)? = nil, HomeWebService: any HomeWebServiceProtocol) {
        self.coordinatorDelegate = coordinatorDelegate
        self.HomeWebService = HomeWebService

        inputStream = AsyncStream.makeStream(of: HomeVMInput.self)
        outputStream = AsyncStream.makeStream(of: HomeVMOutput.self)

        subscribeToTerminationStreams()

        Task {
            await handleInputEvents()
        }
    }

}

// MARK: HomeVMProtocol methods
extension HomeVM {

    func send(input: HomeVMInput) {
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

    func send(output: HomeVMOutput) {
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
                print("Handling appear event")
                send(output: .idle)
            case .cancel:
                print("Handling cancel event")
                send(output: .idle)
            case .fetchResource:
                print("Handling fetchResource event")
                let output = await prepareDataSource()
                send(output: output)
            }
        }
    }
}


private extension HomeVM {
    func prepareDataSource() async -> HomeVMOutput {
        do {
            async let groupsRequest = HomeWebService.getContentGroups()
            async let promotionsRequest = HomeWebService.getPromotions()
            async let categoriesRequest = HomeWebService.getCategories()

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

                    // Перевіряємо, чи вже існує ключ у словнику
                    if let existingAssets = channels[contentType] {
                        // Якщо існує, об'єднуємо старі і нові значення
                        let newAssets = Dictionary(uniqueKeysWithValues: contentGroup.assets.map { ($0.id, $0) })
                        channels[contentType] = existingAssets.merging(newAssets) { (current, _) in current }
                    } else {
                        // Якщо не існує, просто додаємо нові значення
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

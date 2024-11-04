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

    private var groups: [Asset.ID: Asset] = [:]
    private var categories: [Category.ID: Category] = [:]
    private var promotions: [Promotion.ID: Promotion] = [:]

    init(coordinatorDelegate: (any HomeVMCoordinatorDelegate)? = nil, HomeWebService: any HomeWebServiceProtocol) {
        self.coordinatorDelegate = coordinatorDelegate
        self.HomeWebService = HomeWebService

        inputStream = AsyncStream.makeStream(of: HomeVMInput.self)
        outputStream = AsyncStream.makeStream(of: HomeVMOutput.self)

        subscribeToTerminationStreams()

        Task {
            await handleInputEvents() // Запускаємо обробку подій
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

    func getContentGroup(id: Asset.ID) -> Asset? {
        groups[id]
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
                // Логіка для обробки події "stop"
                send(output: .idle)
            case .cancel:
                print("Handling cancel event")
                // Логіка для обробки події "cancel"
                send(output: .idle)
            case .fetchResource:
                print("Handling fetchResource event")
                let output = await getDataSource()
                send(output: output)
            }
        }
    }
}


private extension HomeVM {
    func getDataSource() async -> HomeVMOutput {
        do {
            try await getSource()

            let promotionsIds = promotions.keys.map { SectionItem.promotions($0) }
            let categories = categories.keys.map { SectionItem.categories($0) }
            let groups = groups.keys.map { SectionItem.groups($0) }

            let sectionsData: [SectionData] = [
                SectionData(key: .promotions, values: promotionsIds),
                SectionData(key: .categories, values: categories),
                SectionData(key: .groups, values: groups)
            ]

            return .fetchedResource(sectionsData)
        } catch {
            return .error(error)
        }
    }

    func getSource() async throws {
        async let groups = HomeWebService.getContentGroups()
        async let promotions = HomeWebService.getPromotions()
        async let categories = HomeWebService.getCategories()

        let (fetchedGroups, fetchedPromotions, fetchedCategories) = try await (groups, promotions, categories)

        self.groups = Dictionary(uniqueKeysWithValues: fetchedGroups.flatMap { $0.assets }.map { ($0.id, $0) })
        self.categories = Dictionary(uniqueKeysWithValues: fetchedCategories.categories.map { ($0.id, $0) })
        self.promotions = Dictionary(uniqueKeysWithValues: fetchedPromotions.promotions.map { ($0.id, $0) })
    }
}

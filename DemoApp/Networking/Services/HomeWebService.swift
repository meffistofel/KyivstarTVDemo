//
//  MainUseCase.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

protocol HomeWebServiceProtocol {
    func getContentGroups() async throws -> [ContentGroupModel]
    func getPromotions() async throws -> PromotionalModel
    func getCategories() async throws -> CategoryModel
    func getAssetDetails() async throws -> AssetDetailModel
}

class HomeWebService: HomeWebServiceProtocol {

    private let networkService: NetworkServiceProtocol

    init(_ networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getContentGroups() async throws -> [ContentGroupModel] {
        try await networkService.call(
            Resource(route: "/templates/PGgg02gplft-/data")
        )
    }

    func getPromotions() async throws -> PromotionalModel {
        try await networkService.call(
            Resource(route: "/templates/j_BRMrbcY-5W/data")
        )
    }

    func getCategories() async throws -> CategoryModel {
        try await networkService.call(
            Resource(route: "/templates/eO-fawoGqaNB/data")
        )
    }

    func getAssetDetails() async throws -> AssetDetailModel {
        try await networkService.call(
            Resource(route: "/templates/04Pl5AYhO6-n/data")
        )
    }
}

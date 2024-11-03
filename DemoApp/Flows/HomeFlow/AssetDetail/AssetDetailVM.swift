//
//  AssetDetailVM.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import Foundation
import OSLog

private let logger = Logger(subsystem: "DemoApp", category: "HomeVM")

final class AssetDetailVM: ObservableObject {

    @Published private(set) var asset: AssetDetailModel?

    weak private var coordinatorDelegate: (any AssetDetailVMCoordinatorDelegate)?

    var loadingIsCompleted: Bool {
        asset != nil
    }

    init(
        assetId: String,
        coordinatorDelegate: AssetDetailVMCoordinatorDelegate?,
        homeWebService: any HomeWebServiceProtocol
    ) {
        self.coordinatorDelegate = coordinatorDelegate

        Task { @MainActor in
            do {
                asset = try await homeWebService.getAssetDetails(id: assetId)
            } catch  {
                logger.error("\(error)")
            }
        }
    }
}

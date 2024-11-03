//
//  AssetDetailVCFactory.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

@MainActor
final class AssetDetailVCFactory {
    func build(assetId: String, coordinator: Coordinator) -> UIHostingController<AssetDetailView> {
        let viewModel = AssetDetailVM(
            assetId: assetId,
            coordinatorDelegate: coordinator as? AssetDetailVMCoordinatorDelegate,
            homeWebService: coordinator.container.homeWebService
        )
        let view = AssetDetailView(viewModel: viewModel)

        let viewController = UIHostingController(rootView: view)

        return viewController
    }
}

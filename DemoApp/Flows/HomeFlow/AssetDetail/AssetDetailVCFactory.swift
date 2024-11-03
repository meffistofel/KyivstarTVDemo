//
//  AssetDetailVCFactory.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

@MainActor
final class AssetDetailVCFactory {
    func build(coordinator: Coordinator) -> UIHostingController<AssetDetailView> {
        let viewModel = AssetDetailVM()
        viewModel.coordinatorDelegate = coordinator as? AssetDetailVMCoordinatorDelegate

        let viewController = UIHostingController(rootView: AssetDetailView(viewModel: viewModel))

        return viewController
    }
}

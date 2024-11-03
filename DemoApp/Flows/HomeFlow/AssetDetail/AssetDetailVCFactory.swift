//
//  AssetDetailVCFactory.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

@MainActor
final class AssetDetailVCFactory {
    func build(asset: Asset, coordinator: Coordinator) -> UIHostingController<AssetDetailView> {
        let view = AssetDetailView(asset: asset, coordinatorDelegate: coordinator)

        let viewController = UIHostingController(rootView: view)

        return viewController
    }
}

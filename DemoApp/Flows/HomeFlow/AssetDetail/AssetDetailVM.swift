//
//  AssetDetailVM.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import Foundation

extension AssetDetailView {
    final class AssetDetailVM: ObservableObject {

        @Published private(set) var asset: Asset

        weak var coordinatorDelegate: (any CoordinatorDelegate)?

        init(asset: Asset, coordinatorDelegate: Coordinator) {
            self.asset = asset
            self.coordinatorDelegate = coordinatorDelegate as? CoordinatorDelegate
        }
    }
}

extension AssetDetailView {
    protocol CoordinatorDelegate: AnyObject {

    }
}

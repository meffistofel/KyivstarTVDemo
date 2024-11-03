//
//  HomeFlowCoordinator.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import UIKit

// MARK: - HomeFlowCoordinatorDelegate
protocol HomeFlowCoordinatorDelegate: AnyObject {
    
}

// MARK: - HomeFlowCoordinator
final class HomeFlowCoordinator: Coordinator {

    // MARK: - Properties
    let window: UIWindow?

    weak var delegate: HomeFlowCoordinatorDelegate?

    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = false
        let appearance = UINavigationBarAppearance()
        appearance.customNavBarAppearance(.defaultAppear)
        return navigationController
    }()

    // MARK: - Coordinator
    init(window: UIWindow?, container: DependencyContainer) {
        self.window = window
        super.init(container: container)
    }

    override func start() {
        guard let window = window else {
            return
        }

        rootViewController.setViewControllers([HomeVCFactory().build(coordinator: self)], animated: false)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    override func finish() {

    }
}

extension HomeFlowCoordinator: HomeVMCoordinatorDelegate {
    @MainActor
    func pushAssetDetailView(with asset: Asset) {
        let vc = AssetDetailVCFactory().build(asset: asset, coordinator: self)

        rootViewController.pushViewController(vc, animated: true)
    }
}

extension HomeFlowCoordinator: AssetDetailView.CoordinatorDelegate {

}

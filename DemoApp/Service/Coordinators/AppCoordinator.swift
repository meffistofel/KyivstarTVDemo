//
//  AppCoordinator.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import UIKit

final class AppCoordinator: Coordinator {

    // MARK: - Properties
    let window: UIWindow?

    // MARK: - Coordinator
    init(window: UIWindow?, container: DependencyContainer) {
        self.window = window
        super.init(container: container)
    }

    @objc
    override func start() {
        goToHomeFlowScreens()
    }

    override func finish() { }
}

// MARK: - Authorization flow navigation
extension AppCoordinator: HomeFlowCoordinatorDelegate {
    func goToHomeFlowScreens() {
        let HomeFlowCoordinator = HomeFlowCoordinator(window: window, container: container)
        HomeFlowCoordinator.delegate = self
        addChildCoordinator(HomeFlowCoordinator)
        HomeFlowCoordinator.start()
    }
}

//
//  HomeVCFactory.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

final class HomeVCFactory {
    func build(coordinator: Coordinator) -> HomeViewController {
        let viewModel = HomeVM(HomeWebService: coordinator.container.homeWebService)
        viewModel.coordinatorDelegate = coordinator as? HomeVMCoordinatorDelegate

        let viewController = HomeViewController()
        viewController.viewModel = viewModel

        return viewController
    }
}

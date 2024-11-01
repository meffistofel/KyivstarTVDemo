//
//  DependencyContainer.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

class DependencyContainer {
    lazy var networkingMonitoringService: NetworkMonitoringService = NetworkMonitoringService()
    lazy var networkingService: NetworkServiceProtocol = NetworkingService(networkMonitoringService: networkingMonitoringService)

    lazy var homeWebService: HomeWebServiceProtocol = HomeWebService(networkingService)
}

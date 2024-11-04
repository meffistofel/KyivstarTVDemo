//
//  NetworkMonitoringService.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Combine
import Network
import OSLog

private let logger = Logger(subsystem: "DemoApp", category: "NetworkMonitoringService")

// MARK: - NetworkMonitoringService

class NetworkMonitoringService {

    var isNetworkAvailable = CurrentValueSubject<Bool, Never>(true)

    private var lastPath: String?
    private var status: NWPath.Status = .satisfied

    init() {
        let monitor = NWPathMonitor()

        /* closure called when path changes */
        let pathUpdateHandler = { [weak self] (path:NWPath) in
            let availableInterfaces = path.availableInterfaces

            if !availableInterfaces.isEmpty {
                //e.g. [ipsec4, en0, pdp_ip0]
                let _ = availableInterfaces.map { $0.debugDescription }.joined(separator: "\n")
            }

            guard self?.status != path.status else {
                return
            }

            self?.status = path.status

            switch path.status {
            case .requiresConnection:
                self?.lastPath = "requires connection"
            case .satisfied:
                DispatchQueue.main.async {
                    self?.isNetworkAvailable.value = true
                }
                self?.lastPath = "satisfied"
            case .unsatisfied where self?.lastPath != "requires connection":
                DispatchQueue.main.async {
                    self?.isNetworkAvailable.value = false
                }
                self?.lastPath = "unsatisfied"
                logger.error("Check Connection unsatisfied")
            default:
                break
            }
            print("------> \(self?.lastPath ?? "")")
        }

        /* set the closure */
        monitor.pathUpdateHandler = pathUpdateHandler

        /* create the queue */
        let queue = DispatchQueue.init(label: "monitor queue", qos: .userInitiated)

        /* start monitoring for changes */
        monitor.start(queue: queue)
    }
}

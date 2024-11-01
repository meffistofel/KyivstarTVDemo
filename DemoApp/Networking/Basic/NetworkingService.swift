//
//  NetworkingService.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation
// MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol: AnyObject {
    @discardableResult
    func call<T: Decodable>(_ resource: Resource) async throws -> T
}

final class NetworkingService: NetworkServiceProtocol {

    private let networkMonitoring: NetworkMonitoringService
    private let session: URLSession

    init(session: URLSession = .defaultAppSession, networkMonitoringService: NetworkMonitoringService) {
        networkMonitoring = networkMonitoringService
        self.session = session
    }

    func call<T: Decodable>(_ resource: Resource) async throws -> T {
        guard networkMonitoring.isNetworkAvailable.value else {
            throw APIError.noInternetConnection
        }

        let request = try resource.createRequest()


        let (data, response) = try await session.data(for: request)

        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.unexpectedResponse
        }
        guard HTTPCodes.success.contains(code) else {

            throw APIError.httpCode(code)
        }

        let decoder = JSONDecoder()

        let model = try decoder.decodeWithLogging(T.self, from: data, path: request.url?.absoluteString ?? "")

        return model
    }
}

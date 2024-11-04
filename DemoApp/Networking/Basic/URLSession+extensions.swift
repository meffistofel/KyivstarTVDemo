//
//  URLSession+extensions.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

extension URLSession {

    static var defaultAppSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
//        configuration.requestCachePolicy = .returnCacheDataElseLoad
//        configuration.urlCache = nil // .shared

        return URLSession(configuration: configuration)
    }()
}

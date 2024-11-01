//
//  APIError.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case noInternetConnection
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .noInternetConnection: return "Please check your internet connection and try again"
        }
    }
}

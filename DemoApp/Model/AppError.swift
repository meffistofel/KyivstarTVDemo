//
//  AppError.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

enum AppError: Error, Equatable {
    case error(String)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        nil
    }

    var recoverySuggestion: String? {
        switch self {
        case .error(let text):
            text
        }
    }
}

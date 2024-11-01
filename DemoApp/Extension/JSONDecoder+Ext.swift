//
//  JSONDecoder+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation


extension JSONDecoder {
    func decodeWithLogging<T: Decodable>(_ type: T.Type, from data: Data, path: String) throws -> T {
        do {
            return try self.decode(T.self, from: data)
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                let errorMessage = "Data corrupted: \(context) path: \(path)"
                throw AppError.error(errorMessage)

            case .keyNotFound(let key, let context):
                let errorMessage = "Key '\(key)' not found: \(context.debugDescription) path: \(path)"
                throw AppError.error(errorMessage)

            case .valueNotFound(let value, let context):
                let errorMessage = "Value '\(value)' not found: \(context.debugDescription) path: \(path)"
                throw AppError.error(errorMessage)

            case .typeMismatch(let type, let context):
                let errorMessage = "Type '\(type)' mismatch: \(context.debugDescription) path: \(path)"
                throw AppError.error(errorMessage)

            @unknown default:
                throw AppError.error("Doesn't recognize error")
            }
        } catch {
            throw error
        }
    }
}

//
//  HTTP.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

enum HTTPHeadersKey: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
    case contentDisposition = "Content-Disposition"
    case contentLength = "Content-Length"
    case applicationId = "X-Parse-Application-Id"
    case restApiKey = "X-Parse-REST-API-Key"
}

enum HTTPHeadersValue: String {
    case applicationJson = "application/json"
    case applicationURLEncoded = "application/x-www-form-urlencoded"
    case multipartData = "multipart/form-data"
}

struct HTTPBodyParams {
    static var identity: [String: String] {
        [
            "client_id": "treemix-microservice-ios-application",
            "client_secret": "3sPgZzAr668J6MaSqJxTP7othrtfghvr87D68h76ucOY=",
            "scope": "offline_access"
        ]
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<Int>
typealias HTTPHeaders = [String: String]
typealias HTTParameters = [String: Any]

extension HTTPCodes {
    static let success = 200 ..< 300
}

enum MediaType {
    case video
    case image
}

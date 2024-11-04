//
//  Resource.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

struct Resource {
    let route: String
    let httpMethod: HTTPMethod
    let urlQueryParameters: HTTParameters
    let httpBodyParameters: HTTParameters
    let headers: HTTPHeaders
    var httpBody: Data?
    var isNeedBearToken: Bool

    init(
        route: String,
        httpMethod: HTTPMethod = .get,
        urlQueryParameters: HTTParameters = [:],
        httpBodyParameters: HTTParameters = [:],
        headers: HTTPHeaders = [:],
        httpBody: Data? = nil,
        isNeedBearToken: Bool = true
    ) {
        self.route = route
        self.httpMethod = httpMethod
        self.urlQueryParameters = urlQueryParameters
        self.httpBodyParameters = httpBodyParameters
        self.headers = headers
        self.httpBody = httpBody
        self.isNeedBearToken = isNeedBearToken
    }
}

extension Resource {
    func createRequest() throws -> URLRequest {
        guard let url = URL(string: AppConfiguration().apiURL + route) else {
            throw APIError.invalidURL
        }

        let targetURL = addURLQueryParameters(toURL: url)
        let httpBody = getHttpBody()

        var request = URLRequest(url: targetURL)

        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers

        if isNeedBearToken {
            request.allHTTPHeaderFields?["Authorization"] = "Bearer b3kgsqs1kqytlpact6fhh6pd8grvdj7kqm0nkvd1"
        }
        request.httpBody = httpBody

        return request
    }

    private func getHttpBody() -> Data? {
        guard let contentType = headers["Content-Type"] else { return nil }

        if (contentType as AnyObject).contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters)
        } else if (contentType as AnyObject).contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.map {
                "\($0)=\(String(describing: ($1 as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
            }.joined(separator: "&")

            return bodyString.data(using: .utf8)
        } else if (contentType as AnyObject).contains("multipart/form-data"),
                  let data = httpBodyParameters["media"] as? Data,
                  let body = uploadMedia(data: data, mediaType: .image) {

            return body
        } else {

            return httpBody
        }
    }

    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.values.count > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            let queryItems = urlQueryParameters.map {
                return URLQueryItem(name: $0, value: String(describing: $1))
            }

            urlComponents.queryItems = queryItems

            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }

        return url
    }

    private func uploadMedia(data: Data, mediaType: MediaType) -> Data? {

        switch mediaType {
        case .image:
            let boundary = String(data.hashValue)
            return getMultipartImageData(
                name: "file.jpg",
                filePathKey: "media",
                data: data,
                boundary: boundary,
                mimetype: "image/jpg"
            )
        case .video:
            let boundary = String(data.hashValue)
            return getMultipartImageData(
                name: "myVideo.mov",
                filePathKey: "video",
                data: data,
                boundary: boundary,
                mimetype: "video/mov"
            )
        }
    }

    private func getMultipartImageData(
        name: String,
        filePathKey: String,
        data: Data,
        boundary: String,
        mimetype: String
    ) -> Data? {
        let body = NSMutableData()
//        data.enumerated().forEach { index, value in
            body.appendString("--\(boundary)\r\n")
            body.appendString("\(HTTPHeadersKey.contentDisposition.rawValue): form-data; name=\"\(filePathKey)\"; filename=\"\(name)\"\r\n")
            body.appendString("\(HTTPHeadersKey.contentType.rawValue): \(mimetype)\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")

//        }
        body.appendString("--\(boundary)--\r\n")
        print(data.count.byteSize)

        return body as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return
        }
        append(data)
    }
}

extension Int {
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self))
    }
}


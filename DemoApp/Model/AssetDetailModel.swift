//
//  AssetDetail.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import Foundation

// MARK: - Welcome
struct AssetDetailModel: Decodable {
    let id, name: String
    let image: String
    let company: String
    let similar: [Similar]
    let duration: Double
    let progress: Int
    let purchased: Bool
    let updatedAt, description, releaseDate: String

    var urlImage: URL? {
        URL(string: image)
    }
}

// MARK: - Similar
struct Similar: Decodable, Identifiable {
    let id, name: String
    let image: String
    let company: String
    let progress: Int
    let purchased: Bool
    let updatedAt, releaseDate: String

    var urlImage: URL? {
        URL(string: image)
    }
}

extension AssetDetailModel {
    static var mock: AssetDetailModel {
        .init(
            id: UUID().uuidString,
            name: "The SpongeBob Movie: Sponge on the Run",
            image: "https://picsum.photos/id/574/400/600",
            company: "Universal",
            similar: Similar.mocks,
            duration: 2931,
            progress: 5,
            purchased: false,
            updatedAt: "2012-06-09T21:12:10.996Z",
            description: "Labore occaecat aliqua est mollit. Sint consectetur aliquip laboris eu. Sint est sit aliqua do non adipisicing consequat eiusmod.",
            releaseDate: "1988-03-31"
        )
    }
}

extension Similar {
    static var mocks: [Similar] {
        (1...12).map {
            Similar(
                id: UUID().uuidString,
                name: "The SpongeBob Movie: Sponge on the Run\($0)",
                image: "https://picsum.photos/id/574/400/600",
                company: "Universal",
                progress: Int.random(in: 5...100),
                purchased: Bool.random(),
                updatedAt: "2012-06-09T21:12:10.996Z",
                releaseDate: "1988-03-31"
            )
        }
    }
}

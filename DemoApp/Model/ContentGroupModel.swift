//
//  ContentGroupModel.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import Foundation

struct ContentGroupModel: Decodable {
    let id, name: String
    let type: [GroupType]
    let assets: [Asset]
    let hidden: Bool
    let sortIndex: Int
    let canBeDeleted: Bool
}

enum GroupType: String, Decodable, CaseIterable {
    case series = "SERIES"
    case liveChannel = "LIVECHANNEL"
    case epg = "EPG"
    case unknown

    init(from decoder: Decoder) throws {
        guard let value = try? decoder.singleValueContainer().decode(String.self) else{
            self = .unknown
            return
        }
        self = GroupType(rawValue: value) ?? .unknown
    }
}

// MARK: - Asset
struct Asset: Decodable, Identifiable {
    let id, name: String
    let image: String
    let company: String
    let progress: Int
    let purchased: Bool
    let sortIndex: Int
    let updatedAt, releaseDate: String
}

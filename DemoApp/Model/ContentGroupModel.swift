//
//  ContentGroupModel.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import Foundation

struct ContentGroupModel: Hashable, Decodable {
    let id, name: String
    let type: [String]
    let assets: [Asset]
    let hidden: Bool
    let sortIndex: Int
    let canBeDeleted: Bool
}

// MARK: - Asset
struct Asset: Hashable, Decodable, Identifiable {
    let id, name: String
    let image: String
    let company: String
    let progress: Int
    let purchased: Bool
    let sortIndex: Int
    let updatedAt, releaseDate: String
}

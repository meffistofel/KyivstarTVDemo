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
    let duration, progress: Int
    let purchased: Bool
    let updatedAt, description, releaseDate: String
}

// MARK: - Similar
struct Similar: Decodable, Identifiable {
    let id, name: String
    let image: String
    let company: String
    let progress: Int
    let purchased: Bool
    let updatedAt, releaseDate: String
}

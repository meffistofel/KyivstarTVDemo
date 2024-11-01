//
//  PromotionalModel.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

struct PromotionalModel: Hashable, Decodable {
    let id: String
    let name: String
    let promotions: [Promotion]
}

// MARK: - Promotion Structure
struct Promotion: Hashable, Decodable, Identifiable {
    let id: String
    let name: String
    let image: String
    let company: String
    let updatedAt: String
    let releaseDate: String
}
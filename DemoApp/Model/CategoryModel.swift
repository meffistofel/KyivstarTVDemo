//
//  CategoryModel.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import Foundation

struct CategoryModel: Hashable, Decodable {
    let categories: [Category]
}

// MARK: - Category
struct Category: Hashable, Decodable, Identifiable {
    let id, name: String
    let image: String
}

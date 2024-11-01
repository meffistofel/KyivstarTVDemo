//
//  HomeVMType.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation
import Combine

protocol HomeVMProtocol {
    var outputStream: AsyncStreamResult<HomeVMOutput> { get }
    
    func send(input: HomeVMInput)

    func getPromotion(id: Promotion.ID) -> Promotion?
    func getCategory(id: Category.ID) -> Category?
    func getContentGroup(id: Asset.ID) -> Asset?
}

enum HomeVMInput {
    case appear
    case fetchResource
    case cancel
}

enum HomeVMOutput {
    case idle
    case error(Error)
    case fetchedResource([SectionData])
}

enum Section: Int, CaseIterable {
    case promotions
    case groups
    case categories
}

enum SectionItem: Hashable {
    case groups(Asset.ID)
    case promotions(Promotion.ID)
    case categories(Category.ID)
}

struct SectionData {
    var key: Section
    var values: [SectionItem]
}

// MARK: Coordinator Delegate
protocol HomeVMCoordinatorDelegate: AnyObject {

}

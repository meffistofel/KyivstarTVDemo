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
    func getContentGroup(section: Section, id: Asset.ID) -> Asset?
    func getSectionTitle(section: Section) -> String?
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
    case categories
    case series
    case liveChannel
    case epg

    init?(group: GroupType) {
        switch group {
        case .series:
            self = .series
        case .liveChannel:
            self = .liveChannel
        case .epg:
            self = .epg
        case .unknown: return nil
        }
    }
}

enum SectionItem: Hashable {
    case epg(Asset.ID)
    case liveChannel(Asset.ID)
    case series(Asset.ID)
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

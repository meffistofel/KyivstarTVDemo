//
//  UICollectionViewDiffableDataSource+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import UIKit

protocol DataSourceProtocol {
    associatedtype SectionType
    associatedtype ItemType

    var key: SectionType { get set }
    var values: [ItemType] { get set }
}

extension UICollectionViewDiffableDataSource {
    func reload<Data: DataSourceProtocol>(_ data: [Data], animated: Bool = false)
    where Data.SectionType == SectionIdentifierType, Data.ItemType == ItemIdentifierType {
        var snapshot = snapshot()
        snapshot.deleteAllItems()

        for item in data {
            snapshot.appendSections([item.key])
            snapshot.appendItems(item.values, toSection: item.key)
        }

        apply(snapshot, animatingDifferences: animated)
    }

    func removeSection(_ section: SectionIdentifierType) {
        var snapshot = snapshot()

        // Видаляємо всі елементи вказаної секції
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        snapshot.deleteSections([section])

        // Застосовуємо оновлений знімок
        apply(snapshot, animatingDifferences: true)
    }
}

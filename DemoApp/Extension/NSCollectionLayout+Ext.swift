//
//  NSCollectionLayout+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import UIKit

extension UICollectionViewLayout {
    static func homeViewLayout(
        onChangePagerPage: @escaping (PagingInfo) -> Void,
        onGetSection: @escaping (Int) -> Section?
    ) -> UICollectionViewCompositionalLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 32

        return UICollectionViewCompositionalLayout(
            sectionProvider: { sectionIndex, layoutEnvironment in
                guard let section = onGetSection(sectionIndex) else {
                    return nil
                }
                let contentSize = layoutEnvironment.container.contentSize
                let sectionPadding: CGFloat = 24

                return switch section {
                case .categories:
                        .categoriesLayout(contentSize: contentSize, sectionPadding: sectionPadding)
                case .promotions:
                        .promotionsLayout(
                            contentSize: contentSize,
                            sectionPadding: sectionPadding,
                            sectionIndex: sectionIndex,
                            onChangePagerPage: onChangePagerPage
                        )
                case .series:
                        .seriesLayout(contentSize: contentSize, sectionPadding: sectionPadding)
                case .liveChannel:
                        .liveChannelsLayout(contentSize: contentSize, sectionPadding: sectionPadding)
                case .epg:
                        .epgLayout(sectionPadding: sectionPadding)
                }
            },
            configuration: config
        )
    }
}

extension NSCollectionLayoutSection {
    static func epgLayout(sectionPadding: CGFloat) -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .configItem(itemWidthDimensio: .fractionalWidth(1), itemHeightDimensio: .fractionalHeight(1))
        let group: NSCollectionLayoutGroup = .configGroup(
            groupWidthDimensio: .fractionalWidth(0.576),
            groupHeightDimensio: .estimated(168),
            interItemSpacing: 8,
            item: item
        )
        let section: NSCollectionLayoutSection = .configSection(
            group: group,
            interGroupSpacing: 8,
            sectionPadding: sectionPadding,
            scrollingBehavior: .continuousGroupLeadingBoundary
        )

        addHeader(to: section)

        return section
    }

    static func liveChannelsLayout(contentSize: CGSize, sectionPadding: CGFloat) -> NSCollectionLayoutSection {
        let groupWidth = (contentSize.width - sectionPadding * 2)
        let groupHeight = groupWidth / 3

        let item: NSCollectionLayoutItem = .configItem(itemWidthDimensio: .fractionalWidth(1/3), itemHeightDimensio: .fractionalHeight(1))
        let group: NSCollectionLayoutGroup = .configGroup(
            groupWidthDimensio: .absolute(groupWidth),
            groupHeightDimensio: .absolute(groupHeight),
            interItemSpacing: 8,
            item: item
        )
        let section: NSCollectionLayoutSection = .configSection(
            group: group,
            interGroupSpacing: 8,
            sectionPadding: sectionPadding,
            scrollingBehavior: .continuousGroupLeadingBoundary
        )

        addHeader(to: section)

        return section
    }

    static func seriesLayout(contentSize: CGSize, sectionPadding: CGFloat) -> NSCollectionLayoutSection {
        let groupWidth = (contentSize.width - sectionPadding * 2)

        let item: NSCollectionLayoutItem = .configItem(itemWidthDimensio: .fractionalWidth(1/3), itemHeightDimensio: .fractionalWidth(1))

        let group: NSCollectionLayoutGroup = .configGroup(
            groupWidthDimensio: .absolute(groupWidth),
            groupHeightDimensio: .fractionalWidth(104/200),
            interItemSpacing: 8,
            item: item
        )
        let section: NSCollectionLayoutSection = .configSection(
            group: group,
            interGroupSpacing: 8,
            sectionPadding: sectionPadding,
            scrollingBehavior: .continuousGroupLeadingBoundary
        )

        addHeader(to: section)

        return section
    }

    static func promotionsLayout(
        contentSize: CGSize,
        sectionPadding: CGFloat,
        sectionIndex: Int,
        onChangePagerPage: @escaping (PagingInfo) -> Void
    ) -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .configItem(itemWidthDimensio: .fractionalWidth(1), itemHeightDimensio: .fractionalHeight(1))

        let group: NSCollectionLayoutGroup = .configGroup(
            groupWidthDimensio: .absolute(contentSize.width - sectionPadding * 2),
            groupHeightDimensio: .fractionalWidth(180/328),
            interItemSpacing: 0,
            item: item
        )
        let section: NSCollectionLayoutSection = .configSection(
            group: group,
            interGroupSpacing: sectionPadding,
            sectionPadding: sectionPadding,
            scrollingBehavior: .groupPagingCentered
        )

        addPager(to: section)

        section.visibleItemsInvalidationHandler = { _, offset, environment in
            let pageWidth = environment.container.contentSize.width - sectionPadding * 2 + sectionPadding

            let page = Int((offset.x / pageWidth).rounded())
            let pagingInfo = PagingInfo(sectionIndex: sectionIndex, currentPage: Int(page))
            onChangePagerPage(pagingInfo)
        }

        return section
    }

    static func categoriesLayout(contentSize: CGSize, sectionPadding: CGFloat) -> NSCollectionLayoutSection {
        let groupWidth = (contentSize.width - sectionPadding * 2)
        let groupHeight = groupWidth / 3

        let item: NSCollectionLayoutItem = .configItem(itemWidthDimensio: .fractionalWidth(1/3), itemHeightDimensio: .fractionalHeight(1))

        let group: NSCollectionLayoutGroup = .configGroup(
            groupWidthDimensio: .absolute(groupWidth),
            groupHeightDimensio: .absolute(groupHeight + 16),
            interItemSpacing: 8,
            item: item
        )
        let section: NSCollectionLayoutSection = .configSection(
            group: group,
            interGroupSpacing: 8,
            sectionPadding: sectionPadding,
            scrollingBehavior: .continuousGroupLeadingBoundary
        )

        addHeader(to: section)

        return section
    }

    static func addPager(to section: NSCollectionLayoutSection) {
        let anchor = NSCollectionLayoutAnchor(edges: .bottom, fractionalOffset: .zero)
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(20))

        let pagingFooterElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: HomeViewController.SupplementaryType.pager.rawValue,
            containerAnchor: anchor
        )
        section.boundarySupplementaryItems.append(pagingFooterElement)
    }

    static func addHeader(to section: NSCollectionLayoutSection) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(24))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.SupplementaryType.header.rawValue, alignment: .top)

        section.boundarySupplementaryItems.append(headerElement)
    }
}

extension NSCollectionLayoutItem {
    static func configItem(
        itemWidthDimensio: NSCollectionLayoutDimension,
        itemHeightDimensio: NSCollectionLayoutDimension
    ) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidthDimensio, heightDimension: itemHeightDimensio)

        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
}

extension NSCollectionLayoutGroup {
    static func configGroup(
        groupWidthDimensio: NSCollectionLayoutDimension,
        groupHeightDimensio: NSCollectionLayoutDimension,
        interItemSpacing: CGFloat,
        item: NSCollectionLayoutItem
    ) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimensio, heightDimension: groupHeightDimensio)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(interItemSpacing)

        return group
    }
}

extension NSCollectionLayoutSection {
    static func configSection(
        group: NSCollectionLayoutGroup,
        interGroupSpacing: CGFloat,
        sectionPadding: CGFloat,
        scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> NSCollectionLayoutSection {
        let sectionContentInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: sectionPadding, bottom: 0, trailing: sectionPadding)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollingBehavior
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = sectionContentInsets

        return section
    }
}

//
//  CollectionView.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit
import Combine

class HomeCollectionView: UICollectionView {

    private(set) var pagingInfoSubject: PassthroughSubject<PagingInfo, Never>

    init(pagingInfoSubject: PassthroughSubject<PagingInfo, Never>) {
        self.pagingInfoSubject = pagingInfoSubject

        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        setCollectionViewLayout(createLayout(), animated: false)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 32

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { [unowned self] sectionIndex, layoutEnvironment in
                let sectionType = Section.allCases[sectionIndex]
                let contentSize = layoutEnvironment.container.contentSize

                return switch sectionType {
                case .categories:
                        .categorySectionLayout(size: contentSize, sectionIndex: sectionIndex)
                case .promotions:
                        .promotionSectionLayout(size: contentSize, sectionIndex: sectionIndex, pagingInfoSubject: pagingInfoSubject)
                case .series:
                        .seriesSectionLayout(size: contentSize, sectionIndex: sectionIndex)
                case .liveChannel:
                        .liveChanelSectionLayout(size: contentSize, sectionIndex: sectionIndex)
                case .epg:
                        .categorySectionLayout(size: contentSize, sectionIndex: sectionIndex)
                }
            },
            configuration: config
        )

        return layout

    }
}


private extension NSCollectionLayoutSection {

    static func promotionSectionLayout(size: CGSize, sectionIndex: Int, pagingInfoSubject: PassthroughSubject<PagingInfo, Never>) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let interGroupSpacing: CGFloat = 24
        let groupSpacing = interGroupSpacing * 2

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(size.width - groupSpacing), heightDimension: .fractionalWidth(180/328))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = interGroupSpacing

        addPager(to: section)

        section.visibleItemsInvalidationHandler = { _, offset, environment in
            let pageWidth = environment.container.contentSize.width - groupSpacing + interGroupSpacing

            let page = Int((offset.x / pageWidth).rounded())

            pagingInfoSubject.send(PagingInfo(sectionIndex: sectionIndex, currentPage: Int(page)))
        }

        return section
    }

    static func categorySectionLayout(size: CGSize, sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let sectionPadding: CGFloat = 24

        let groupWidth = (size.width - sectionPadding * 2)
        let groupHeight = groupWidth / 3
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .absolute(groupHeight + 16))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: sectionPadding, bottom: 0, trailing: sectionPadding)

        addHeader(to: section)

        return section
    }

    static func seriesSectionLayout(size: CGSize, sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let sectionPadding: CGFloat = 24

        let groupWidth = (size.width - sectionPadding * 2)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: sectionPadding, bottom: 0, trailing: sectionPadding)

        addHeader(to: section)

        return section
    }

    static func liveChanelSectionLayout(size: CGSize, sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let sectionPadding: CGFloat = 24

        let groupWidth = (size.width - sectionPadding * 2)
        let groupHeight = groupWidth / 3
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: sectionPadding, bottom: 0, trailing: sectionPadding)

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

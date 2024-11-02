//
//  CollectionView.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit
import Combine

class HomeCollectionView: UICollectionView {

    private(set) var onGetSection: (Int) -> Section?
    private(set) var onChangePagerPage: (PagingInfo) -> Void

    init(onChangePagerPage: @escaping (PagingInfo) -> Void, onGetSection: @escaping (Int) -> Section?) {
        self.onGetSection = onGetSection
        self.onChangePagerPage = onChangePagerPage

        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())

        contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
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
            sectionProvider: {
                [unowned self] sectionIndex,
                layoutEnvironment in
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

        return layout

    }
}


private extension NSCollectionLayoutSection {

    static func epgLayout(sectionPadding: CGFloat) -> NSCollectionLayoutSection {
        .sectionLayout(
            itemWidthDimensio: .fractionalWidth(1),
            itemHeightDimensio: .fractionalHeight(1),
            groupWidthDimensio: .fractionalWidth(0.576),
            groupHeightDimensio: .estimated(168),
            sectionPadding: sectionPadding
        )
    }

    static func liveChannelsLayout(contentSize: CGSize, sectionPadding: CGFloat) -> NSCollectionLayoutSection {
        let groupWidth = (contentSize.width - sectionPadding * 2)
        let groupHeight = groupWidth / 3

        return .sectionLayout(
            itemWidthDimensio: .fractionalWidth(1/3),
            itemHeightDimensio: .fractionalHeight(1),
            groupWidthDimensio: .absolute(groupWidth),
            groupHeightDimensio: .absolute(groupHeight),
            sectionPadding: sectionPadding
        )
    }

    static func seriesLayout(contentSize: CGSize, sectionPadding: CGFloat) -> NSCollectionLayoutSection {
        let groupWidth = (contentSize.width - sectionPadding * 2)

        return .sectionLayout(
            itemWidthDimensio: .fractionalWidth(1/3),
            itemHeightDimensio: .fractionalWidth(1),
            groupWidthDimensio: .absolute(groupWidth),
            groupHeightDimensio: .fractionalWidth(104/200),
            sectionPadding: sectionPadding
        )
    }

    static func promotionsLayout(
        contentSize: CGSize,
        sectionPadding: CGFloat,
        sectionIndex: Int?,
        onChangePagerPage: @escaping (PagingInfo) -> Void
    ) -> NSCollectionLayoutSection {
         .sectionLayout(
            itemWidthDimensio: .fractionalWidth(1),
            itemHeightDimensio: .fractionalHeight(1),
            groupWidthDimensio: .absolute(contentSize.width - sectionPadding * 2),
            groupHeightDimensio: .fractionalWidth(180/328),
            interItemSpacing: 0,
            interGroupSpacing: 24,
            sectionPadding: sectionPadding,
            sectionIndex: sectionIndex,
            isNeedPager: true,
            isNeedHeader: false,
            scrollingBehavior: .groupPagingCentered,
            onChangePagerPage: onChangePagerPage
        )
    }

    static func categoriesLayout(contentSize: CGSize, sectionPadding: CGFloat) -> NSCollectionLayoutSection {
        let groupWidth = (contentSize.width - sectionPadding * 2)
        let groupHeight = groupWidth / 3

        return .sectionLayout(
            itemWidthDimensio: .fractionalWidth(1/3),
            itemHeightDimensio: .fractionalHeight(1),
            groupWidthDimensio: .absolute(groupWidth),
            groupHeightDimensio: .absolute(groupHeight + 16),
            sectionPadding: sectionPadding
        )
    }

    static func sectionLayout(
        itemWidthDimensio: NSCollectionLayoutDimension,
        itemHeightDimensio: NSCollectionLayoutDimension,
        groupWidthDimensio: NSCollectionLayoutDimension,
        groupHeightDimensio: NSCollectionLayoutDimension,
        interItemSpacing: CGFloat = 8,
        interGroupSpacing: CGFloat = 8,
        sectionPadding: CGFloat,
        sectionIndex: Int? = nil,
        isNeedPager: Bool = false,
        isNeedHeader: Bool = true,
        scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuousGroupLeadingBoundary,
        onChangePagerPage: ((PagingInfo) -> Void)? = nil
    ) -> NSCollectionLayoutSection {
        let sectionContentInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: sectionPadding, bottom: 0, trailing: sectionPadding)

        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidthDimensio, heightDimension: itemHeightDimensio)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidthDimensio, heightDimension: groupHeightDimensio)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollingBehavior
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = sectionContentInsets

        if isNeedPager, let sectionIndex {
            addPager(to: section)

            section.visibleItemsInvalidationHandler = { _, offset, environment in
                let pageWidth = environment.container.contentSize.width - sectionPadding * 2 + sectionPadding

                let page = Int((offset.x / pageWidth).rounded())
                let pagingInfo = PagingInfo(sectionIndex: sectionIndex, currentPage: Int(page))
                onChangePagerPage?(pagingInfo)
            }
        }

        if isNeedHeader {
            addHeader(to: section)
        }

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

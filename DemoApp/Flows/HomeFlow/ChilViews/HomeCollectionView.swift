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

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, layoutEnvironment in
                let sectionType = Section.allCases[sectionIndex]
                let contentSize = layoutEnvironment.container.contentSize

               switch sectionType {
               case .categories:
                   return self.categorySectionLayout(size: contentSize, sectionIndex: sectionIndex)
               case .groups:
                   return self.categorySectionLayout(size: contentSize, sectionIndex: sectionIndex)
               case .promotions:
                   return self.promotionSectionLayout(size: contentSize, sectionIndex: sectionIndex)
               }


        }, configuration: config)

        return layout

    }

    private func categorySectionLayout(size: CGSize, sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 20

        addHeader(to: section)

        return section
    }

    private func promotionSectionLayout(size: CGSize, sectionIndex: Int) -> NSCollectionLayoutSection {
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
        addHeader(to: section)

        section.visibleItemsInvalidationHandler = { [weak self] _, offset, environment in
            guard let self else { return }

            let pageWidth = environment.container.contentSize.width - groupSpacing + interGroupSpacing

            let page = Int((offset.x / pageWidth).rounded())

            self.pagingInfoSubject.send(PagingInfo(sectionIndex: sectionIndex, currentPage: Int(page)))
        }

        return section
    }

    private func addPager(to section: NSCollectionLayoutSection) {
        let anchor = NSCollectionLayoutAnchor(edges: .bottom, fractionalOffset: .zero)
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(20))

        let pagingFooterElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: HomeViewController.SupplementaryType.pager.rawValue,
            containerAnchor: anchor
        )
        section.boundarySupplementaryItems.append(pagingFooterElement)
    }

    private func addHeader(to section: NSCollectionLayoutSection) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeViewController.SupplementaryType.header.rawValue, alignment: .top)

        section.boundarySupplementaryItems.append(headerElement)
    }
}

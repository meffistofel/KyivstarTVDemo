//
//  CollectionView.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit
import Combine


#warning("Винести")
final class HomeCollectionView: UICollectionView {

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
            sectionProvider: { [unowned self] sectionIndex, layoutEnvironment in
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

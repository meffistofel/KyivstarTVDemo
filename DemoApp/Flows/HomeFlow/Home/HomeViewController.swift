//
//  HomeViewController.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import UIKit
import OSLog
import Combine

private let logger = Logger(subsystem: "DemoApp", category: "HomeViewController")

final class HomeViewController: UIViewController {

    var viewModel: HomeVMProtocol!

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, SectionItem>!
    private let pagingInfoSubject = PassthroughSubject<PagingInfo, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .homeViewLayout(
                onChangePagerPage: { [weak self] pageInfo in
                    self?.pagingInfoSubject.send(pageInfo)
                },
                onGetSection: { [weak self] sectionIndex in
                    self?.dataSource.sectionIdentifier(for: sectionIndex)
                }
            )
        )
        dataSource = setupDataSource()

        bindOutput()
        viewModel.send(input: .appear)
        viewModel.send(input: .fetchResource)

        configureCollectionView()
        configSupplementaryView()
        setupUI()
    }
}

private extension HomeViewController {
    func configureCollectionView() {
        collectionView.register(PromotionCell.self)
        collectionView.register(CategoryCell.self)
        collectionView.register(SeriesCell.self)
        collectionView.register(LiveChannelCell.self)
        collectionView.register(EPGCell.self)
        collectionView.register(PagingSectionFooterView.self, supplementaryViewOfKind: SupplementaryType.pager.rawValue)
        collectionView.register(HomeSectionHeaderView.self, supplementaryViewOfKind: SupplementaryType.header.rawValue)
        collectionView.delegate = self
    }

    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.equalToSuperview()
        collectionView.backgroundColor = .clear

        navigationItem.titleView = UIImageView(image: UIImage(resource: .imageLogo))
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionId = dataSource.sectionIdentifier(for: indexPath.section) else {
            return
        }

        switch sectionId {
        case .categories:
            guard case let .categories(id) = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            viewModel.send(input: .showCategory(id))
        case .promotions:
            guard case let .promotions(id) = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            viewModel.send(input: .showPromotion(id))
        case .series:
            guard case let .series(id) = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            viewModel.send(input: .showAssetDetail(sectionId, id))
        case .liveChannel:
            guard case let .liveChannel(id) = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            viewModel.send(input: .showAssetDetail(sectionId, id))
        case .epg:
            guard case let .epg(id) = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            viewModel.send(input: .showAssetDetail(sectionId, id))
        }
    }
}

// MARK: - Bind

private extension HomeViewController {
    func bindOutput() {
        Task {
            for await output in viewModel.outputStream.stream {
                render(output)
            }
        }
    }

    func render(_ state: HomeVM.Output) {
        switch state {
        case .idle:
            logger.debug("Idle")
        case .fetchedResource(let sources):
            reload(sources)
            logger.debug("Fetched source and reload has been success")
        case .error(let error):
            logger.error("\(error.localizedDescription)")
        }
    }
}


private extension HomeViewController {
    func setupDataSource() -> UICollectionViewDiffableDataSource<Section, SectionItem> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, itemIdentifier in
            guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {
                return nil
            }

            switch itemIdentifier {
            case .categories(let id):
                let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
                if let category: Category = viewModel.getCategory(id: id) {
                    cell.configure(with: .init(model: category))
                }

                return cell
            case .promotions(let id):
                let cell: PromotionCell = collectionView.dequeueReusableCell(for: indexPath)
                if let promotion: Promotion = viewModel.getPromotion(id: id) {
                    cell.configure(with: .init(model: promotion))
                }

                return cell
            case .epg(let id):
                let cell: EPGCell = collectionView.dequeueReusableCell(for: indexPath)
                if let group: Asset = viewModel.getContentGroup(section: section, id: id) {
                    cell.configure(with: .init(model: group))
                }

                return cell
            case .liveChannel(let id):
                let cell: LiveChannelCell = collectionView.dequeueReusableCell(for: indexPath)
                if let group: Asset = viewModel.getContentGroup(section: section, id: id) {
                    cell.configure(with: .init(model: group))
                }

                return cell
            case .series(let id):
                let cell: SeriesCell = collectionView.dequeueReusableCell(for: indexPath)
                if let group: Asset = viewModel.getContentGroup(section: section, id: id) {
                    cell.configure(with: .init(model: group))
                }

                return cell
            }
        }
    }

    func configSupplementaryView() {
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in

            guard let section = dataSource.sectionIdentifier(for: indexPath.section) else {
                return nil
            }

            if kind == SupplementaryType.pager.rawValue, section.isNeedPager {
                let pagingFooter: PagingSectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, indexPath: indexPath)

                let itemCount = dataSource.snapshot().numberOfItems(inSection: section)
                pagingFooter.configure(with: itemCount)

                pagingFooter.subscribeTo(subject: pagingInfoSubject, for: indexPath.section)

                return pagingFooter
            }

            guard section.isNeedHeader else {
                return nil
            }

            let header: HomeSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, indexPath: indexPath)
            let sectionTitle = viewModel.getSectionTitle(section: section) ?? ""

            header.config(with: sectionTitle)

            header.onTapDelete = { [weak self] in
                self?.removeSection(section)
            }

            return header
        }
    }

    func reload(_ data: [SectionData], animated: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()

        for item in data {
            snapshot.appendSections([item.key])
            snapshot.appendItems(item.values, toSection: item.key)
        }
        dataSource.apply(snapshot, animatingDifferences: animated)
    }


    func removeSection(_ section: Section) {
        var snapshot = dataSource.snapshot()

        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        snapshot.deleteSections([section])

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeViewController {
    enum SupplementaryType: String {
        case pager
        case header
    }
}

private extension Section {
    var isNeedPager: Bool {
        switch self {
        case .promotions: true
        default: false
        }
    }

    var isNeedHeader: Bool {
        switch self {
        case .promotions: false
        default: true
        }
    }
}

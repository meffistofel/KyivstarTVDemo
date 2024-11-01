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

class HomeViewController: UIViewController {

    var viewModel: HomeVMProtocol!

    private var collectionView: HomeCollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, SectionItem>!
    private let pagingInfoSubject = PassthroughSubject<PagingInfo, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = HomeCollectionView(pagingInfoSubject: pagingInfoSubject)
        dataSource = setupDataSource()

        bindOutput()
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
        collectionView.register(GroupCell.self)
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
        case .groups:
            guard case let .groups(id) = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
        case .promotions:
            guard case let .promotions(id) = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
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

    func render(_ state: HomeVMOutput) {
        switch state {
        case .idle:
            print("Idle")
        case .fetchedResource(let sources):
            reload(sources)
            logger.debug("Fetched source and reload has been success")
        case .error(let error):
            logger.error("\(error.localizedDescription)")
        }
    }
}

// MARK: DataSource

extension HomeViewController {
    enum SupplementaryType: String {
        case pager
        case header
    }

    private func setupDataSource() -> UICollectionViewDiffableDataSource<Section, SectionItem> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .categories(let id):
                let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
                let category: Category = viewModel.getCategory(id: id)!
                cell.configure(with: .init(model: category))

                return cell
            case .groups(let id):
                let cell: GroupCell = collectionView.dequeueReusableCell(for: indexPath)
                let group: Asset = viewModel.getContentGroup(id: id)!
                cell.configure(with: .init(model: group))

                return cell
            case .promotions(let id):
                let cell: PromotionCell = collectionView.dequeueReusableCell(for: indexPath)
                let promotion: Promotion = viewModel.getPromotion(id: id)!
                cell.configure(with: .init(model: promotion))

                return cell
            }
        }
    }

    private func configSupplementaryView() {
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in

            if kind == SupplementaryType.pager.rawValue {
                if let section = Section(rawValue: indexPath.section), section == .promotions {
                    let pagingFooter: PagingSectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, indexPath: indexPath)

                    let itemCount = dataSource.snapshot().numberOfItems(inSection: section)
                    pagingFooter.configure(with: itemCount)

                    pagingFooter.subscribeTo(subject: pagingInfoSubject, for: indexPath.section)

                    return pagingFooter
                }
            }

            guard Section(rawValue: indexPath.section) != .promotions else {
                return nil
            }

            let header: HomeSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, indexPath: indexPath)

            switch Section(rawValue: indexPath.section) {
            case .categories:
                header.config(with: "Категорії")
            case .groups:
                header.config(with: "Категорії")
            default:
                break
            }

            return header
        }
    }

    private func reload(_ data: [SectionData], animated: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        for item in data {
            snapshot.appendSections([item.key])
            snapshot.appendItems(item.values, toSection: item.key)
        }
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

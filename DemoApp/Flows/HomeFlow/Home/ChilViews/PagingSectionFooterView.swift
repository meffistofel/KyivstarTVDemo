//
//  PagingSectionFooterView.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit
import Combine

struct PagingInfo: Equatable, Hashable {
    let sectionIndex: Int
    let currentPage: Int
}

final class PagingSectionFooterView: UICollectionReusableView, ReusableView {

    private var pagingInfoToken: AnyCancellable?

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = UIColor(resource: .appFEFEFE)
        control.pageIndicatorTintColor = UIColor(resource: .appFEFEFE).withAlphaComponent(0.25)
        return control
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        pagingInfoToken?.cancel()
        pagingInfoToken = nil
    }
}

extension PagingSectionFooterView {
    func configure(with numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }

    func subscribeTo(subject: PassthroughSubject<PagingInfo, Never>, for section: Int) {
        pagingInfoToken = subject
            .filter { $0.sectionIndex == section }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pagingInfo in
                self?.pageControl.currentPage = pagingInfo.currentPage
            }
    }

    private func setupView() {
        backgroundColor = .clear

        addSubview(pageControl)


        pageControl.centerInSuperview(size: .init(width: 120, height: 0))
        pageControl.anchor(bottom: .init(anchor: bottomAnchor, padding: 8))
    }
}

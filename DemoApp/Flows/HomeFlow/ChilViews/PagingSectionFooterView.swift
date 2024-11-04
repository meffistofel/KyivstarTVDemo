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

class PagingSectionFooterView: UICollectionReusableView, ReusableView {
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = UIColor(resource: .appFEFEFE)
        control.pageIndicatorTintColor = UIColor(resource: .appFEFEFE).withAlphaComponent(0.25)
        return control
    }()

    private var pagingInfoToken: AnyCancellable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

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

        pageControl.centerInSuperview(size: .init(width: 120, height: 6))
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        pagingInfoToken?.cancel()
        pagingInfoToken = nil
    }
}

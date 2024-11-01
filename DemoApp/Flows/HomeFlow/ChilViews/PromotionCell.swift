//
//  PromotionCell.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import SwiftUI

class PromotionCell: UICollectionViewCell, ReusableView {

    private let imageView = UIImageView()
    private let pageControl = UIPageControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true


        contentView.addSubview(imageView)
        contentView.addSubview(pageControl)

        imageView.equalToSuperview()
        pageControl.anchor(
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 16, right: 16)
        )
    }

    func configure(with model: CellModel) {
        imageView.loadRemoteImageFrom(urlString: model.imageURL)
    }
}

extension PromotionCell {
    struct CellModel {
        let imageURL: String

        init(model: Promotion) {
            self.imageURL = model.image
        }
    }
}

struct HelloWorldView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            PromotionCell()
        }
        .frame(width: 200, height: 200)
    }
}


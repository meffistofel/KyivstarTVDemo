//
//  PromotionCell.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import SwiftUI

final class PromotionCell: UICollectionViewCell, ReusableView {

    private let posterImageView = UIImageView()
    private let pageControl = UIPageControl()

    private var task: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        task?.cancel()
        task = nil
    }
}

extension PromotionCell {
    func configure(with model: CellModel) {
        task = Task {
            do {
                try await posterImageView.loadRemoteImageFrom(urlString: model.imageURL)
            } catch  {
                print(error)
            }
        }
    }

    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true


        contentView.addSubview(posterImageView)
        contentView.addSubview(pageControl)

        posterImageView.equalToSuperview()
        pageControl.anchor(
            leading: .init(anchor: contentView.leadingAnchor, padding: 16),
            bottom: .init(anchor: contentView.bottomAnchor, padding: 16),
            trailing: .init(anchor: contentView.trailingAnchor, padding: 16)
        )
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


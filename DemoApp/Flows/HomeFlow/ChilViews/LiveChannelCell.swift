//
//  LiveChannelCell.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/2/24.
//

import UIKit

class LiveChannelCell: UICollectionViewCell, ReusableView {

    private var task: Task<Void, Never>?

    private let lockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .iconLock)

        return iv
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill

        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
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

    private func configure() {
        contentView.backgroundColor = .clear
        contentView.addSubview(posterImageView)
        posterImageView.equalToSuperview()

        posterImageView.layer.cornerRadius = contentView.bounds.width / 2
        posterImageView.layer.masksToBounds = true
    }

    func configure(with model: CellModel) {
        if !model.purchased {
            contentView.addSubview(lockImageView)

            lockImageView.anchor(
                top: .init(anchor: posterImageView.topAnchor, padding: 0),
                leading: .init(anchor: posterImageView.leadingAnchor, padding: 0),
                size: .init(width: 32, height: 32)
            )
        }

        task = Task {
            await posterImageView.loadRemoteImageFrom(urlString: model.imageURL)
        }
    }
}

extension LiveChannelCell {
    struct CellModel {
        let imageURL: String
        let purchased: Bool

        init(model: Asset) {
            self.imageURL = model.image
            self.purchased = model.purchased
        }
    }
}

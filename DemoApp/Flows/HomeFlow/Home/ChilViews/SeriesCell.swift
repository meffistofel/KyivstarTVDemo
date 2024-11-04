//
//  GroupsCell.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit

final class SeriesCell: UICollectionViewCell, ReusableView {

    private var task: Task<Void, Never>?

    private var progressView: GradientProgressView = {
        let pv = GradientProgressView()

        return pv
    }()

    private lazy var titleLabel: CustomLabel = {
        let label = CustomLabel()
        label.font = .sfProRounded(.bold, size: 12)
        label.textColor = .app1E2228
        label.textAlignment = .left

        return label
    }()

    private lazy var vStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8

        return sv
    }()

    private let lockImageView: UIImageView = {
        let iv = UIImageView()

        return iv
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill

        return iv
    }()

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
        lockImageView.image = nil
        titleLabel.text = nil
        task?.cancel()
        task = nil
    }
}

extension SeriesCell {
    func configure(with model: CellModel) {
        titleLabel.text = model.name
        titleLabel.textAlignment = .left

        task = Task {
            do {
                try await posterImageView.loadRemoteImageFrom(urlString: model.imageURL)
            } catch  {
                print(error)
            }
        }

        print(model.name, model.purchased)

        if !model.purchased {
            posterImageView.addSubview(lockImageView)

            lockImageView.image = .iconLock
            lockImageView.anchor(
                top: .init(anchor: posterImageView.topAnchor, padding: 8),
                leading: .init(anchor: posterImageView.leadingAnchor, padding: 8)
            )
        }

        if (1...99).contains(Double(model.progress)) {
            posterImageView.addSubview(progressView)

            progressView.anchor(
                leading: .init(anchor: posterImageView.leadingAnchor, padding: 0),
                bottom: .init(anchor: posterImageView.bottomAnchor, padding: 0),
                trailing: .init(anchor: posterImageView.trailingAnchor, padding: 0),
                size: .init(width: 0, height: 4)
            )

            progressView.progress = CGFloat(model.progress)
        }
    }

    private func setupUI() {
        contentView.backgroundColor = .clear
        posterImageView.layer.cornerRadius = 12
        posterImageView.layer.masksToBounds = true
        posterImageView.sizeWithAspectRatio(widthRatio: 104, heightRatio: 156)

        titleLabel.numberOfLines = 0

        vStack.addArrangedSubview(posterImageView)
        vStack.addArrangedSubview(titleLabel)

        contentView.addSubview(vStack)

        vStack.equalToSuperview()
    }
}

extension SeriesCell {
    struct CellModel {
        let name: String
        let imageURL: String
        let purchased: Bool
        let progress: Int

        init(model: Asset) {
            self.name = model.name
            self.imageURL = model.image
            self.purchased = model.purchased
            self.progress = model.progress
        }
    }
}

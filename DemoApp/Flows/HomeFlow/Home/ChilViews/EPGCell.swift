//
//  EPGCell.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/2/24.
//

import UIKit

final class EPGCell: UICollectionViewCell, ReusableView {

    private var task: Task<Void, Never>?

    private var progressView: GradientProgressView = {
        let pv = GradientProgressView()

        return pv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProRounded(.bold, size: 12)
        label.textColor = UIColor(resource: .app1E2228)
        label.textAlignment = .left

        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .sfProRounded(.medium, size: 11)
        label.textColor = UIColor(resource: .app808890)
        label.textAlignment = .left

        return label
    }()

    private lazy var mainVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8

        return sv
    }()

    private lazy var infoVStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .leading

        return sv
    }()

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
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        task?.cancel()
        task = nil
    }
}

extension EPGCell {
    func configure(with model: CellModel) {
        titleLabel.text = model.name

        subTitleLabel.text = "У записі • \(model.company)"

        task = Task {
            do {
                try await posterImageView.loadRemoteImageFrom(urlString: model.imageURL)
            } catch  {
                print(error)
            }
        }

        if !model.purchased {
            posterImageView.addSubview(lockImageView)

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
        posterImageView.sizeWithAspectRatio(widthRatio: 216, heightRatio: 120)

        titleLabel.numberOfLines = 0

        infoVStack.addArrangedSubview(titleLabel)
        infoVStack.addArrangedSubview(subTitleLabel)

        mainVStack.addArrangedSubview(posterImageView)
        mainVStack.addArrangedSubview(infoVStack)

        contentView.addSubview(mainVStack)

        mainVStack.equalToSuperview()
    }
}

extension EPGCell {
    struct CellModel {
        let name: String
        let company: String
        let imageURL: String
        let purchased: Bool
        let progress: Int

        init(model: Asset) {
            self.name = model.name
            self.company = model.company
            self.imageURL = model.image
            self.purchased = model.purchased
            self.progress = model.progress
        }
    }
}

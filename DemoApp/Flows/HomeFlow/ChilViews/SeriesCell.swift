//
//  GroupsCell.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit

class SeriesCell: UICollectionViewCell, ReusableView {

    private var task: Task<Void, Never>?

    private var progressView: GradientProgressView = {
        let pv = GradientProgressView()

        return pv
    }()

    private lazy var titleLabel: CustomLabel = {
        let label = CustomLabel()
        label.font = .sfProRounded(.medium, size: 12)
        label.textColor = UIColor(resource: .app1E2228)
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
        titleLabel.text = nil
        task?.cancel()
        task = nil
    }

    private func configure() {
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

    func configure(with model: CellModel) {
        titleLabel.text = model.name
        titleLabel.textAlignment = .left

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

        task = Task {
            await posterImageView.loadRemoteImageFrom(urlString: model.imageURL)
        }
    }
}

extension UIView {
    func border(color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
    }
}

class GradientProgressView: UIView {

    private let backgroundView = UIView()
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()

    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundView.backgroundColor = UIColor(resource: .app2B3037)
        backgroundView.clipsToBounds = true
        addSubview(backgroundView)

        gradientView.layer.addSublayer(gradientLayer)
        gradientView.clipsToBounds = true
        addSubview(gradientView)

        gradientLayer.colors = [
            UIColor(red: 0.0, green: 0.39, blue: 0.78, alpha: 1.0).cgColor, // #0063C6
            UIColor(red: 0.13, green: 0.62, blue: 1.0, alpha: 1.0).cgColor  // #229FFF
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundView.frame = bounds
        updateProgress()
    }

    private func updateProgress() {
        let filledWidth = bounds.width * (progress / 100)
        gradientView.frame = CGRect(x: 0, y: 0, width: filledWidth, height: bounds.height)
        gradientLayer.frame = gradientView.bounds
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

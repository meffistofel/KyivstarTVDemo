//
//  CategoryCell.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit

final class CategoryCell: UICollectionViewCell, ReusableView {

    private var task: Task<Void, Never>?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
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
        task?.cancel()
        task = nil
    }
}

extension CategoryCell {
    func configure(with model: CellModel) {
        titleLabel.text = model.name
        titleLabel.textAlignment = .center

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
        posterImageView.layer.cornerRadius = 12
        posterImageView.layer.masksToBounds = true

        vStack.addArrangedSubview(posterImageView)
        vStack.addArrangedSubview(titleLabel)

        contentView.addSubview(vStack)

        vStack.equalToSuperview()
    }
}

extension CategoryCell {
    struct CellModel {
        let imageURL: String
        let name: String

        init(model: Category) {
            self.name = model.name
            self.imageURL = model.image
        }
    }
}

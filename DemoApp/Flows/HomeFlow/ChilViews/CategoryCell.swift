//
//  CategoryCell.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit

class CategoryCell: UICollectionViewCell, ReusableView {

    private var task: Task<Void, Never>?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
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

    private let imageView: UIImageView = {
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
        imageView.image = nil
        task?.cancel()
        task = nil
    }

    private func configure() {
        contentView.backgroundColor = .clear
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true

        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(titleLabel)

        contentView.addSubview(vStack)

        vStack.equalToSuperview()
    }

    func configure(with model: CellModel) {
        titleLabel.text = model.name
        titleLabel.textAlignment = .center
        task = Task {
            await imageView.loadRemoteImageFrom(urlString: model.imageURL)
        }
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

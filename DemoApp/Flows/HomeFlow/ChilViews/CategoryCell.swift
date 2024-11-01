//
//  CategoryCell.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit

class CategoryCell: UICollectionViewCell, ReusableView {

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with model: CellModel) {
        
    }
}

extension CategoryCell {
    struct CellModel {
        let name: String

        init(model: Category) {
            self.name = model.name
        }
    }
}

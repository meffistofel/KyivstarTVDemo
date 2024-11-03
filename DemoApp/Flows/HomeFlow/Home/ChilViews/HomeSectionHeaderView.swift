//
//  HomeSectionHeader.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/1/24.
//

import SwiftUI

final class HomeSectionHeaderView: UICollectionReusableView, ReusableView {

    var onTapDelete: (() -> Void)?

    private lazy var stackViewHorizontal: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.setContentHuggingPriority(.required, for: .horizontal)

        return sv
    }()

    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .sfProRounded(.regular, size: 16)
        label.textColor = .app1E2228

        return label
    }()

    private lazy var deleteButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitleColor(.app0063C6, for: .normal)
        button.titleLabel?.font = .sfProRounded(.regular, size: 16)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        config(with: "Section")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

extension HomeSectionHeaderView {
    @objc private func buttonTapped() {
        onTapDelete?()
    }

    func config(with title: String) {
        titleLabel.text = "\(title.capitalizingFirstLetter())"
        deleteButton.setTitle("Del", for: .normal)
    }

    private func setupView() {
        backgroundColor = .clear

        stackViewHorizontal.addArrangedSubview(titleLabel)
        stackViewHorizontal.addArrangedSubview(deleteButton)

        addSubview(stackViewHorizontal)

        stackViewHorizontal.equalToSuperview(padding: .init(top: 0, left: 0, bottom: 8, right: 0))
    }
}

struct HomeSectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer {
            HomeSectionHeaderView()
        }
        .frame(width: 200, height: 24)
        .border(.red)
    }
}

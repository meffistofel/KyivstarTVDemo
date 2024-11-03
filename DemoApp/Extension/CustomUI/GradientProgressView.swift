//
//  GradientProgressView.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/2/24.
//

import UIKit

final class GradientProgressView: UIView {

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

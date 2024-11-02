//
//  CustomUILabel.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/2/24.
//

import UIKit

class CustomLabel: UILabel {
    override func drawText(in rect: CGRect) {
        guard let text = self.text else { return super.drawText(in: rect) }

        // Обчислюємо висоту тексту
        let textHeight = text.boundingRect(
            with: CGSize(width: rect.width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: self.font as Any],
            context: nil
        ).height

        // Визначаємо вертикальне вирівнювання
        let adjustedRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: textHeight)
        super.drawText(in: adjustedRect)
    }
}

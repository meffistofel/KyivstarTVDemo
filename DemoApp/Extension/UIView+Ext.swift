//
//  UIView+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit

extension UIView {
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        padding: UIEdgeInsets = .zero,
        size: CGSize = .zero
    ) -> [NSLayoutConstraint] {

        self.translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()

        if let top = top {
            constraints.append(self.topAnchor.constraint(equalTo: top, constant: padding.top))
        }

        if let leading = leading {
            constraints.append(self.leadingAnchor.constraint(equalTo: leading, constant: padding.left))
        }

        if let bottom = bottom {
            constraints.append(self.bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }

        if let trailing = trailing {
            constraints.append(self.trailingAnchor.constraint(equalTo: trailing, constant: -padding.right))
        }

        if size.width != 0 {
            constraints.append(self.widthAnchor.constraint(equalToConstant: size.width))
        }

        if size.height != 0 {
            constraints.append(self.heightAnchor.constraint(equalToConstant: size.height))
        }

        NSLayoutConstraint.activate(constraints)

        return constraints
    }

    @discardableResult
    func centerInSuperview(size: CGSize = .zero) -> [NSLayoutConstraint] {
        guard let superviewCenterX = superview?.centerXAnchor, let superviewCenterY = superview?.centerYAnchor else {
            return []
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()

        constraints.append(self.centerXAnchor.constraint(equalTo: superviewCenterX))
        constraints.append(self.centerYAnchor.constraint(equalTo: superviewCenterY))

        if size.width != 0 {
            constraints.append(self.widthAnchor.constraint(equalToConstant: size.width))
        }

        if size.height != 0 {
            constraints.append(self.heightAnchor.constraint(equalToConstant: size.height))
        }

        NSLayoutConstraint.activate(constraints)

        return constraints
    }

    @discardableResult
       func equalToSuperview(padding: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
           guard let superview = self.superview else {
               return []
           }

           return anchor(
               top: superview.topAnchor,
               leading: superview.leadingAnchor,
               bottom: superview.bottomAnchor,
               trailing: superview.trailingAnchor,
               padding: padding
           )
       }

    @discardableResult
    func size(width: CGFloat, height: CGFloat) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = self.widthAnchor.constraint(equalToConstant: width)
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: height)

        NSLayoutConstraint.activate([widthConstraint, heightConstraint])

        return [widthConstraint, heightConstraint]
    }
}

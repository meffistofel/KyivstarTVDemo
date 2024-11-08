//
//  UIView+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import UIKit

extension UIView {
    func border(color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
    }
}

extension UIView {
    struct AnchorModel<AnchorType> {
        let anchor: AnchorType
        let padding: CGFloat
    }

    @discardableResult
    func anchor(
        top: AnchorModel<NSLayoutYAxisAnchor>? = nil,
        leading: AnchorModel<NSLayoutXAxisAnchor>? = nil,
        bottom: AnchorModel<NSLayoutYAxisAnchor>? = nil,
        trailing: AnchorModel<NSLayoutXAxisAnchor>? = nil,
        size: CGSize = .zero
    ) -> [NSLayoutConstraint] {

        self.translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()

        if let top = top {
            constraints.append(self.topAnchor.constraint(equalTo: top.anchor, constant: top.padding))
        }

        if let leading = leading {
            constraints.append(self.leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.padding))
        }

        if let bottom = bottom {
            constraints.append(self.bottomAnchor.constraint(equalTo: bottom.anchor, constant: -bottom.padding))
        }

        if let trailing = trailing {
            constraints.append(self.trailingAnchor.constraint(equalTo: trailing.anchor, constant: -trailing.padding))
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
            top: .init(anchor: superview.topAnchor, padding: padding.top),
            leading: .init(anchor: superview.leadingAnchor, padding: padding.left),
            bottom: .init(anchor: superview.bottomAnchor, padding: padding.bottom),
            trailing: .init(anchor: superview.trailingAnchor, padding: padding.right)
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

    @discardableResult
    func height(_ height: CGFloat) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = self.heightAnchor.constraint(equalToConstant: height)

        NSLayoutConstraint.activate([heightConstraint])

        return [heightConstraint]
    }

    @discardableResult
    func width(_ width: CGFloat) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = self.widthAnchor.constraint(equalToConstant: width)

        NSLayoutConstraint.activate([widthConstraint])

        return [widthConstraint]
    }

    @discardableResult
       func sizeWithAspectRatio(widthRatio: CGFloat, heightRatio: CGFloat) -> [NSLayoutConstraint] {
           self.translatesAutoresizingMaskIntoConstraints = false

           let aspectRatio = widthRatio / heightRatio

           let aspectRatioConstraint = self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: aspectRatio)

           NSLayoutConstraint.activate([aspectRatioConstraint])

           return [aspectRatioConstraint]
       }
}

//
//  UIFont+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/1/24.
//

import UIKit

extension UIFont {

    public static func sfProRounded(_ weight: UIFont.Weight, size: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: weight).rounded
    }

    public var rounded: UIFont {
        guard let desc = self.fontDescriptor.withDesign(.rounded) else {
            return self
        }
        return UIFont(descriptor: desc, size: pointSize)
    }
}

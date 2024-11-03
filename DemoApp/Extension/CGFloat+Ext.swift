//
//  CGFloat+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import UIKit

extension CGFloat {
    enum ScreenSize {
        case width
        case height
    }
    @MainActor
    static func relative(to screenSize: ScreenSize, value: CGFloat) -> CGFloat {
        // Висота екрану
        let size = screenSize == .height ? UIApplication.viewBounds.height : UIApplication.viewBounds.width
        let generalSize: CGFloat = screenSize == .height ? 844 : 390

        // Обчислення відносного падінгу
        let relativePadding = (size / generalSize) * value

        return relativePadding
    }
}

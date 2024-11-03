//
//  Font+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

extension Font {

    static func sfProRounded(_ weight: Font.Weight, fixedSize: CGFloat, design: Font.Design = .rounded) -> Font {
        Font.system(size: fixedSize, weight: weight, design: design)
    }
}

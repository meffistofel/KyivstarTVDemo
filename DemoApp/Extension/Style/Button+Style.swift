//
//  Button+Style.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

struct ScalableButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.97 : 1)
            .animation(.easeIn(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ScalableButtonStyle {
    static var scalable: ScalableButtonStyle { .init() }
}

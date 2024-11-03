//
//  ButtonBackground.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

extension View {
    func buttonBackground(config: ButtonBackgroundModifier.Config) -> some View {
        modifier(ButtonBackgroundModifier(config: config))
    }
}

struct ButtonBackgroundModifier: ViewModifier {

    let config: Config

    func body(content: Content) -> some View {
        content
            .background {
            RoundedRectangle(cornerRadius: 32)
                    .fill(config.backgroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(config.strokeColor)
                        .padding(.bottom, 2)
                }
        }
    }

    struct Config {
        let backgroundColor: Color
        let strokeColor: Color
        let cornerRadius: CGFloat

        static var playButton: Config {
            .init(backgroundColor: .app0063C6, strokeColor: .app229FFF, cornerRadius: 32)
        }
        static var favoriteButton: Config {
            .init(backgroundColor: .appE9E7E7, strokeColor: .appFEFEFE, cornerRadius: 32)
        }
        static var skeleton: Config {
            .init(backgroundColor: .gray.opacity(0.3), strokeColor: .clear, cornerRadius: 32)
        }
    }
}

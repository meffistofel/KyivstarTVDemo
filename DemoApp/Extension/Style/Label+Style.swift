//
//  Label+Style.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

enum SpacerType {
    case leading
    case trailing
    case bottom
    case top
    case center
}

extension LabelStyle where Self == AdaptiveLabelStyle {
    static func adaptive(iconAlignment: SpacerType = .leading, spacing: CGFloat = 8) -> AdaptiveLabelStyle { .init(iconAlignment: iconAlignment, spacing: spacing) }
}

struct AdaptiveLabelStyle: LabelStyle {
    var iconAlignment: SpacerType = .leading
    var spacing: CGFloat = 8

    func makeBody(configuration: Self.Configuration) -> some View {
        if iconAlignment == .bottom {
            VStack(spacing: spacing) {
                configuration.title
                configuration.icon
            }
        } else if iconAlignment == .top {
            VStack(spacing: spacing) {
                configuration.icon
                configuration.title
            }
        } else if iconAlignment == .leading {
            HStack(spacing: spacing) {
                configuration.icon
                configuration.title
            }
        } else {
            HStack(spacing: spacing) {
                configuration.title
                configuration.icon
            }
        }
    }
}

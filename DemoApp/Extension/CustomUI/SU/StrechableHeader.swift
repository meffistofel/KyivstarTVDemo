//
//  dsdsd.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

struct StrechableHeader<Content: View>: View {
    let isPlay: Bool
    let isFavorite: Bool
    let yOffset: CGFloat
    let content: () -> Content

    var body: some View {

        GeometryReader { geo in
            let height = geo.size.height
            let newHeight = yOffset > 0 ? height + yOffset : max(height / 1.5, height + yOffset)

            content()
                .frame(height: newHeight, alignment: .top)
                .offset(y: -yOffset)
        }
        .zIndex(100)
    }
}

//
//  FavoriteButton.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

struct FavoriteButton: View {
    let isFavorite: Bool
    let isLoaded: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            if isLoaded {
                Image(systemName: image)
                    .foregroundStyle(.app1E2228)
                    .font(.sfProRounded(.semibold, fixedSize: 16))
            }
        }
        .frame(width: 66, height: 40)
        .buttonBackground(config: isLoaded ? .favoriteButton : .skeleton)
    }

    private var image: String {
        isFavorite ? "star.fill" : "star"
    }
}

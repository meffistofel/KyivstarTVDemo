//
//  SimilarView.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

struct SimilarView: View {
    var similar: [Similar]?
    let isLoaded: Bool

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(similar ?? Similar.mocks) { item in
                AsyncImageApp(url: item.urlImage, height: 156)
                    .frame(maxWidth: .infinity)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(alignment: .topLeading) {
                        if !item.purchased && isLoaded {
                            Image(.iconLock)
                                .padding([.leading, .top], 8)
                        }
                    }
            }
        }
    }
}

#Preview {
    SimilarView(similar: Similar.mocks, isLoaded: false)
}

//
//  PreviewContainer.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/31/24.
//

import SwiftUI

struct PreviewContainer<T: UIView>: UIViewRepresentable {

    // 2
    let view: T


    // 3
    init(_ viewBuilder: @escaping () -> T) {

        view = viewBuilder()
    }

    // MARK: - UIViewRepresentable
    func makeUIView(context: Context) -> T {
        // 4
        return view

    }

    // 5
    func updateUIView(_ view: T, context: Context) {

        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

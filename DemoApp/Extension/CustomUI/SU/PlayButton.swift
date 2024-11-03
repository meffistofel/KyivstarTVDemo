//
//  PlayButton.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

struct PlayButton: View {
    let isPlay: Bool
    let isLoaded: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Label(text, systemImage: image)
                .foregroundStyle(.white)
                .font(.sfProRounded(.semibold, fixedSize: 16))
                .labelStyle(.adaptive(spacing: 16))
                .frame(width: 129, height: 40)
                .buttonBackground(config: isLoaded ? .playButton : .skeleton)
                .drawingGroup()
        }
        .buttonStyle(.scalable)
    }

    private var text: String {
        isPlay ? "Play" : "Pause"
    }

    private var image: String {
        isPlay ? "play.fill" : "pause.fill"
    }
}

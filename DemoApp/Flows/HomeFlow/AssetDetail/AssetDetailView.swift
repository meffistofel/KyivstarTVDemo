//
//  AssetDetailView.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

struct AssetDetailView: View {

    @StateObject private var viewModel: AssetDetailVM

    init(viewModel: AssetDetailVM) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.appFEFEFE)
    }
}

#Preview {
    AssetDetailView(viewModel: AssetDetailVM())
}

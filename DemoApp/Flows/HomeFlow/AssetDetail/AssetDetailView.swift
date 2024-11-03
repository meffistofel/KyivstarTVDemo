//
//  AssetDetailView.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

struct AssetDetailView: View {

    @StateObject private var viewModel: AssetDetailVM

    init(asset: Asset, coordinatorDelegate: Coordinator) {
        self._viewModel = .init(wrappedValue: .init(asset: asset, coordinatorDelegate: coordinatorDelegate))
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.appFEFEFE)
    }
}

//#Preview {
//    AssetDetailView(viewModel: AssetDetailVM())
//}

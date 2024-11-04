//
//  AssetDetailView.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import SwiftUI

struct AssetDetailView: View {
    
    @StateObject private var viewModel: AssetDetailVM

    @State private var isPlay: Bool = false
    @State private var isFavorite: Bool = false
    @State private var offset: CGPoint = .zero

    private let coordinateSpaceName: UUID = UUID()

    init(viewModel: AssetDetailVM) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        OffsetObservingScrollView(offset: $offset, coordinateSpaceName: coordinateSpaceName) {
            VStack(spacing: 0) {
                StrechableHeader(
                    isPlay: isPlay,
                    isFavorite: isFavorite,
                    yOffset: offset.y
                ) {
                    headerContent
                }
                .frame(height: .relative(to: .height, value: 279))

                VStack(spacing: 0) {
                    infoSection
                        .padding(.bottom, 24)

                    SimilarView(similar: viewModel.asset?.similar, isLoaded: viewModel.loadingIsCompleted)
                        .redacted(reason: !viewModel.loadingIsCompleted ? .placeholder : [])
                }
                .padding(.top, 12)
                .padding(.horizontal, 24)
            }
            .padding(.bottom)

        }
        .coordinateSpace(name: coordinateSpaceName)
        .background(.appFEFEFE)
    }
}

private extension AssetDetailView {
    var headerContent: some View {
        VStack(spacing: 0) {
            let height: CGFloat = .relative(to: .height, value: 211)
            let newHeight = offset.y > 0 ? height + offset.y : max(height / 1.5, height + offset.y)

            AsyncImageApp(url: viewModel.asset?.urlImage, height: newHeight)

            HStack(spacing: 0) {
                PlayButton(isPlay: isPlay, isLoaded: viewModel.loadingIsCompleted) {
                    isPlay.toggle()
                    // some logic
                }

                Spacer()
                FavoriteButton(isFavorite: isFavorite, isLoaded: viewModel.loadingIsCompleted) {
                    isFavorite.toggle()
                    // some logic
                }
            }
            .padding(.top, 12)
            .padding(.bottom)
            .padding(.horizontal, 24)
            .redacted(reason: !viewModel.loadingIsCompleted ? .placeholder : [])

            Color.appE9E7E7.frame(height: 1)
                .padding(.horizontal, 24)
        }
        .background(.white)
    }
    var infoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            let placeHolderName = "The SpongeBob Movie: Sponge on the Run"
            let isExistName = viewModel.asset?.name.isEmpty ?? true
            let name = !isExistName ? viewModel.asset?.name ?? "" : placeHolderName

            Text(name.moveToNextLine())
                .font(.sfProRounded(.bold, fixedSize: 22))
                .foregroundStyle(.app2B3037)
                .padding(.bottom, 4)


            let company = viewModel.asset?.company ?? "Universal"
            let duration: String = (viewModel.asset?.duration ?? 780).asString(style: .abbreviated, units: [.hour, .minute], zeroFormattingBehavior: .dropAll)
            let releaseDate: String = viewModel.asset?.releaseDate ?? "1988-03-31"

            Text("\(company) • \(duration) • \(releaseDate)")
                .font(.sfProRounded(.medium, fixedSize: 14))
                .foregroundStyle(.app2B3037)
                .padding(.bottom, 8)

            let placeholderDescription = "Labore occaecat aliqua est mollit. Sint consectetur aliquip laboris eu. Sint est sit aliqua do non adipisicing consequat eiusmod."

            Text(viewModel.asset?.description ?? placeholderDescription)
                .font(.sfProRounded(.medium, fixedSize: 12))
                .foregroundStyle(.gray)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .redacted(reason: !viewModel.loadingIsCompleted ? .placeholder : [])
    }
}

#Preview {
    AssetDetailView(
        viewModel: .init(
            assetId: "",
            coordinatorDelegate: HomeFlowCoordinator.mock,
            homeWebService: HomeWebService(NetworkingService(networkMonitoringService: .init()))
        )
    )
}


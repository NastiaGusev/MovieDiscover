//
//  StreamingBrowserView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI

struct StreamingBrowserView: View {
    let viewModel: StreamingViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            picker
            grid
        }
        .navigationTitle(String(localized: L10n.Home.whereToStream))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var picker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.md) {
                ForEach(viewModel.providers) { provider in
                    Button {
                        Task { await viewModel.select(provider.providerId) }
                    } label: {
                        CachedAsyncImage(url: provider.logoURL) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: CornerRadius.md).fill(Color.placeholder)
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.md)
                                .stroke(.tint, lineWidth: viewModel.selectedProviderID == provider.providerId ? 3 : 0)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var grid: some View {
        switch viewModel.state {
        case .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error(let message):
            ContentUnavailableView(
                String(localized: L10n.Error.somethingWentWrong),
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        case .loaded:
            MoviePosterGrid(
                movies: viewModel.movies,
                columnCount: GridColumns.streaming,
                onReachEnd: { await viewModel.loadMore() }
            )
        }
    }
}

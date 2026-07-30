//
//  StreamingView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 28/07/2026.
//
import SwiftUI

struct StreamingView: View {
    @State private var viewModel = StreamingViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                providerRow
                    .padding(.vertical, Spacing.sm)
                content
            }
            .navigationTitle(L10n.Streaming.streaming)
            .task { await viewModel.loadProviders() }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }

    private var providerRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.md) {
                ForEach(viewModel.providers) { provider in
                    Button {
                        Task { await viewModel.select(provider.providerId) }
                    } label: {
                        AsyncImage(url: provider.logoURL) { phase in
                            if case .success(let img) = phase {
                                img.resizable().aspectRatio(contentMode: .fit)
                            } else {
                                RoundedRectangle(cornerRadius: CornerRadius.md).fill(Color.placeholder)
                            }
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
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error(let message):
            ContentUnavailableView(
                L10n.Error.somethingWentWrong,
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        case .loaded:
            MoviePosterGrid(
                movies: viewModel.movies,
                columnCount: GridColumns.streaming,
                onReachEnd: { Task { await viewModel.loadMore() } }
            )
        }
    }
}

#Preview {
    StreamingView()
}

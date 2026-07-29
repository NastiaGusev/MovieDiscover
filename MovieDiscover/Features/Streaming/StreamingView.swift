//
//  StreamingView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 28/07/2026.
//
import SwiftUI
import SwiftData

struct StreamingView: View {
    @State private var viewModel = StreamingViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                providerRow
                
                switch viewModel.state {
                case .loading:
                    ProgressView().padding()
                case .error(let message):
                    Text(message).foregroundStyle(.secondary).padding()
                case .loaded(let movies):
                    MoviePosterGrid(movies: movies, columnCount: GridColumns.streaming)
                }
            }
            .navigationTitle(L10n.Streaming.streaming)
            .task { await viewModel.loadProviders() }
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
                                .stroke(.blue, lineWidth: viewModel.selectedProviderID == provider.providerId ? 3 : 0)
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        StreamingView()
    }
    .modelContainer(for: FavoriteMovie.self, inMemory: true)
}

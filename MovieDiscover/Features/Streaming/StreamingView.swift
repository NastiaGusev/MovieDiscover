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
    
    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]
    
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
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(movies) { movie in
                            NavigationLink {
                                MovieDetailView(movie: movie)
                            } label: {
                                AsyncImage(url: movie.posterURL) { phase in
                                    if case .success(let img) = phase {
                                        img.resizable().aspectRatio(contentMode: .fill)
                                    } else {
                                        Rectangle().fill(.gray.opacity(0.2))
                                    }
                                }
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle(L10n.Streaming.streaming)
            .task { await viewModel.loadProviders() }
        }
    }
    
    private var providerRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.providers) { provider in
                    Button {
                        Task { await viewModel.select(provider.providerId) }
                    } label: {
                        AsyncImage(url: provider.logoURL) { phase in
                            if case .success(let img) = phase {
                                img.resizable().aspectRatio(contentMode: .fit)
                            } else {
                                RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.2))
                            }
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
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

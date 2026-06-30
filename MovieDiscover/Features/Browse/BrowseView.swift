//
//  BrowseView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import SwiftUI

struct BrowseView: View {
    @State private var viewModel = BrowseViewModel()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                content
            }
            .navigationTitle("Trending")
            .task {
                await viewModel.loadTrendingMovies()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.movies.isEmpty {
            ProgressView("Loading trending movies…")
                .padding(.top, 100)
        } else if let errorMessage = viewModel.errorMessage {
            VStack(spacing: 12) {
                Text(errorMessage)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button("Retry") {
                    Task { await viewModel.loadTrendingMovies() }
                }
            }
            .padding(.top, 100)
            .padding(.horizontal)
        } else {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(value: movie) {
                        MoviePosterCell(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }
}

private struct MoviePosterCell: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                case .failure, .empty:
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay {
                            Image(systemName: "film")
                                .foregroundStyle(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(movie.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
        }
    }
}

#Preview {
    BrowseView()
}

//
//  SearchView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(L10n.Search.search)
                .searchable(text: $viewModel.query, prompt: L10n.Search.searchMovies)
                .navigationDestination(for: Movie.self) { movie in
                    MovieDetailView(movie: movie)
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.query.trimmingCharacters(in: .whitespaces).isEmpty {
            ContentUnavailableView.search
        } else if viewModel.isLoading && viewModel.results.isEmpty {
            ProgressView()
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView(
                L10n.Error.somethingWentWrong,
                systemImage: "exclamationmark.triangle",
                description: Text(errorMessage)
            )
        } else if viewModel.results.isEmpty {
            ContentUnavailableView.search(text: viewModel.query)
        } else {
            List(viewModel.results) { movie in
                NavigationLink(value: movie) {
                    HStack(spacing: 12) {
                        AsyncImage(url: movie.posterURL) { phase in
                            if case .success(let image) = phase {
                                image.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Rectangle().fill(.gray.opacity(0.2))
                            }
                        }
                        .frame(width: 46, height: 69)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.overview)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    SearchView()
}

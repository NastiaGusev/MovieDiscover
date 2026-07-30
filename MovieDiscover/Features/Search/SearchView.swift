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
        content
            .navigationTitle(String(localized: L10n.Search.search))
            .searchable(text: $viewModel.query, prompt: L10n.Search.searchMovies)
            .onSubmit(of: .search) {
                Task { await viewModel.search() }
            }
            .onChange(of: viewModel.query) { _, newValue in
                if newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                    Task { await viewModel.search() }
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView.search
        case .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error(let message):
            ContentUnavailableView(
                L10n.Error.somethingWentWrong,
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        case .empty:
            ContentUnavailableView.search(text: viewModel.query)
        case .loaded:
            List(viewModel.movies) { movie in
                NavigationLink(value: movie) {
                    HStack(spacing: Spacing.md) {
                        AsyncImage(url: movie.posterURL) { phase in
                            if case .success(let image) = phase {
                                image.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Rectangle().fill(Color.placeholder)
                            }
                        }
                        .frame(width: 46, height: 69)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
                        
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
                .onAppear {
                    if movie.id == viewModel.movies.last?.id {
                        Task { await viewModel.loadMore() }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack { SearchView() }
}

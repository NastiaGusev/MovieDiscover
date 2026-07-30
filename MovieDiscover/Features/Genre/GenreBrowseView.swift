//
//  GenreBrowseView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI

struct GenreBrowseView: View {
    let genres: [Genre]
    let apiClient: APIClient
    
    @State private var selectedID: Int
    @State private var pager: MoviePager
    @State private var didLoad = false
    
    init(genres: [Genre], selected: Genre, apiClient: APIClient = .shared) {
        self.genres = genres
        self.apiClient = apiClient
        _selectedID = State(initialValue: selected.id)
        _pager = State(initialValue: MoviePager { page in
            try await apiClient.request(.discoverByGenre(genreID: selected.id, page: page))
        })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            picker
            MoviePosterGrid(
                movies: pager.movies,
                columnCount: GridColumns.genre,
                onReachEnd: { try? await pager.loadNext() }
            )
        }
        .navigationTitle(String(localized: L10n.Home.exploreGenres))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard !didLoad else { return }
            didLoad = true
            try? await pager.loadNext()
        }
    }
    
    private var picker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                ForEach(genres) { genre in
                    Button { select(genre) } label: {
                        Text(genre.name)
                            .font(.subheadline)
                            .padding(.horizontal, Spacing.md)
                            .padding(.vertical, Spacing.sm)
                            .background(selectedID == genre.id ? Color.brand : Color.gray.opacity(0.2))
                            .foregroundStyle(selectedID == genre.id ? .white : .primary)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.sm)
        }
    }
    
    private func select(_ genre: Genre) {
        guard genre.id != selectedID else { return }
        selectedID = genre.id
        let apiClient = self.apiClient
        pager = MoviePager { page in
            try await apiClient.request(.discoverByGenre(genreID: genre.id, page: page))
        }
        Task { try? await pager.loadNext() }
    }
}

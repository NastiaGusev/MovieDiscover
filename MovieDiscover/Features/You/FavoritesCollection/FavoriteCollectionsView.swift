//
//  FavoriteCollectionsView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import SwiftUI

struct FavoriteCollectionsView: View {
    let favorites: [FavoriteMovie]
    @State private var viewModel: FavoriteCollectionsViewModel

    init(favorites: [FavoriteMovie], viewModel: FavoriteCollectionsViewModel) {
        self.favorites = favorites
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            if case .loaded(let collections) = viewModel.state {
                collectionsView(collections)
                    .transition(.opacity)
            } else {
                gridView
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isLoaded)
        .task(id: favorites) { await viewModel.group(favorites) }
    }

    private var isLoaded: Bool {
        if case .loaded = viewModel.state { return true }
        return false
    }

    private func collectionsView(_ collections: [FavoriteCollectionsViewModel.Collection]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            banner
            ForEach(collections) { collection in
                MovieCarousel(title: collection.title,
                              movies: collection.movies.map(\.asMovie))
            }
        }
    }

    private var banner: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "sparkles").foregroundStyle(Color.brand)
            Text(String(localized: L10n.Collections.banner))
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, Spacing.lg)
    }

    private var gridView: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: Spacing.sm),
                            count: GridColumns.genre)
        return LazyVGrid(columns: columns, spacing: Spacing.sm) {
            ForEach(favorites) { favorite in
                NavigationLink(value: favorite.asMovie) {
                    MoviePosterCell(movie: favorite.asMovie)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.lg)
    }
}

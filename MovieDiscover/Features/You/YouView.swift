//
//  YouView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI
import SwiftData

struct YouView: View {
    @Query(sort: \FavoriteMovie.dateAdded, order: .reverse) private var favorites: [FavoriteMovie]
    @Environment(\.modelContext) private var modelContext
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: Spacing.sm),
        count: GridColumns.genre
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Spacing.lg) {
                    // ── Insertion point: taste profile blurb (feature 3) ──
                    // ── Insertion point: Insights dashboard (feature 2) ──
                    
                    favoritesSection
                }
                .padding(.vertical, Spacing.md)
            }
            .navigationTitle(String(localized: L10n.You.title))
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }
    
    @ViewBuilder
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: L10n.You.favorites))
                .font(.title3.bold())
                .padding(.horizontal)
            
            if favorites.isEmpty {
                ContentUnavailableView(
                    String(localized: L10n.You.noFavoritesTitle),
                    systemImage: "heart",
                    description: Text(String(localized: L10n.You.noFavoritesDescription))
                )
                .padding(.vertical, Spacing.lg)
            } else {
                LazyVGrid(columns: columns, spacing: Spacing.sm) {
                    ForEach(favorites) { favorite in
                        NavigationLink(value: favorite.asMovie) {
                            MoviePosterCell(movie: favorite.asMovie)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button(role: .destructive) {
                                modelContext.delete(favorite)
                            } label: {
                                Label(String(localized: L10n.You.remove), systemImage: "heart.slash")
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    YouView()
        .modelContainer(for: FavoriteMovie.self, inMemory: true)
}

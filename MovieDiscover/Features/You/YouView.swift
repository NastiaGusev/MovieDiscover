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
                    TasteProfileEntry.make(favorites: favorites).id("tasteProfile")
                    
                    if favorites.isEmpty {
                        ContentUnavailableView(
                            String(localized: L10n.You.noFavoritesTitle),
                            systemImage: "heart",
                            description: Text(String(localized: L10n.You.noFavoritesDescription))
                        )
                        .padding(.top, Spacing.lg)
                    } else {
                        FavoriteCollectionsEntry.make(favorites: favorites)
                    }
                }
                .padding(.vertical, Spacing.md)
            }
            .navigationTitle(String(localized: L10n.You.title))
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }
}

#Preview {
    YouView()
        .modelContainer(for: FavoriteMovie.self, inMemory: true)
}

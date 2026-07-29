//
//  FavoritesView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(sort: \FavoriteMovie.dateAdded, order: .reverse) private var favorites: [FavoriteMovie]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Group {
                if favorites.isEmpty {
                    ContentUnavailableView(
                        L10n.Favorites.noFavorites,
                        systemImage: "heart",
                        description: Text(L10n.Favorites.favoritesDescription)
                    )
                } else {
                    List {
                        ForEach(favorites) { favorite in
                            NavigationLink {
                                MovieDetailView(movie: favorite.asMovie)
                            } label: {
                                HStack(spacing: 12) {
                                    AsyncImage(url: favorite.posterURL) { phase in
                                        if case .success(let image) = phase {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } else {
                                            Rectangle().fill(.gray.opacity(0.2))
                                        }
                                    }
                                    .frame(width: 50, height: 75)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(favorite.title)
                                            .font(.headline)
                                        Text(favorite.overview)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                }
            }
            .navigationTitle(L10n.Favorites.favorites)
        }
    }
    
    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favorites[index])
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: FavoriteMovie.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    container.mainContext.insert(FavoriteMovie.preview)
    return FavoritesView().modelContainer(container)
}

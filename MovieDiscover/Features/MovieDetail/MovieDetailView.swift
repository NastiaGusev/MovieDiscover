//
//  MovieDetailView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {
    let movie: Movie

    @Environment(\.modelContext) private var modelContext
    @Query private var allFavorites: [FavoriteMovie]

    private var isFavorited: Bool {
        allFavorites.contains { $0.id == movie.id }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: movie.backdropURL ?? movie.posterURL) { phase in
                    if case .success(let image) = phase {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                    }
                }
                .frame(height: 220)
                .clipped()

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(movie.title)
                            .font(.title2)
                            .bold()

                        Spacer()

                        Button {
                            toggleFavorite()
                        } label: {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .foregroundStyle(isFavorited ? .red : .secondary)
                                .font(.title3)
                        }
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", movie.voteAverage))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Text(movie.overview)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleFavorite() {
        if let existing = allFavorites.first(where: { $0.id == movie.id }) {
            modelContext.delete(existing)
        } else {
            let favorite = FavoriteMovie(from: movie)
            modelContext.insert(favorite)
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(
            movie: Movie(
                id: 1,
                title: "Sample Movie",
                overview: "A short sample overview describing the plot of this preview movie.",
                posterPath: nil,
                backdropPath: nil,
                releaseDate: "2026-01-01",
                voteAverage: 7.8
            )
        )
    }
    .modelContainer(for: FavoriteMovie.self, inMemory: true)
}

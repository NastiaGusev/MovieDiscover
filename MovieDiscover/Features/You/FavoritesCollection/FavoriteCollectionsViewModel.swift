//
//  FavoriteCollectionsViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import Foundation

@Observable
final class FavoriteCollectionsViewModel {
    struct Collection: Identifiable {
        let title: String
        let movies: [FavoriteMovie]
        var id: String { title }
    }

    enum State { case idle, thinking, loaded([Collection]), unavailable, error }

    private(set) var state: State = .idle
    private let grouper: FavoriteGrouping

    init(grouper: FavoriteGrouping) {
        self.grouper = grouper
    }

    @MainActor
    func group(_ favorites: [FavoriteMovie]) async {
        guard favorites.count >= 4 else { state = .unavailable; return }
        if case .loaded = state { return }

        state = .thinking
        let summary = favorites.map(\.title).joined(separator: "\n")

        do {
            let groups = try await grouper.group(favorites: summary)

            // Map each returned title back to a stored favorite (case-insensitive).
            let byTitle = Dictionary(
                favorites.map { ($0.title.lowercased(), $0) },
                uniquingKeysWith: { a, _ in a }
            )

            var collections = groups.compactMap { group -> Collection? in
                let movies = group.movieTitles.compactMap { byTitle[$0.lowercased()] }
                return movies.isEmpty ? nil : Collection(title: group.title, movies: movies)
            }

            // Catch-all: any favorite the model didn't place goes in "More favorites"
            // so nothing silently disappears.
            let grouped = Set(collections.flatMap { $0.movies.map(\.id) })
            let leftovers = favorites.filter { !grouped.contains($0.id) }
            if !leftovers.isEmpty {
                collections.append(
                    Collection(title: String(localized: L10n.Collections.more), movies: leftovers)
                )
            }

            state = collections.isEmpty ? .unavailable : .loaded(collections)
        } catch is CancellationError {
            state = .idle
        } catch {
            state = .error
        }
    }
}

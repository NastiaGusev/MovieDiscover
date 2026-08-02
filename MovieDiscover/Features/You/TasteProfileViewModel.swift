//
//  TasteProfileViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import Foundation

@Observable
final class TasteProfileViewModel {
    enum State { case idle, thinking, loaded(TasteResult), unavailable, error }

    private(set) var state: State = .idle

    private let profiler: TasteProfiling
    private let genreProvider: GenreProvider

    init(profiler: TasteProfiling, genreProvider: GenreProvider = .shared) {
        self.profiler = profiler
        self.genreProvider = genreProvider
    }

    @MainActor
    func generate(from favorites: [FavoriteMovie]) async {
        guard favorites.count >= 3 else { state = .unavailable; return }
        if case .loaded = state { return }

        state = .thinking
        await genreProvider.loadIfNeeded()

        let summary = favorites.prefix(20).map { fav in
            let genres = (fav.genreIDs ?? []).compactMap { genreProvider.name(for: $0) }.joined(separator: ", ")
            let year = (fav.releaseDate?.prefix(4)).map(String.init) ?? "—"
            return "\(fav.title) (\(year)) — \(genres)"
        }.joined(separator: "\n")

        do {
            state = .loaded(try await profiler.profile(from: summary))
        } catch is CancellationError {
            state = .idle
        } catch {
            state = .error
        }
    }
}

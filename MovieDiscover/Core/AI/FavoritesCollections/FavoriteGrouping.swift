//
//  FavoriteGrouping.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import FoundationModels

struct GroupedCollection {
    let title: String
    let movieTitles: [String]
}

protocol FavoriteGrouping {
    func group(favorites: String) async throws -> [GroupedCollection]
}

@available(iOS 26.0, *)
struct FoundationModelFavoriteGrouper: FavoriteGrouping {
    func group(favorites: String) async throws -> [GroupedCollection] {
        let session = LanguageModelSession(
            instructions: """
            You organize someone's favorite films into evocative, specific themed \
            collections — by mood, theme, style, or who you'd watch them with (e.g. \
            "Movies for a rainy Sunday", "Unforgettable endings", "Female-led sci-fi"). \
            Use only the films provided. A film may appear in more than one collection. \
            Titles should be human and inviting, never generic like "Drama".
            """
        )
        let result = try await session.respond(
            to: "Their favorite films:\n\(favorites)",
            generating: FavoriteCollections.self
        ).content
        return result.collections.map { GroupedCollection(title: $0.title, movieTitles: $0.movieTitles) }
    }
}

#if DEBUG
struct MockFavoriteGrouper: FavoriteGrouping {
    func group(favorites: String) async throws -> [GroupedCollection] {
        [GroupedCollection(title: "Mind-bending movies", movieTitles: ["Inception", "Interstellar"]),
         GroupedCollection(title: "Movies for a rainy Sunday", movieTitles: ["Her"])]
    }
}
#endif

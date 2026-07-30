//
//  MovieIntentParsing.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import FoundationModels

protocol MovieIntentParsing {
    func parse(_ query: String) async throws -> ParsedIntent
}

struct ParsedIntent {
    let keywords: [String]
    let genreIDs: [Int]
}

@available(iOS 26.0, *)
struct FoundationModelIntentParser: MovieIntentParsing {
    private static let stopWords: Set<String> = [
        // genres
        "action","adventure","animation","comedy","crime","documentary","drama",
        "family","fantasy","history","horror","music","mystery","romance",
        "science fiction","sci-fi","scifi","thriller","war","western",
        // moods / abstractions that aren't concrete keywords
        "love","love story","story","dark","psychological","mood","vibe",
        "emotional","scary","funny","sad","happy","intense","feel-good"
    ]

    func parse(_ query: String) async throws -> ParsedIntent {
        let session = LanguageModelSession(
            instructions: """
            Extract search filters from a movie request.
            keywords: ONLY concrete, tangible things — creatures, objects, settings, or \
            plot devices (e.g. "dragon", "vampire", "island", "heist"). Use the SINGULAR \
            form ("dragon" not "dragons"). NEVER include genres, moods, or adjectives \
            (romance, dark, scary, psychological) — those are not keywords.
            genres: always choose at least one genre that fits, even for abstract or \
            mood-based requests.
            """
        )
        let intent = try await session.respond(to: query, generating: MovieSearchIntent.self).content
        let keywords = intent.keywords.filter { !Self.stopWords.contains($0.lowercased()) }
        return ParsedIntent(keywords: keywords, genreIDs: intent.genres.map(\.tmdbID))
    }
}

#if DEBUG
struct MockIntentParser: MovieIntentParsing {
    var result = ParsedIntent(keywords: ["dragon"], genreIDs: [10749]) // romance
    func parse(_ query: String) async throws -> ParsedIntent { result }
}
#endif

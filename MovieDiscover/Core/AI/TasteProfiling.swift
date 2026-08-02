//
//  TasteProfiling.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import FoundationModels

struct TasteResult {
    let enjoys: [String]
    let rarely: String
}

protocol TasteProfiling {
    func profile(from favorites: String) async throws -> TasteResult
}

@available(iOS 26.0, *)
struct FoundationModelTasteProfiler: TasteProfiling {
    func profile(from favorites: String) async throws -> TasteResult {
        let session = LanguageModelSession(
            instructions: """
            You analyze someone's favorite films and describe their taste concisely. \
            List specific patterns they enjoy (tone, character types, story shapes — \
            not just genres), and note what they rarely gravitate toward. Be specific \
            and observational, never generic or flattering.
            """
        )
        let result = try await session.respond(
            to: "Their favorite films:\n\(favorites)",
            generating: TasteProfile.self
        ).content
        return TasteResult(enjoys: result.enjoys, rarely: result.rarely)
    }
}

#if DEBUG
struct MockTasteProfiler: TasteProfiling {
    func profile(from favorites: String) async throws -> TasteResult {
        TasteResult(
            enjoys: ["character-driven sci-fi", "slow-burn thrillers",
                     "emotional coming-of-age stories", "morally grey protagonists"],
            rarely: "You rarely favorite broad comedies or action blockbusters."
        )
    }
}
#endif

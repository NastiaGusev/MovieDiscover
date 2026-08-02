//
//  TasteProfile.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import FoundationModels

@available(iOS 26.0, *)
@Generable
struct TasteProfile {
    @Guide(description: "3 to 5 short, specific phrases describing what this person enjoys — e.g. 'character-driven sci-fi', 'slow-burn thrillers'. Specific, not generic like 'good movies'.", .count(3...5))
    let enjoys: [String]

    @Guide(description: "One sentence naming what they rarely or never favorite, e.g. 'You rarely favorite broad comedies or action blockbusters.'")
    let rarely: String
}

//
//  FavoriteCollections.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import FoundationModels

@available(iOS 26.0, *)
@Generable
struct FavoriteCollections {
    @Guide(description: "3 to 5 themed groupings of the user's favorite films", .count(3...5))
    let collections: [FavoriteCollection]
}

@available(iOS 26.0, *)
@Generable
struct FavoriteCollection {
    @Guide(description: "An evocative collection title, e.g. 'Movies for a rainy Sunday', 'Mind-bending endings', 'Female-led sci-fi'")
    let title: String

    @Guide(description: "The exact titles of the user's favorite films that belong in this collection")
    let movieTitles: [String]
}

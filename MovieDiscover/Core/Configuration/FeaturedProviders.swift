//
//  FeaturedProviders.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

enum FeaturedProviders {
    // Curated priority order of mainstream services. IDs are TMDB's and stable
    // for these major providers; filtered against regional availability at runtime.
    static let ordered: [Int] = [
        8,     // Netflix
        119,   // Amazon Prime Video
        1899,  // HBO Max
        350    // Apple TV
    ]
}

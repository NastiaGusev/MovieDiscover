//
//  HomeDestinations.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import Foundation

struct MoodQuery: Hashable {
    let text: String
}

struct StreamingBrowserRoute: Hashable {}

struct SearchRoute: Hashable {}

struct GenreBrowseRoute: Hashable {
    let genres: [Genre]
    let selectedID: Int
}

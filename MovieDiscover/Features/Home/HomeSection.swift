//
//  HomeSection.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import Foundation

enum HomeSection: Identifiable {
    case moodBar(suggestions: [String])
    case row(HomeRow)
    case genreExplore([Genre])
    case whereToStream
    case forYou(blurb: String?, movies: [Movie])
    case insightTeaser(topGenre: String?)
    
    var id: String {
        switch self {
        case .moodBar: "moodBar"
        case .row(let row): "row-\(row.id)"
        case .genreExplore:   "genreExplore"
        case .whereToStream: "whereToStream"
        case .forYou: "forYou"
        case .insightTeaser: "insightTeaser"
        }
    }
}

struct HomeRow: Identifiable {
    let id: String
    let title: String
    let source: RowSource
    var cardSize: CardSize = .standard
    var movies: [Movie] = []
}

enum RowSource: Equatable, Hashable {
    case trending
    case genre(id: Int, name: String)
    case provider(id: Int, name: String)
}

enum CardSize {
    case hero
    case standard
    case compact
}

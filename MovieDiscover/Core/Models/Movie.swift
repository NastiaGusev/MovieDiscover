//
//  Movie.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

nonisolated struct Movie: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    
    var posterURL: URL? {
        posterPath.map { ImageConfig.url(path: $0, size: ImageConfig.Size.poster) } ?? nil
    }
    
    var backdropURL: URL? {
        backdropPath.map { ImageConfig.url(path: $0, size: ImageConfig.Size.backdrop) } ?? nil
    }
}

nonisolated struct MovieListResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}

extension FavoriteMovie {
    var asMovie: Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: nil,
            voteAverage: voteAverage
        )
    }
}

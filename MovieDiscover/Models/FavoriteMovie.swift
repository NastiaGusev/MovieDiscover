//
//  FavoriteMovie.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation
import SwiftData

@Model
final class FavoriteMovie {

    @Attribute(.unique) var id: Int
    var title: String
    var posterPath: String?
    var overview: String
    var voteAverage: Double
    var dateAdded: Date
 
    init(id: Int, title: String, posterPath: String?, overview: String, voteAverage: Double, dateAdded: Date = .now) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.overview = overview
        self.voteAverage = voteAverage
        self.dateAdded = dateAdded
    }

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}
 
extension FavoriteMovie {
    convenience init(from movie: Movie) {
        self.init(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            overview: movie.overview,
            voteAverage: movie.voteAverage
        )
    }
}

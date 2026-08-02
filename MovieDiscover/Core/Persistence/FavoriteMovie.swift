import Foundation
import SwiftData

@Model
final class FavoriteMovie {
    @Attribute(.unique) var id: Int
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var overview: String
    var voteAverage: Double
    var dateAdded: Date
    var releaseDate: String?
    var genreIDs: [Int]?

    init(id: Int, title: String, posterPath: String?, backdropPath: String?,
         overview: String, voteAverage: Double,
         releaseDate: String? = nil, genreIDs: [Int]? = nil,
         dateAdded: Date = .now) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.genreIDs = genreIDs
        self.dateAdded = dateAdded
    }

    var posterURL: URL? {
        posterPath.map { ImageConfig.url(path: $0, size: ImageConfig.Size.poster) } ?? nil
    }
}

extension FavoriteMovie {
    convenience init(from movie: Movie) {
        self.init(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            overview: movie.overview,
            voteAverage: movie.voteAverage,
            releaseDate: movie.releaseDate,
            genreIDs: movie.genreIDs
        )
    }
}

extension FavoriteMovie {
    var asMovie: Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            genreIDs: genreIDs
        )
    }
}

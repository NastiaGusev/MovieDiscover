//
//  MovieDetails+Preview.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

#if DEBUG
extension MovieDetails {
    static let preview = MovieDetails(
        id: 27205, title: "Inception",
        overview: "A thief who steals corporate secrets...",
        runtime: 148, genres: [Genre(id: 28, name: "Action"), Genre(id: 878, name: "Sci-Fi")],
        tagline: "Your mind is the scene of the crime.",
        voteAverage: 8.4, releaseDate: "2010-07-16",
        backdropPath: "/s3TBrRGB1iav7gFOCNx3H31MoES.jpg"
    )
}

extension FavoriteMovie {
    static var preview: FavoriteMovie { FavoriteMovie(from: .preview) }
}
#endif

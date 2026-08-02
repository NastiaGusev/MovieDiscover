//
//  Movie+Preview.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

#if DEBUG
import Foundation

extension Movie {
    static let preview = Movie(
        id: 27205,
        title: "Inception",
        overview: "A thief who steals corporate secrets through dream-sharing technology.",
        posterPath: "/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg",
        backdropPath: "/s3TBrRGB1iav7gFOCNx3H31MoES.jpg",
        releaseDate: "2010-07-16",
        voteAverage: 8.4,
        genreIDs: []
    )
    
    static let previewList: [Movie] = [
        .preview,
        Movie(id: 157336,
              title: "Interstellar",
              overview: "A team of explorers travel through a wormhole in space.",
              posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
              backdropPath: "/xJHokMbljvjADYdit5fK5VQsXEG.jpg",
              releaseDate: "2014-11-05",
              voteAverage: 8.4,
              genreIDs: [])
    ]
}
#endif

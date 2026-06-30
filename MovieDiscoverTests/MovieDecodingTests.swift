//
//  MovieDecodingTests.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//
import Testing
import Foundation
@testable import MovieDiscover

struct MovieDecodingTests {

    @MainActor @Test func decodesMovieListResponseFromTMDBShapedJSON() throws {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": 42,
                    "title": "Test Movie",
                    "overview": "A movie used only for testing.",
                    "poster_path": "/abc123.jpg",
                    "backdrop_path": null,
                    "release_date": "2026-01-15",
                    "vote_average": 8.4
                }
            ],
            "total_pages": 5,
            "total_results": 100
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(MovieListResponse.self, from: json)

        #expect(response.page == 1)
        #expect(response.totalPages == 5)
        #expect(response.results.count == 1)

        let movie = response.results[0]
        #expect(movie.id == 42)
        #expect(movie.title == "Test Movie")
        #expect(movie.posterPath == "/abc123.jpg")
        #expect(movie.backdropPath == nil)
        #expect(movie.voteAverage == 8.4)
    }

    @Test func posterURLBuildsCorrectlyFromPath() {
        let movie = Movie(
            id: 1,
            title: "Test",
            overview: "Test overview",
            posterPath: "/xyz789.jpg",
            backdropPath: nil,
            releaseDate: "2026-01-01",
            voteAverage: 5.0
        )

        #expect(movie.posterURL?.absoluteString == "https://image.tmdb.org/t/p/w500/xyz789.jpg")
    }

    @Test func posterURLIsNilWhenPathIsMissing() {
        let movie = Movie(
            id: 1,
            title: "Test",
            overview: "Test overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2026-01-01",
            voteAverage: 5.0
        )

        #expect(movie.posterURL == nil)
    }
}

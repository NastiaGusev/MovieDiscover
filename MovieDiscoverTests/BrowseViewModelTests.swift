//
//  BrowseViewModelTests.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//
import Testing
@testable import MovieDiscover

struct BrowseViewModelTests {

    @Test func loadTrendingMoviesSucceedsAndPopulatesMovies() async {
        let mockClient = MockAPIClient()
        let sampleMovie = Movie(
            id: 1,
            title: "Mock Movie",
            overview: "Overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2026-01-01",
            voteAverage: 7.0
        )
        mockClient.resultToReturn = MovieListResponse(
            page: 1,
            results: [sampleMovie],
            totalPages: 1,
            totalResults: 1
        )

        let viewModel = await BrowseViewModel(apiClient: mockClient)

        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.isLoading == false)

        await viewModel.loadTrendingMovies()

        #expect(viewModel.movies.count == 1)
        await #expect(viewModel.movies.first?.title == "Mock Movie")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test func loadTrendingMoviesSetsErrorMessageOnFailure() async {
        let mockClient = MockAPIClient()
        mockClient.errorToThrow = APIError.noInternetConnection

        let viewModel = await BrowseViewModel(apiClient: mockClient)

        await viewModel.loadTrendingMovies()

        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }
}

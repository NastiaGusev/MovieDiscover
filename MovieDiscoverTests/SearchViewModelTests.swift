//
//  SearchViewModelTests.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Testing
@testable import MovieDiscover

@MainActor struct SearchViewModelTests {

    @Test func emptyQueryClearsResultsImmediately() {
        let mockClient = MockAPIClient()
        let viewModel = SearchViewModel(apiClient: mockClient)

        viewModel.query = "batman"
        viewModel.query = ""

        // No await needed here — clearing on empty query happens
        // synchronously in didSet, with no debounce delay.
        #expect(viewModel.results.isEmpty)
    }

    @Test func whitespaceOnlyQueryIsTreatedAsEmpty() {
        let mockClient = MockAPIClient()
        let viewModel = SearchViewModel(apiClient: mockClient)

        viewModel.query = "   "

        #expect(viewModel.results.isEmpty)
    }

    @Test func searchEventuallyPopulatesResults() async throws {
        let mockClient = MockAPIClient()
        let sampleMovie = Movie(
            id: 99,
            title: "Searched Movie",
            overview: "Overview",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2026-01-01",
            voteAverage: 6.5
        )
        mockClient.resultToReturn = MovieListResponse(
            page: 1,
            results: [sampleMovie],
            totalPages: 1,
            totalResults: 1
        )

        let viewModel = SearchViewModel(apiClient: mockClient, debounceMilliseconds: 0)
        viewModel.query = "searched"

        try await Task.sleep(for: .milliseconds(50))

        #expect(viewModel.results.count == 1)
        #expect(viewModel.results.first?.title == "Searched Movie")
    }
}

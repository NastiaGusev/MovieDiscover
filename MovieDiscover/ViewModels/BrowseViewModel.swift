//
//  BrowseViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

@Observable
final class BrowseViewModel {
    private(set) var movies: [Movie] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    func loadTrendingMovies() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: MovieListResponse = try await APIClient.shared.request(.trendingMovies)
            movies = response.results
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
}
}

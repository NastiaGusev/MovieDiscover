//
//  BrowseViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

@Observable
final class BrowseViewModel {
    enum State {
        case loading
        case loaded([Movie])
        case error(String)
    }
    
    private(set) var genres: [Genre] = []
    private(set) var selectedGenreID: Int?
    private(set) var state: State = .loading
    
    private let apiClient: APIClientProtocol
    private var didLoad = false
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    @MainActor
    func onAppear() async {
        guard !didLoad else { return }
        didLoad = true
        await loadMovies()
        await loadGenres()
    }
    
    @MainActor
    func select(genreID: Int?) async {
        selectedGenreID = genreID
        await loadMovies()
    }
    
    @MainActor
    private func loadGenres() async {
        do {
            let response: GenreListResponse = try await apiClient.request(.genreList)
            genres = response.genres
        } catch {
            // non-fatal — bar just shows Trending only
        }
    }
    
    @MainActor
    private func loadMovies() async {
        state = .loading
        do {
            let response: MovieListResponse = if let id = selectedGenreID {
                try await apiClient.request(.discoverByGenre(genreID: id))
            } else {
                try await apiClient.request(.trendingMovies)
            }
            state = .loaded(response.results)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

//
//  BrowseViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

@Observable
final class BrowseViewModel {
    enum State { case loading, loaded, error(String) }

    private(set) var state: State = .loading
    private(set) var genres: [Genre] = []
    private(set) var selectedGenreID: Int?

    private let apiClient: APIClient
    private var pager: MoviePager
    private var didLoad = false

    var movies: [Movie] { pager.movies }

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
        self.pager = MoviePager { page in
            try await apiClient.request(.trendingMovies(page: page))
        }
    }

    @MainActor
    func onAppear() async {
        guard !didLoad else { return }
        didLoad = true
        await loadFirstPage()
        await loadGenres()
    }

    @MainActor
    func select(genreID: Int?) async {
        selectedGenreID = genreID
        await loadFirstPage()
    }

    @MainActor
    func loadMore() async {
        try? await pager.loadNext()
    }

    @MainActor
    private func loadFirstPage() async {
        pager = makePager()
        state = .loading
        do {
            try await pager.loadNext()
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func makePager() -> MoviePager {
        let apiClient = self.apiClient
        if let id = selectedGenreID {
            return MoviePager { page in try await apiClient.request(.discoverByGenre(genreID: id, page: page)) }
        } else {
            return MoviePager { page in try await apiClient.request(.trendingMovies(page: page)) }
        }
    }

    @MainActor
    private func loadGenres() async {
        do {
            let response: GenreListResponse = try await apiClient.request(.genreList)
            genres = response.genres
        } catch { }
    }
}

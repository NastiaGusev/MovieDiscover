//
//  HomeViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import Foundation

@Observable
final class HomeViewModel {
    private(set) var sections: [HomeSection] = []
    private(set) var heroBackdropURL: URL?
    private(set) var genreImages: [Int: URL] = [:]

    private let apiClient: APIClient
    private let region: String
    private var didLoad = false

    private static let suggestions = [
        "a slow-burn 90s thriller",
        "dragons and romance",
        "feel-good space adventure"
    ]

    init(apiClient: APIClient = .shared,
         region: String = Locale.current.region?.identifier ?? API.region) {
        self.apiClient = apiClient
        self.region = region
    }

    @MainActor
    func onAppear(favorites: [FavoriteMovie]) async {
        guard !didLoad else { return }
        didLoad = true

        let genres = await loadGenres()

        sections = [
            .moodBar(suggestions: Self.suggestions),
            .forYou(blurb: nil, movies: []),
            .row(HomeRow(id: "trending",
                         title: String(localized: L10n.Home.trending),
                         source: .trending, cardSize: .hero)),
            .genreExplore(Array(genres.prefix(9))),
            .whereToStream
        ]

        await loadTrending()
        await loadGenreImages(Array(genres.prefix(9)))
        await loadRecommended(favorites: favorites)
    }

    @MainActor
    private func loadRecommended(favorites: [FavoriteMovie]) async {
        let genreIDs = favorites.flatMap { $0.genreIDs ?? [] }
        let favoriteIDs = Set(favorites.map(\.id))

        guard let topGenre = mostCommon(genreIDs) else {
            sections.removeAll { $0.id == "forYou" }
            return
        }
        do {
            let response: MovieListResponse = try await apiClient.request(
                .discoverByGenre(genreID: topGenre, page: 1))
            let filtered = response.results.filter { !favoriteIDs.contains($0.id) }
            if filtered.isEmpty {
                sections.removeAll { $0.id == "forYou" }
            } else {
                updateForYou(movies: filtered)
            }
        } catch {
            sections.removeAll { $0.id == "forYou" }
        }
    }

    // MARK: - RowSource → Endpoint (reused by rows and See-all pager)

    static func endpoint(for source: RowSource, region: String, page: Int) -> Endpoint {
        switch source {
        case .trending:              .trendingMovies(page: page)
        case .genre(let id, _):      .discoverByGenre(genreID: id, page: page)
        case .provider(let id, _):   .discoverByProvider(providerIDs: [id], region: region, page: page)
        }
    }

    func makePager(for source: RowSource) -> MoviePager {
        let apiClient = self.apiClient
        let region = self.region
        return MoviePager { page in
            try await apiClient.request(Self.endpoint(for: source, region: region, page: page))
        }
    }

    // MARK: - Loading

    private func loadGenres() async -> [Genre] {
        do {
            let response: GenreListResponse = try await apiClient.request(.genreList)
            return response.genres
        } catch {
            return []
        }
    }

    @MainActor
    private func loadTrending() async {
        do {
            let response: MovieListResponse = try await apiClient.request(.trendingMovies(page: 1))
            let movies = response.results
            guard !movies.isEmpty else { return }
            heroBackdropURL = movies.first?.backdropURL ?? movies.first?.posterURL
            updateRow(id: "trending", movies: movies)
        } catch { }
    }

    @MainActor
    private func loadGenreImages(_ genres: [Genre]) async {
        let apiClient = self.apiClient
        await withTaskGroup(of: (Int, URL?).self) { group in
            for genre in genres {
                group.addTask {
                    do {
                        let response: MovieListResponse = try await apiClient.request(
                            .discoverByGenre(genreID: genre.id, page: 1))
                        return await (genre.id, response.results.first?.posterURL)
                    } catch {
                        return (genre.id, nil)
                    }
                }
            }
            for await (id, url) in group {
                if let url { genreImages[id] = url }
            }
        }
    }

    private func mostCommon(_ ids: [Int]) -> Int? {
        var tally: [Int: Int] = [:]
        for id in ids { tally[id, default: 0] += 1 }
        return tally.sorted { $0.value > $1.value }.first?.key
    }

    // MARK: - In-place section updates

    @MainActor
    private func updateRow(id: String, movies: [Movie]) {
        guard let idx = sections.firstIndex(where: { $0.id == "row-\(id)" }),
              case .row(var row) = sections[idx] else { return }
        row.movies = movies
        sections[idx] = .row(row)
    }

    @MainActor
    private func updateForYou(movies: [Movie]) {
        guard let idx = sections.firstIndex(where: { $0.id == "forYou" }) else { return }
        sections[idx] = .forYou(blurb: nil, movies: movies)
    }
}

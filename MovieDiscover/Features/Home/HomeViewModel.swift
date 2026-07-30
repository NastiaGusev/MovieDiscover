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
    
    private let apiClient: APIClient
    private let region: String
    private var didLoad = false
    
    private(set) var genreImages: [Int: URL] = [:]
    
    // Example prompts shown in the mood bar. Plain strings for now — move to L10n if you localize them.
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
    func onAppear() async {
        guard !didLoad else { return }
        didLoad = true
        
        let genres = await loadGenres()
        
        sections = [
            .moodBar(suggestions: Self.suggestions),
            .row(HomeRow(id: "trending",
                         title: String(localized: L10n.Home.trending),
                         source: .trending,
                         cardSize: .hero)),
            .genreExplore(Array(genres.prefix(9))),
            .whereToStream,
            .insightTeaser(topGenre: nil)
        ]
        
        await loadTrending()
        await loadGenreImages(Array(genres.prefix(9)))
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
                        return (genre.id, response.results.first?.posterURL)
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
    
    // The RowSource → Endpoint mapping. Static so it captures no `self`, and reused
    // by both the row fetch here and the "see all" pager below.
    static func endpoint(for source: RowSource, region: String, page: Int) -> Endpoint {
        switch source {
        case .trending:              .trendingMovies(page: page)
        case .genre(let id, _):      .discoverByGenre(genreID: id, page: page)
        case .provider(let id, _):   .discoverByProvider(providerIDs: [id], region: region, page: page)
        }
    }
    
    // "See all" reuses your MoviePager — one line to get a fully paginated grid for any row.
    func makePager(for source: RowSource) -> MoviePager {
        let apiClient = self.apiClient
        let region = self.region
        return MoviePager { page in
            try await apiClient.request(Self.endpoint(for: source, region: region, page: page))
        }
    }
    
    // MARK: - Loading
    
    @MainActor
    private func loadTrending() async {
        do {
            let response: MovieListResponse = try await apiClient.request(.trendingMovies(page: 1))
            let movies = response.results
            guard !movies.isEmpty else { return }
            // Top trending becomes the spotlight; the rest fill the row, so the hero
            // film isn't duplicated as the first card in the row right below it.
            heroBackdropURL = movies.first?.backdropURL ?? movies.first?.posterURL
            updateRow(id: "trending", movies: movies)
        } catch { }
    }
    
    private func loadGenres() async -> [Genre] {
        do {
            let response: GenreListResponse = try await apiClient.request(.genreList)
            return response.genres
        } catch {
            return []
        }
    }
    
    // MARK: - In-place section updates
    
    @MainActor
    private func update(_ section: HomeSection) {
        if let idx = sections.firstIndex(where: { $0.id == section.id }) {
            sections[idx] = section
        }
    }
    
    @MainActor
    private func updateRow(id: String, movies: [Movie]) {
        guard let idx = sections.firstIndex(where: { $0.id == "row-\(id)" }),
              case .row(var row) = sections[idx] else { return }
        row.movies = movies
        sections[idx] = .row(row)
    }
}

//
//  HomeView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var streamingViewModel = StreamingViewModel()
    @State private var path = NavigationPath()
    @Query private var favorites: [FavoriteMovie]

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Spacing.lg) {
                    ForEach(viewModel.sections) { section in
                        sectionView(section)
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { path.append(SearchRoute()) } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white)
                    }
                }
            }
            .task {
                await viewModel.onAppear(favorites: favorites)

            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .navigationDestination(for: RowSource.self) { source in
                SeeAllView(title: title(for: source), pager: viewModel.makePager(for: source))
            }
            .navigationDestination(for: MoodQuery.self) { query in
                MoodSearchEntry.make(initialQuery: query.text)
            }
            .navigationDestination(for: StreamingBrowserRoute.self) { _ in
                StreamingBrowserView(viewModel: streamingViewModel)
            }
            .navigationDestination(for: SearchRoute.self) { _ in
                SearchView()
            }
            .navigationDestination(for: GenreBrowseRoute.self) { route in
                if let selected = route.genres.first(where: { $0.id == route.selectedID }) {
                    GenreBrowseView(genres: route.genres, selected: selected)
                }
            }
        }
    }

    @ViewBuilder
    private func sectionView(_ section: HomeSection) -> some View {
        switch section {
        case .moodBar(let suggestions):
            HomeMoodBar(suggestions: suggestions,
                        backdropURL: viewModel.heroBackdropURL) { query in
                path.append(MoodQuery(text: query))
            }
        case .forYou(_, let movies):
            if !movies.isEmpty {
                MovieCarousel(title: String(localized: L10n.Home.recommended),
                              movies: movies)
            }
        case .row(let row):
            MovieCarousel(title: row.title, movies: row.movies, cardSize: row.cardSize) {
                path.append(row.source)
            }
        case .genreExplore(let genres):
            GenreExploreGrid(genres: genres, images: viewModel.genreImages) { genre in
                path.append(GenreBrowseRoute(genres: genres, selectedID: genre.id))
            }
        case .whereToStream:
            StreamingSectionView(viewModel: streamingViewModel,
                                 onSeeAll: { path.append(StreamingBrowserRoute()) })
        }
    }

    private func title(for source: RowSource) -> String {
        switch source {
        case .trending: String(localized: L10n.Home.trending)
        case .genre(_, let name): name
        case .provider(_, let name): name
        }
    }
}

#Preview {
    HomeView()
}

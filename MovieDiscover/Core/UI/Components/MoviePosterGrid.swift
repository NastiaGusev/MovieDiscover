//
//  MoviePosterGrid.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import SwiftUI

struct MoviePosterGrid: View {
    let movies: [Movie]
    let columnCount: Int
    var onReachEnd: (() async -> Void)? = nil

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: Spacing.sm), count: columnCount)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Spacing.sm) {
                ForEach(movies) { movie in
                    NavigationLink { MovieDetailView(movie: movie) } label: {
                        MoviePosterCell(movie: movie)
                    }
                    .onAppear {
                        if movie.id == movies.last?.id {
                            Task { await onReachEnd?() }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

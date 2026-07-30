//
//  SeeAllView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI

struct SeeAllView: View {
    let title: String
    @State private var pager: MoviePager
    @State private var didLoad = false
    
    init(title: String, pager: MoviePager) {
        self.title = title
        _pager = State(initialValue: pager)
    }
    
    var body: some View {
        MoviePosterGrid(
            movies: pager.movies,
            columnCount: GridColumns.genre,
            onReachEnd: { try? await pager.loadNext() }
        )
        .navigationTitle(title)
        .task {
            guard !didLoad else { return }
            didLoad = true
            try? await pager.loadNext()
        }
    }
}

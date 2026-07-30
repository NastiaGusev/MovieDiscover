//
//  BrowseView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import SwiftUI

struct BrowseView: View {
    @State private var viewModel = BrowseViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                genreBar
                    .padding(.vertical, Spacing.sm)
                content
            }
            .navigationTitle("Browse")
            .task { await viewModel.onAppear() }
        }
    }
    
    private var genreBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                pill(title: String(localized: "Trending"),
                     isSelected: viewModel.selectedGenreID == nil) {
                    Task { await viewModel.select(genreID: nil) }
                }
                ForEach(viewModel.genres) { genre in
                    pill(title: genre.name,
                         isSelected: viewModel.selectedGenreID == genre.id) {
                        Task { await viewModel.select(genreID: genre.id) }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func pill(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, Spacing.sm)
                .background(isSelected ? Color.accentColor : Color.gray.opacity(0.15))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
    
    private var columns: [GridItem] {
        let count = viewModel.selectedGenreID == nil ? GridColumns.trending : GridColumns.genre
        return Array(repeating: GridItem(.flexible(), spacing: Spacing.sm), count: count)
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error(let message):
            Text(message).foregroundStyle(.secondary)
        case .loaded:
            MoviePosterGrid(
                movies: viewModel.movies,
                columnCount: viewModel.selectedGenreID == nil ? GridColumns.trending : GridColumns.genre,
                onReachEnd: { Task { await viewModel.loadMore() } }
            )
        }
    }
}

#Preview {
    BrowseView()
}

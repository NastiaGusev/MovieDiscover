//
//  MoodSearchView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import SwiftUI

struct MoodSearchView: View {
    @State private var viewModel: MoodSearchViewModel
    private let initialQuery: String?
    
    init(viewModel: MoodSearchViewModel, initialQuery: String? = nil) {
        _viewModel = State(initialValue: viewModel)
        self.initialQuery = initialQuery
    }
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            promptField
            content
        }
        .padding(.horizontal)
        .navigationTitle(String(localized: L10n.MoodSearch.title))
        .task {
            if let initialQuery, viewModel.query.isEmpty {
                viewModel.query = initialQuery
                await viewModel.search()
            }
        }
    }
    
    private var promptField: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "sparkles")
                .foregroundStyle(.secondary)
            
            TextField(L10n.MoodSearch.placeholder, text: $viewModel.query, axis: .vertical)
                .lineLimit(1...3)
                .frame(minHeight: 32)
                .onSubmit { Task { await viewModel.search() } }
            
            if !viewModel.query.isEmpty {
                Button {
                    viewModel.reset()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.placeholder)
        .clipShape(Capsule())
        .padding(.top, Spacing.sm)
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView(
                L10n.MoodSearch.idleTitle,
                systemImage: "sparkles",
                description: Text(L10n.MoodSearch.idleDescription)
            )
        case .thinking:
            VStack(spacing: Spacing.sm) {
                ProgressView()
                Text(L10n.MoodSearch.thinking).font(.caption).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .results:
            MoviePosterGrid(
                movies: viewModel.movies,
                columnCount: GridColumns.genre,
                onReachEnd: { await viewModel.loadMore() }
            )
        case .empty:
            ContentUnavailableView.search
        case .error(let message):
            ContentUnavailableView(
                L10n.MoodSearch.errorTitle,
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
}

#if DEBUG
#Preview {
    MoodSearchView(viewModel: MoodSearchViewModel(parser: MockIntentParser()))
}
#endif

//
//  SmartSearchView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import SwiftUI

struct SmartSearchView: View {
    @State private var viewModel: SmartSearchViewModel
    
    init(viewModel: SmartSearchViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.md) {
                promptField
                content
            }
            .padding(.horizontal)
            .navigationTitle(L10n.SmartSearch.title)
        }
    }
    
    private var promptField: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "sparkles")
                .foregroundStyle(.secondary)
            
            TextField(L10n.SmartSearch.placeholder, text: $viewModel.query, axis: .vertical)
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
                L10n.SmartSearch.idleTitle,
                systemImage: "sparkles",
                description: Text(L10n.SmartSearch.idleDescription)
            )
        case .thinking:
            VStack(spacing: Spacing.sm) {
                ProgressView()
                Text(L10n.SmartSearch.thinking).font(.caption).foregroundStyle(.secondary)
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
                L10n.SmartSearch.errorTitle,
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
}

#if DEBUG
#Preview {
    SmartSearchView(viewModel: SmartSearchViewModel(parser: MockIntentParser()))
}
#endif

//
//  MovieDetailView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {
    let movie: Movie
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    @Query private var allFavorites: [FavoriteMovie]
    
    @State private var viewModel: MovieDetailViewModel
    @State private var showTrailer = false
    
    init(movie: Movie) {
        self.movie = movie
        _viewModel = State(initialValue: MovieDetailViewModel(movieID: movie.id))
    }
    
    private var isFavorited: Bool {
        allFavorites.contains { $0.id == movie.id }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                backdrop
                
                VStack(alignment: .leading, spacing: Spacing.md) {
                    header
                    ratingRow
                    metadataRow
                    taglineView
                    Text(movie.overview).font(.body)
                    trailerButton
                    detailStatus
                    castSection
                    providersSection
                    recommendedSection
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .sheet(isPresented: $showTrailer) {
            if let key = viewModel.trailerKey, let url = ExternalURL.youTube(key: key) {
                SafariView(url: url)
            }
        }
    }
    
    private var backdropURL: URL? {
        if case .loaded(let details) = viewModel.state {
            return details.backdropURL ?? movie.backdropURL ?? movie.posterURL
        }
        return movie.backdropURL
    }
    
    private var backdrop: some View {
        AsyncImage(url: backdropURL) { phase in
            if case .success(let image) = phase {
                image.resizable().aspectRatio(contentMode: .fit)
            } else {
                Rectangle().fill(Color.placeholder)
                    .aspectRatio(AspectRatio.backDrop, contentMode: .fit)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var header: some View {
        HStack {
            Text(movie.title).font(.title2).bold()
            Spacer()
            Button(action: toggleFavorite) {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorited ? .red : .secondary)
                    .font(.title3)
            }
        }
    }
    
    private var ratingRow: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "star.fill").foregroundStyle(.yellow).font(.caption)
            Text(String(format: "%.1f", movie.voteAverage))
                .font(.subheadline).foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var metadataRow: some View {
        if case .loaded(let d) = viewModel.state {
            let parts = [
                d.releaseYear,
                d.genres.isEmpty ? nil : d.genres.map(\.name).joined(separator: "/"),
                d.formattedRuntime
            ].compactMap { $0 }
            
            if !parts.isEmpty {
                Text(parts.joined(separator: " ‧ "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var taglineView: some View {
        if case .loaded(let d) = viewModel.state, let tagline = d.tagline, !tagline.isEmpty {
            Text(tagline).font(.subheadline).italic().foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var trailerButton: some View {
        if viewModel.trailerKey != nil {
            Button { showTrailer = true } label: {
                Label(L10n.Detail.trailer, systemImage: "play.circle.fill")
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    private var detailStatus: some View {
        switch viewModel.state {
        case .loading:
            ProgressView().frame(maxWidth: .infinity)
        case .error(let message):
            Text(message).font(.caption).foregroundStyle(.red)
        case .loaded:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var castSection: some View {
        if !viewModel.cast.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(L10n.Detail.cast).font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.md) {
                        ForEach(viewModel.cast) { member in
                            VStack(spacing: Spacing.xs) {
                                AsyncImage(url: member.profileURL) { phase in
                                    if case .success(let img) = phase {
                                        img.resizable().aspectRatio(contentMode: .fill)
                                    } else {
                                        Circle().fill(Color.placeholder)
                                    }
                                }
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                Text(member.name).font(.caption).lineLimit(1)
                                Text(member.character).font(.caption2)
                                    .foregroundStyle(.secondary).lineLimit(1)
                                
                            }
                            .frame(width: 80)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var recommendedSection: some View {
        if !viewModel.recommendations.isEmpty {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(L10n.Detail.recommended).font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.md) {
                        ForEach(viewModel.recommendations) { rec in
                            NavigationLink {
                                MovieDetailView(movie: rec)
                            } label: {
                                MoviePosterCell(movie: rec)
                                    .frame(width: 100)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var providersSection: some View {
        if case .loaded = viewModel.state {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(L10n.Detail.whereToWatch).font(.headline)
                if let flatrate = viewModel.providers?.flatrate, !flatrate.isEmpty {
                    HStack(spacing: 10) {
                        ForEach(flatrate) { provider in
                            AsyncImage(url: provider.logoURL) { phase in
                                if case .success(let img) = phase {
                                    img.resizable().aspectRatio(contentMode: .fit)
                                } else {
                                    RoundedRectangle(cornerRadius: CornerRadius.md).fill(Color.placeholder)
                                }
                            }
                            .frame(width: 44, height: 44)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        }
                    }
                } else {
                    Text(L10n.Error.streamingNotAvailableInRegion)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private func toggleFavorite() {
        if let existing = allFavorites.first(where: { $0.id == movie.id }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(FavoriteMovie(from: movie))
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movie: .preview)
    }
    .modelContainer(for: FavoriteMovie.self, inMemory: true)
}

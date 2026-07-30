//
//  HomeWhereToStream.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI

struct StreamingSectionView: View {
    let viewModel: StreamingViewModel
    let onSeeAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            header
            providerChips
            resultsRow
        }
        .task { await viewModel.loadProviders() }
    }
    
    private var header: some View {
        HStack {
            Text(String(localized: L10n.Home.whereToStream)).font(.title3.bold())
            Spacer()
            if !viewModel.providers.isEmpty {
                Button(String(localized: L10n.Home.seeAll)) { onSeeAll() }
                    .font(.subheadline)
            }
        }
        .padding(.horizontal)
    }
    
    private var providerChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.md) {
                ForEach(viewModel.providers) { provider in
                    Button {
                        Task { await viewModel.select(provider.providerId) }
                    } label: {
                        Button {
                            Task { await viewModel.select(provider.providerId) }
                        } label: {
                            CachedAsyncImage(url: provider.logoURL) { image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: CornerRadius.md).fill(Color.placeholder)
                            }
                            .frame(width: 44, height: 44)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadius.md)
                                    .stroke(.tint, lineWidth: viewModel.selectedProviderID == provider.providerId ? 2 : 0)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var resultsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.md) {
                if case .loaded = viewModel.state {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(value: movie) {
                            MoviePosterCell(movie: movie).frame(width: 110)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    ForEach(0..<5, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: CornerRadius.sm)
                            .fill(Color.placeholder)
                            .frame(width: 110, height: 165)
                    }
                }
            }
            .padding(.horizontal)
        }
        .redacted(reason: { if case .loaded = viewModel.state { return [] } else { return .placeholder } }())
    }
    
    private var selectedProvider: Provider? {
        viewModel.providers.first { $0.providerId == viewModel.selectedProviderID }
    }
}

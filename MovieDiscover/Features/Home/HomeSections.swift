//
//  HomeSections.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI

struct HomeMoodBar: View {
    let suggestions: [String]
    var backdropURL: URL? = nil
    let onSubmit: (String) -> Void
    @State private var text = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: L10n.Home.title))
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            
            searchField
            
            suggestionChips
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.bottom, Spacing.lg)
        .frame(maxWidth: .infinity, minHeight: 260, alignment: .bottomLeading)
        .background(heroBackground)
        .safeAreaPadding(.top)
    }
    
    private var heroBackground: some View {
        ZStack {
            LinearGradient.hero
            if let backdropURL {
                CachedAsyncImage(url: backdropURL) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: { Color.clear }
            }
            LinearGradient(colors: [.black.opacity(0.1), .black.opacity(0.6)],
                           startPoint: .top, endPoint: .bottom)
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private var searchField: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "sparkles").foregroundStyle(.white.opacity(0.9))
            TextField("", text: $text,
                      prompt: Text(String(localized: L10n.MoodSearch.placeholder))
                .foregroundColor(.white.opacity(0.7)))
            .foregroundStyle(.white)
            .tint(.white)
            .onSubmit { fire(text) }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.md)
        .background(.white.opacity(0.20))
        .clipShape(Capsule())
    }
    
    private var suggestionChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button { onSubmit(suggestion) } label: {
                        Text(suggestion)
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal, Spacing.md)
                            .padding(.vertical, Spacing.xs)
                            .background(.white.opacity(0.18))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
        .padding(.horizontal, -Spacing.lg)
    }
    
    private func fire(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        onSubmit(trimmed)
    }
}

struct HomeInsightTeaser: View {
    let topGenre: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(String(localized: L10n.Home.insightTitle)).font(.headline)
                Text(String(localized: L10n.Home.insightSubtitle))
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chart.bar.fill").font(.title2).foregroundStyle(.tint)
        }
        .padding()
        .background(Color.placeholder)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .padding(.horizontal)
    }
}

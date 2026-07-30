//
//  GenreExploreGrid.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI

struct GenreExploreGrid: View {
    let genres: [Genre]
    let images: [Int: URL]
    let onSelect: (Genre) -> Void
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: Spacing.sm),
        count: 3                                   // 3×3
    )
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(String(localized: L10n.Home.exploreGenres))
                .font(.title3.bold())
                .padding(.horizontal, Spacing.lg)
            
            LazyVGrid(columns: columns, spacing: Spacing.sm) {
                ForEach(genres) { genre in
                    Button { onSelect(genre) } label: {
                        tile(for: genre)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
    
    private func tile(for genre: Genre) -> some View {
        ZStack {
            CachedAsyncImage(url: images[genre.id]) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.brand.opacity(0.3)
            }
            LinearGradient(colors: [.black.opacity(0.15), .black.opacity(0.7)],
                           startPoint: .top, endPoint: .bottom)
            Text(genre.name)
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(Spacing.xs)
        }
        .frame(height: 110)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

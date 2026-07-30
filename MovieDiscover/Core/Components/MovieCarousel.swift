//
//  MovieCarousel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI

struct MovieCarousel: View {
    let title: String
    let movies: [Movie]
    var cardSize: CardSize = .standard
    var onSeeAll: (() -> Void)? = nil
    
    private var width: CGFloat {
        switch cardSize {
        case .hero: 160
        case .standard: 110
        case .compact: 90
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(title).font(.title3.bold())
                Spacer()
                if let onSeeAll {
                    Button(String(localized: L10n.Home.seeAll), action: onSeeAll)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.md) {
                    if movies.isEmpty {
                        ForEach(0..<5, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: CornerRadius.sm)
                                .fill(Color.placeholder)
                                .frame(width: width, height: width * 3 / 2)
                        }
                    } else {
                        ForEach(movies) { movie in
                            NavigationLink(value: movie) {
                                MoviePosterCell(movie: movie).frame(width: width)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .redacted(reason: movies.isEmpty ? .placeholder : [])
        }
    }
}

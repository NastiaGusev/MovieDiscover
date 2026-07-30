//
//  MoviePosterCell.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import SwiftUI

struct MoviePosterCell: View {
    let movie: Movie
    
    var body: some View {
        AsyncImage(url: movie.posterURL) { phase in
            if case .success(let image) = phase {
                image.resizable().aspectRatio(contentMode: .fill)
            } else {
                Rectangle().fill(Color.placeholder)
            }
        }
        .aspectRatio(AspectRatio.poster, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
    }
}

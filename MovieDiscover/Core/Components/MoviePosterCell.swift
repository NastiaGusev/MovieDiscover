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
        CachedAsyncImage(url: movie.posterURL) { image in
            image.resizable().aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle().fill(Color.placeholder)
        }
        .aspectRatio(AspectRatio.poster, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.sm))
    }
}

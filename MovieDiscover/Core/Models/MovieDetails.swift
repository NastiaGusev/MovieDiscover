//
//  MovieDetails.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 28/07/2026.
//
import Foundation

nonisolated struct MovieDetails: Codable {
    let id: Int
    let title: String
    let overview: String
    let runtime: Int?
    let genres: [Genre]
    let tagline: String?
    let voteAverage: Double
    let releaseDate: String?
    let backdropPath: String?
    
    var backdropURL: URL? {
            backdropPath.map { ImageConfig.url(path: $0, size: ImageConfig.Size.backdrop) } ?? nil
        }
    
    var releaseYear: String? {
        guard let releaseDate, releaseDate.count >= 4 else { return nil }
        return String(releaseDate.prefix(4))
    }
    
    var formattedRuntime: String? {
        guard let runtime, runtime > 0 else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
}

nonisolated struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}


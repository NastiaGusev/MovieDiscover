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

nonisolated struct CreditsResponse: Codable {
    let cast: [CastMember]
}

nonisolated struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?

    var profileURL: URL? {
        profilePath.map { URL(string: "https://image.tmdb.org/t/p/w185\($0)")! }
    }
}

nonisolated struct VideosResponse: Codable {
    let results: [Video]
}

nonisolated struct Video: Codable {
    let key: String
    let site: String
    let type: String
}

nonisolated struct WatchProvidersResponse: Codable {
    let results: [String: CountryProviders]
}

nonisolated struct CountryProviders: Codable {
    let link: String?
    let flatrate: [Provider]?
    let rent: [Provider]?
    let buy: [Provider]?
}

nonisolated struct Provider: Codable, Identifiable {
    let providerId: Int
    let providerName: String
    let logoPath: String?
    let displayPriority: Int?
    var id: Int { providerId }
    var logoURL: URL? {
        logoPath.map { URL(string: "https://image.tmdb.org/t/p/w92\($0)")! }
    }
}

struct ProviderListResponse: Codable {
    let results: [Provider]
}

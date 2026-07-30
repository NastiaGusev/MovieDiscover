//
//  Constants.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import Foundation

nonisolated enum API {
    static let baseURL = "https://api.themoviedb.org/3"
    static let region = "IL"
    static let monetizationFlatrate = "flatrate"
}

nonisolated enum ImageConfig {
    static let baseURL = "https://image.tmdb.org/t/p/"
    
    enum Size {
        static let providerLogo = "w92"
        static let castProfile  = "w185"
        static let backdrop     = "w780"
        static let poster       = "w500"
    }
    
    static func url(path: String, size: String) -> URL? {
        URL(string: baseURL + size + path)
    }
}

nonisolated enum ExternalURL {
    static func youTube(key: String) -> URL? {
        URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

//
//  Endpoint.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

enum Endpoint {
    case trendingMovies
    case searchMovies(query: String)
    case movieDetail(id: Int)
    case credits(id: Int)
    case videos(id: Int)
    case recommendations(id: Int)
    case watchProviders(id: Int)
    case discoverByProvider(providerIDs: [Int], region: String)
    case watchProviderList(region: String)
    
    private static let baseURL = API.baseURL
    
    private var path: String {
        switch self {
        case .trendingMovies:
            return "/trending/movie/day"
        case .searchMovies:
            return "/search/movie"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .credits(let id):
            return "/movie/\(id)/credits"
        case .videos(let id):
            return "/movie/\(id)/videos"
        case .recommendations(let id):
            return "/movie/\(id)/recommendations"
        case .watchProviders(let id):
            return "/movie/\(id)/watch/providers"
        case .discoverByProvider:
            return "/discover/movie"
        case .watchProviderList:
            return "/watch/providers/movie"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .trendingMovies, .movieDetail, .credits, .videos, .recommendations, .watchProviders:
            return []
        case .searchMovies(let query):
            return [URLQueryItem(name: "query", value: query)]
        case .discoverByProvider(let providerIDs, let region):
            return [
                URLQueryItem(name: "with_watch_providers",
                             value: providerIDs.map(String.init).joined(separator: "|")),
                URLQueryItem(name: "watch_region", value: region),
                URLQueryItem(name: "with_watch_monetization_types", value: API.monetizationFlatrate)
            ]
        case .watchProviderList(let region):
            return [URLQueryItem(name: "watch_region", value: region)]
        }
    }
    
    func url() -> URL? {
        var components = URLComponents(string: Endpoint.baseURL + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
}

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
 
    private static let baseURL = "https://api.themoviedb.org/3"
 
    private var path: String {
        switch self {
        case .trendingMovies:
            return "/trending/movie/day"
        case .searchMovies:
            return "/search/movie"
        case .movieDetail(let id):
            return "/movie/\(id)"
        }
    }
 
    private var queryItems: [URLQueryItem] {
        switch self {
        case .trendingMovies, .movieDetail:
            return []
        case .searchMovies(let query):
            return [URLQueryItem(name: "query", value: query)]
        }
    }
 
    func url(apiKey: String) -> URL? {
        var components = URLComponents(string: Endpoint.baseURL + path)
        var items = [URLQueryItem(name: "api_key", value: apiKey)]
        items.append(contentsOf: queryItems)
        components?.queryItems = items
        return components?.url
    }
}

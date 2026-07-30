//
//  Endpoint.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

enum Endpoint {
    case trendingMovies(page: Int)
    case searchMovies(query: String, page: Int)
    case discoverByGenre(genreID: Int, page: Int)
    case discoverByProvider(providerIDs: [Int], region: String, page: Int)
    case discoverByIntent(keywordIDs: [Int], genreIDs: [Int], page: Int)
    case movieDetail(id: Int)
    case credits(id: Int)
    case videos(id: Int)
    case recommendations(id: Int)
    case watchProviders(id: Int)
    case watchProviderList(region: String)
    case genreList
    case searchKeyword(query: String)
    
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
        case .genreList:
            return "/genre/movie/list"
        case .discoverByGenre:
            return "/discover/movie"
        case .searchKeyword:
            return "/search/keyword"
        case .discoverByIntent:
            return "/discover/movie"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .movieDetail, .credits, .videos, .recommendations, .watchProviders, .genreList:
            return []
        case .trendingMovies(let page):
            return [URLQueryItem(name: "page", value: String(page))]
            
        case .searchMovies(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page))
            ]
            
        case .discoverByGenre(let genreID, let page):
            return [
                URLQueryItem(name: "with_genres", value: String(genreID)),
                URLQueryItem(name: "page", value: String(page))
            ]
            
        case .discoverByIntent(let keywordIDs, let genreIDs, let page):
            var items: [URLQueryItem] = []
            if !keywordIDs.isEmpty {
                items.append(URLQueryItem(name: "with_keywords",
                                          value: keywordIDs.map(String.init).joined(separator: "|")))
            }
            if !genreIDs.isEmpty {
                items.append(URLQueryItem(name: "with_genres",
                                          value: genreIDs.map(String.init).joined(separator: "|")))
            }
            items.append(URLQueryItem(name: "sort_by", value: "popularity.desc"))
            items.append(URLQueryItem(name: "page", value: String(page)))
            return items
        case .discoverByProvider(let providerIDs, let region, let page):
            return [
                URLQueryItem(name: "with_watch_providers",
                             value: providerIDs.map(String.init).joined(separator: "|")),
                URLQueryItem(name: "watch_region", value: region),
                URLQueryItem(name: "with_watch_monetization_types", value: API.monetizationFlatrate),
                URLQueryItem(name: "page", value: String(page))
            ]
        case .watchProviderList(let region):
            return [URLQueryItem(name: "watch_region", value: region)]
        case .searchKeyword(let query):
            return [URLQueryItem(name: "query", value: query)]
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

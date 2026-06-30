//
//  APIClient.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

final class APIClient {
    static let shared = APIClient()
    private init() {}
 
    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? ""
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url(apiKey: apiKey) else {
            throw APIError.invalidURL
        }
 
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
 
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown(URLError(.badServerResponse))
            }
 
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.requestFailed(statusCode: httpResponse.statusCode)
            }
 
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed(error)
            }
        } catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw APIError.noInternetConnection
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.unknown(error)
        }
    }
}

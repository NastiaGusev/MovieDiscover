//
//  APIError.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed(Error)
    case noInternetConnection
    case unknown(Error)
 
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid."
        case .requestFailed(let statusCode):
            return "The server returned an error (status code \(statusCode))."
        case .decodingFailed:
            return "Failed to parse the server response."
        case .noInternetConnection:
            return "No internet connection."
        case .unknown(let error):
            return "Something went wrong: \(error.localizedDescription)"
        }
    }
}

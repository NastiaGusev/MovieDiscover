//
//  MockAPIClient.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation
@testable import MovieDiscover

final class MockAPIClient: APIClientProtocol {
    var resultToReturn: Any?
    var errorToThrow: Error?

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if let errorToThrow {
            throw errorToThrow
        }
        guard let result = resultToReturn as? T else {
            fatalError("MockAPIClient: no result configured matching expected type \(T.self)")
        }
        return result
    }
}

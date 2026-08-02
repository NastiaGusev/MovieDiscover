//
//  GenreProvider.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import Foundation

@Observable
final class GenreProvider {
    static let shared = GenreProvider()

    private(set) var namesByID: [Int: String] = [:]
    private let apiClient: APIClient
    private var loaded = false

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    @MainActor
    func loadIfNeeded() async {
        guard !loaded else { return }
        do {
            let response: GenreListResponse = try await apiClient.request(.genreList)
            namesByID = Dictionary(uniqueKeysWithValues: response.genres.map { ($0.id, $0.name) })
            loaded = true
        } catch { }
    }

    func name(for id: Int) -> String? { namesByID[id] }
}

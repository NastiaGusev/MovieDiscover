//
//  SmartSearchViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import Foundation

@Observable
final class SmartSearchViewModel {
    enum State {
        case idle, thinking, results([Movie]), empty, error(String)
    }

    var query: String = ""
    private(set) var state: State = .idle

    private let parser: MovieIntentParsing
    private let apiClient: APIClient

    init(parser: MovieIntentParsing, apiClient: APIClient = .shared) {
        self.parser = parser
        self.apiClient = apiClient
    }

    @MainActor
    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        state = .thinking
        do {
            let intent = try await parser.parse(trimmed)
            let keywordIDs = try await resolveKeywords(intent.keywords)

            var movies = try await discover(keywordIDs: keywordIDs, genreIDs: intent.genreIDs)
            // relax if keyword + genre over-filtered to nothing
            if movies.isEmpty, !keywordIDs.isEmpty {
                movies = try await discover(keywordIDs: keywordIDs, genreIDs: [])
            }
            state = movies.isEmpty ? .empty : .results(movies)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    @MainActor
    func reset() {
        query = ""
        state = .idle
    }

    private func resolveKeywords(_ keywords: [String]) async throws -> [Int] {
        guard !keywords.isEmpty else { return [] }
        return try await withThrowingTaskGroup(of: Int?.self) { group in
            for keyword in keywords {
                group.addTask { [apiClient] in
                    let response: KeywordSearchResponse = try await apiClient.request(.searchKeyword(query: keyword))
                    return response.results.first?.id
                }
            }
            var ids: [Int] = []
            for try await id in group {
                if let id { ids.append(id) }
            }
            return ids
        }
    }

    private func discover(keywordIDs: [Int], genreIDs: [Int]) async throws -> [Movie] {
        let response: MovieListResponse = try await apiClient.request(
            .discoverByIntent(keywordIDs: keywordIDs, genreIDs: genreIDs, page: 1)
        )
        return response.results
    }
}

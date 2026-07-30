//
//  MoodSearchViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import Foundation

@Observable
final class MoodSearchViewModel {
    
    enum State {
        case idle, thinking, results, empty, error(String)
    }
    
    var query: String = ""
    private(set) var state: State = .idle
    
    private let parser: MovieIntentParsing
    private let apiClient: APIClient
    
    private var pager: MoviePager?
    var movies: [Movie] { pager?.movies ?? [] }
    
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
            // model + keyword resolution run ONCE
            let intent = try await parser.parse(trimmed)
            let keywordIDs = try await resolveKeywords(intent.keywords)
            let genreIDs = intent.genreIDs
            
            let apiClient = self.apiClient
            pager = MoviePager { page in
                try await apiClient.request(
                    .discoverByIntent(keywordIDs: keywordIDs, genreIDs: genreIDs, page: page)
                )
            }
            try await pager?.loadNext()
            
            // relaxation fallback: if keyword+genre gave nothing, retry keyword-only
            if movies.isEmpty, !keywordIDs.isEmpty {
                pager = MoviePager { page in
                    try await apiClient.request(
                        .discoverByIntent(keywordIDs: keywordIDs, genreIDs: [], page: page)
                    )
                }
                try await pager?.loadNext()
            }
            
            state = movies.isEmpty ? .empty : .results
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func loadMore() async {
        try? await pager?.loadNext()
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
}

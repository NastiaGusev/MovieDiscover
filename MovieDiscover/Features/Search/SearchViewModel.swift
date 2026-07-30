//
//  SearchViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

@Observable
final class SearchViewModel {
    enum State { case idle, loading, loaded, empty, error(String) }
    
    var query: String = ""
    private(set) var state: State = .idle
    
    private let apiClient: APIClient
    private var pager: MoviePager?
    
    var movies: [Movie] { pager?.movies ?? [] }
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    @MainActor
    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { state = .idle; return }
        
        let apiClient = self.apiClient
        pager = MoviePager { page in
            try await apiClient.request(.searchMovies(query: trimmed, page: page))
        }
        state = .loading
        do {
            try await pager?.loadNext()
            state = movies.isEmpty ? .empty : .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func loadMore() async {
        try? await pager?.loadNext()
    }
}

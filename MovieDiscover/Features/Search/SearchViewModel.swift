//
//  SearchViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import Foundation

@Observable
final class SearchViewModel {
    private(set) var results: [Movie] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    var query: String = "" {
        didSet {
            searchTask?.cancel()
            guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                results = []
                return
            }
            searchTask = Task {
                try? await Task.sleep(for: .milliseconds(debounceMilliseconds))
                guard !Task.isCancelled else { return }
                await performSearch()
            }
        }
    }
    
    private var searchTask: Task<Void, Never>?
    private let apiClient: APIClientProtocol
    
    private let debounceMilliseconds: Int
    
    init(apiClient: APIClientProtocol = APIClient.shared, debounceMilliseconds: Int = 400) {
        self.apiClient = apiClient
        self.debounceMilliseconds = debounceMilliseconds
    }
    
    private func performSearch() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: MovieListResponse = try await apiClient.request(.searchMovies(query: query))
            guard !Task.isCancelled else { return }
            results = response.results
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        
        isLoading = false
    }
}

//
//  MoviePager.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import Foundation

@Observable
final class MoviePager {
    private(set) var movies: [Movie] = []
    private(set) var isLoadingNextPage = false
    
    private var currentPage = 0
    private var totalPages = 1
    private var seen = Set<Int>()
    private let fetch: @Sendable (Int) async throws -> MovieListResponse
    
    init(fetch: @escaping @Sendable (Int) async throws -> MovieListResponse) {
        self.fetch = fetch
    }
    
    var canLoadMore: Bool { currentPage < totalPages }
    
    @MainActor
    func loadNext() async throws {
        guard !isLoadingNextPage, canLoadMore else { return }
        isLoadingNextPage = true
        defer { isLoadingNextPage = false }
        
        let response = try await fetch(currentPage + 1)
        currentPage = response.page
        totalPages = response.totalPages
        let fresh = response.results.filter { seen.insert($0.id).inserted }
        movies.append(contentsOf: fresh)
    }
}

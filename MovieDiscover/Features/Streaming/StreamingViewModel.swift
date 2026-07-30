//
//  StreamingViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 28/07/2026.
//
import Foundation

@Observable
final class StreamingViewModel {
    enum State {
        case loading
        case loaded
        case error(String)
    }

    private(set) var providers: [Provider] = []
    private(set) var selectedProviderID: Int?
    private(set) var state: State = .loading

    private let apiClient: APIClient
    private let region = Locale.current.region?.identifier ?? API.region
    private var pager: MoviePager?

    var movies: [Movie] { pager?.movies ?? [] }

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    @MainActor
    func loadProviders() async {
        do {
            let list: ProviderListResponse = try await apiClient.request(.watchProviderList(region: region))
            providers = list.results
                .sorted { ($0.displayPriority ?? .max) < ($1.displayPriority ?? .max) }
                .prefix(12)
                .map { $0 }

            if let first = providers.first {
                await select(first.providerId)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    @MainActor
    func select(_ providerID: Int) async {
        selectedProviderID = providerID

        let apiClient = self.apiClient
        let region = self.region
        pager = MoviePager { page in
            try await apiClient.request(
                .discoverByProvider(providerIDs: [providerID], region: region, page: page)
            )
        }

        state = .loading
        do {
            try await pager?.loadNext()
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    @MainActor
    func loadMore() async {
        try? await pager?.loadNext()
    }
}

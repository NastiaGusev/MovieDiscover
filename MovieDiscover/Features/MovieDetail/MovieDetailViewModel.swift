//
//  MovieDetailViewModel.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 28/07/2026.
//

import Foundation

@Observable
final class MovieDetailViewModel {
    enum State {
        case loading
        case loaded(MovieDetails)
        case error(String)
    }

    private(set) var state: State = .loading
    private(set) var cast: [CastMember] = []
    private(set) var recommendations: [Movie] = []
    private(set) var trailerKey: String?

    private let movieID: Int
    private let apiClient: APIClient   // injected — your DI/test seam
    
    private(set) var providers: CountryProviders?
    private let region = Locale.current.region?.identifier ?? "IL"

    init(movieID: Int, apiClient: APIClient = .shared) {
        self.movieID = movieID
        self.apiClient = apiClient
    }

    @MainActor
    func load() async {
        state = .loading
        do {
            async let details: MovieDetails    = apiClient.request(.movieDetail(id: movieID))
            async let credits: CreditsResponse = apiClient.request(.credits(id: movieID))
            async let videos: VideosResponse   = apiClient.request(.videos(id: movieID))
            async let recs: MovieListResponse  = apiClient.request(.recommendations(id: movieID))
            async let watch: WatchProvidersResponse = apiClient.request(.watchProviders(id: movieID))
            
            let list: ProviderListResponse = try await apiClient.request(.watchProviderList(region: "IL"))
            print(list.results.map { "\($0.providerName): \($0.providerId)" }.sorted())
            
            let (d, c, v, r, w) = try await (details, credits, videos, recs, watch)

            providers = w.results[region]

            cast = Array(c.cast.prefix(15))
            trailerKey = v.results.first { $0.site == "YouTube" && $0.type == "Trailer" }?.key
            recommendations = r.results
            state = .loaded(d)
            
        } catch let error as DecodingError {
            print("DECODING ERROR:", error)
            switch error {
            case .keyNotFound(let key, let context):
                print("Missing key:", key.stringValue, "-", context.debugDescription)
            case .typeMismatch(let type, let context):
                print("Type mismatch:", type, "at", context.codingPath.map(\.stringValue), "-", context.debugDescription)
            case .valueNotFound(let type, let context):
                print("Null value:", type, "at", context.codingPath.map(\.stringValue))
            case .dataCorrupted(let context):
                print("Corrupted:", context.debugDescription)
            @unknown default:
                print(error)
            }
            state = .error("Parsing failed")
        } catch {
            print("NON-DECODING ERROR:", error)
            state = .error(error.localizedDescription)
        }
    }
}

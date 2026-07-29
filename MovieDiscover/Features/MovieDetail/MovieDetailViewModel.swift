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
    private let apiClient: APIClient
    
    private(set) var providers: CountryProviders?
    private let region = Locale.current.region?.identifier ?? API.region
    
    init(movieID: Int, apiClient: APIClient = .shared) {
        self.movieID = movieID
        self.apiClient = apiClient
    }
    
    @MainActor
    func load() async {
        state = .loading
        do {
            async let details: MovieDetails = apiClient.request(.movieDetail(id: movieID))
            async let credits: CreditsResponse = apiClient.request(.credits(id: movieID))
            async let videos: VideosResponse = apiClient.request(.videos(id: movieID))
            async let recs: MovieListResponse = apiClient.request(.recommendations(id: movieID))
            async let watch: WatchProvidersResponse = apiClient.request(.watchProviders(id: movieID))
            
            let (d, c, v, r, w) = try await (details, credits, videos, recs, watch)
            
            providers = w.results[region]
            cast = Array(c.cast.prefix(15))
            trailerKey = v.results.first { $0.site == "YouTube" && $0.type == "Trailer" }?.key
            recommendations = r.results
            state = .loaded(d)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

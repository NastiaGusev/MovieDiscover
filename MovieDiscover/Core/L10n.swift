//
//  L10n.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import Foundation

enum L10n {
    enum Detail {
        static let cast = LocalizedStringResource("Cast")
        static let recommended = LocalizedStringResource("Recommended")
        static let whereToWatch = LocalizedStringResource("Where to Watch")
        static let trailer = LocalizedStringResource("Trailer")
        static let playTrailer = LocalizedStringResource("Play Trailer")
    }
    
    enum Browse {
        static let browse = LocalizedStringResource("Browse")
        static let trending = LocalizedStringResource("Trending")
        static let loadingTrendingMovies = LocalizedStringResource("Loading trending movies…")
    }
    
    enum Search {
        static let search = LocalizedStringResource("Search")
        static let searchMovies = LocalizedStringResource("Search movies")
        
    }
    
    enum Streaming {
        static let streaming = LocalizedStringResource("Streaming")
    }
    
    enum Favorites {
        static let favorites = LocalizedStringResource("Favorites")
        static let noFavorites = LocalizedStringResource("No Favorites Yet")
        static let favoritesDescription = LocalizedStringResource("Movies you favorite will show up here.")
    }
    
    enum SmartSearch {
        static let title = LocalizedStringResource("Discover")
        static let placeholder = LocalizedStringResource("Describe what you're in the mood for…")
        static let idleTitle = LocalizedStringResource("Search by vibe")
        static let idleDescription = LocalizedStringResource("Try \"a slow-burn sci-fi thriller from the 90s\"")
        static let thinking = LocalizedStringResource("Thinking…")
        static let errorTitle = LocalizedStringResource("Something went wrong")
        static let unavailableTitle = LocalizedStringResource("Not available on this device")
        static let unavailableDescription = LocalizedStringResource("AI search needs a device with Apple Intelligence. Use Browse or Search instead.")
    }
    
    enum Error {
        static let retry = LocalizedStringResource("Retry")
        static let somethingWentWrong = LocalizedStringResource("Something Went Wrong")
        static let streamingNotAvailableInRegion = LocalizedStringResource("Not available on streaming in your region")
    }
}

//
//  L10n.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import Foundation

enum L10n {
    enum Home {
        static let tab = LocalizedStringResource("Discover")
        static let title = LocalizedStringResource("Discover")
        static let trending = LocalizedStringResource("Trending")
        static let seeAll = LocalizedStringResource("See all")
        static let spotlight = LocalizedStringResource("Spotlight")
        static let forYou = LocalizedStringResource("For You")
        static let insightTitle = LocalizedStringResource("Your taste, visualized")
        static let insightSubtitle = LocalizedStringResource("See the patterns in your favorites")
        static let whereToStream = LocalizedStringResource("Where to Stream")
        static let exploreGenres = LocalizedStringResource("Explore by Genre")
        static let recommended = LocalizedStringResource("Recommended for You")
    }
    
    enum You {
        static let title = LocalizedStringResource("You")
        static let favorites = LocalizedStringResource("Favorites")
        static let noFavoritesTitle = LocalizedStringResource("No favorites yet")
        static let noFavoritesDescription = LocalizedStringResource("Tap the heart on any film to save it here.")
        static let remove = LocalizedStringResource("Remove")
    }
    
    enum Insights {
        static let title = LocalizedStringResource("Your Taste")
        static let empty = LocalizedStringResource("Favorite some films to see your taste take shape.")
        static let saved = LocalizedStringResource("Saved")
        static let avgRating = LocalizedStringResource("Avg rating")
        static let topGenre = LocalizedStringResource("Top genre")
        static let topGenres = LocalizedStringResource("Top genres")
        static let byDecade = LocalizedStringResource("By decade")
        static let byRating = LocalizedStringResource("By rating")
    }
    
    enum Taste {
        static let heading = LocalizedStringResource("BASED ON YOUR FAVORITES")
        static let thinking = LocalizedStringResource("Reading your taste…")
    }
    
    enum Detail {
        static let cast = LocalizedStringResource("Cast")
        static let recommended = LocalizedStringResource("Recommended")
        static let whereToWatch = LocalizedStringResource("Where to Watch")
        static let trailer = LocalizedStringResource("Trailer")
        static let playTrailer = LocalizedStringResource("Play Trailer")
    }
    
    enum Search {
        static let search = LocalizedStringResource("Search")
        static let searchMovies = LocalizedStringResource("Search movies")
    }
    
    enum Favorites {
        static let favorites = LocalizedStringResource("Favorites")
        static let noFavorites = LocalizedStringResource("No Favorites Yet")
        static let favoritesDescription = LocalizedStringResource("Movies you favorite will show up here.")
    }
    
    enum MoodSearch {
        static let title = LocalizedStringResource("Mood")
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

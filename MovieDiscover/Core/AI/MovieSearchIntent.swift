//
//  MovieSearchIntent.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import FoundationModels

@available(iOS 26.0, *)
@Generable
struct MovieSearchIntent {
    @Guide(description: "Concrete subjects, creatures, objects, or plot elements mentioned — e.g. 'dragon', 'time travel', 'heist', 'zombie'. Empty if the request is only about mood or genre.")
    let keywords: [String]
    
    @Guide(description: "The genres that best match the request")
    let genres: [MovieGenre]
}

@available(iOS 26.0, *)
@Generable
enum MovieGenre: String {
    case action = "Action", adventure = "Adventure", animation = "Animation"
    case comedy = "Comedy", crime = "Crime", documentary = "Documentary"
    case drama = "Drama", family = "Family", fantasy = "Fantasy"
    case history = "History", horror = "Horror", music = "Music"
    case mystery = "Mystery", romance = "Romance", scienceFiction = "Science Fiction"
    case thriller = "Thriller", war = "War", western = "Western"
    
    var tmdbID: Int {
        switch self {
        case .action: 28; case .adventure: 12; case .animation: 16
        case .comedy: 35; case .crime: 80; case .documentary: 99
        case .drama: 18; case .family: 10751; case .fantasy: 14
        case .history: 36; case .horror: 27; case .music: 10402
        case .mystery: 9648; case .romance: 10749; case .scienceFiction: 878
        case .thriller: 53; case .war: 10752; case .western: 37
        }
    }
}

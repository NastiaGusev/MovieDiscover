//
//  Cast.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import Foundation

nonisolated struct CreditsResponse: Codable {
    let cast: [CastMember]
}

nonisolated struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    var profileURL: URL? {
        profilePath.map { ImageConfig.url(path: $0, size: ImageConfig.Size.castProfile) } ?? nil
    }
}

//
//  Video.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import Foundation

nonisolated struct VideosResponse: Codable {
    let results: [Video]
}

nonisolated struct Video: Codable {
    let key: String
    let site: String
    let type: String
}

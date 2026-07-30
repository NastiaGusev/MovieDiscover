//
//  Keyword.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//
import Foundation

nonisolated struct KeywordSearchResponse: Codable {
    let results: [Keyword]
}
nonisolated struct Keyword: Codable, Identifiable {
    let id: Int
    let name: String
}

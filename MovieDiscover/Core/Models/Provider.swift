//
//  Provider.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//
import Foundation

nonisolated struct WatchProvidersResponse: Codable {
    let results: [String: CountryProviders]
}

nonisolated struct CountryProviders: Codable {
    let link: String?
    let flatrate: [Provider]?
    let rent: [Provider]?
    let buy: [Provider]?
}

nonisolated struct Provider: Codable, Identifiable {
    let providerId: Int
    let providerName: String
    let logoPath: String?
    let displayPriority: Int?
    var id: Int { providerId }
    var logoURL: URL? {
        logoPath.map { ImageConfig.url(path: $0, size: ImageConfig.Size.providerLogo) } ?? nil
    }
}

struct ProviderListResponse: Codable {
    let results: [Provider]
}

//
//  FavoriteCollectionsEntry.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import SwiftUI
import FoundationModels

enum FavoriteCollectionsEntry {
    @ViewBuilder
    static func make(favorites: [FavoriteMovie]) -> some View {
        if #available(iOS 26.0, *), case .available = SystemLanguageModel.default.availability {
            FavoriteCollectionsView(
                favorites: favorites,
                viewModel: FavoriteCollectionsViewModel(grouper: FoundationModelFavoriteGrouper())
            )
        } else {
            FavoriteCollectionsView(   // mock unused path — show plain grid
                favorites: favorites,
                viewModel: FavoriteCollectionsViewModel(grouper: NoGrouper())
            )
        }
    }
}

// Forces the .unavailable fallback grid on non-AI devices.
private struct NoGrouper: FavoriteGrouping {
    func group(favorites: String) async throws -> [GroupedCollection] { [] }
}

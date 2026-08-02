//
//  TasteReframeEntry.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import SwiftUI
import FoundationModels

enum TasteProfileEntry {
    @ViewBuilder
    static func make(favorites: [FavoriteMovie]) -> some View {
        if #available(iOS 26.0, *), case .available = SystemLanguageModel.default.availability {
            TasteProfileView(
                favorites: favorites,
                viewModel: TasteProfileViewModel(profiler: FoundationModelTasteProfiler())
            )
        } else {
            EmptyView()
        }
    }
}

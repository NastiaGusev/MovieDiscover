//
//  SmartSearchEntry.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import SwiftUI
import FoundationModels

enum MoodSearchEntry {
    @ViewBuilder
    static func make(initialQuery: String? = nil) -> some View {
        if #available(iOS 26.0, *), case .available = SystemLanguageModel.default.availability {
            MoodSearchView(
                viewModel: MoodSearchViewModel(parser: FoundationModelIntentParser()),
                initialQuery: initialQuery
            )
        } else {
            MoodSearchUnavailableView()
        }
    }
}

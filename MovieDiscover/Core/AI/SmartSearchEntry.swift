//
//  SmartSearchEntry.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import SwiftUI
import FoundationModels

enum SmartSearchEntry {
    @ViewBuilder
    static func make() -> some View {
        if #available(iOS 26.0, *), case .available = SystemLanguageModel.default.availability {
            SmartSearchView(viewModel: SmartSearchViewModel(parser: FoundationModelIntentParser()))
        } else {
            SmartSearchUnavailableView()
        }
    }
}

//
//  MoodSearchUnavailableView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import SwiftUI

struct MoodSearchUnavailableView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                L10n.MoodSearch.unavailableTitle,
                systemImage: "sparkles.slash",
                description: Text(L10n.MoodSearch.unavailableDescription)
            )
            .navigationTitle(L10n.MoodSearch.title)
        }
    }
}

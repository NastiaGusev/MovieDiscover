//
//  SmartSearchUnavailableView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import SwiftUI

struct SmartSearchUnavailableView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                L10n.SmartSearch.unavailableTitle,
                systemImage: "sparkles.slash",
                description: Text(L10n.SmartSearch.unavailableDescription)
            )
            .navigationTitle(L10n.SmartSearch.title)
        }
    }
}

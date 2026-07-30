//
//  MovieDiscoverApp.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import SwiftUI
import SwiftData

@main
struct MovieDiscoverApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: FavoriteMovie.self)
    }
}

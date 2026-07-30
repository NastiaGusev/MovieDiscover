//
//  ContentView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import SwiftUI
import SwiftData

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label(String(localized: L10n.Home.tab), systemImage: "sparkles") }
            YouView()
                .tabItem { Label(String(localized: L10n.You.title), systemImage: "person.crop.circle") }
        }
        .tint(Color.brand)
    }
}

#Preview {
    RootTabView()
        .modelContainer(for: FavoriteMovie.self, inMemory: true)
}

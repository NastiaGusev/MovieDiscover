//
//  ContentView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/06/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            BrowseView()
                .tabItem {
                    Label(L10n.Browse.browse, systemImage: "house")
                }
            
            StreamingView()
                .tabItem {
                    Label(L10n.Streaming.streaming, systemImage: "play.tv")
                }
            
            SearchView()
                .tabItem {
                    Label(L10n.Search.search, systemImage: "magnifyingglass")
                }
            
            SmartSearchEntry.make()
                .tabItem {
                    Label(L10n.SmartSearch.title, systemImage: "sparkles")
                }
            
            FavoritesView()
                .tabItem {
                    Label(L10n.Favorites.favorites, systemImage: "heart")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FavoriteMovie.self, inMemory: true)
}

//
//  TasteProfileView.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 02/08/2026.
//

import SwiftUI

struct TasteProfileView: View {
    let favorites: [FavoriteMovie]
    @State private var viewModel: TasteProfileViewModel
    
    init(favorites: [FavoriteMovie], viewModel: TasteProfileViewModel) {
        self.favorites = favorites
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if case .loaded(let taste) = viewModel.state {
                loadedCard(taste)
                    .transition(.opacity)
            } else {
                Color.clear.frame(height: 1)   // keeps the ZStack alive so .task attaches
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isLoaded)
        .task(id: favorites.map(\.id)) { await viewModel.generate(from: favorites) }
    }

    private var isLoaded: Bool {
        if case .loaded = viewModel.state { return true }
        return false
    }

    private func loadedCard(_ taste: TasteResult) -> some View {
        card {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(String(localized: L10n.Taste.heading))
                    .font(.caption.bold()).foregroundStyle(.white.opacity(0.7))
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    ForEach(taste.enjoys, id: \.self) { item in
                        HStack(alignment: .top, spacing: Spacing.sm) {
                            Text("•").foregroundStyle(.white.opacity(0.7))
                            Text(item).foregroundStyle(.white)
                        }
                        .font(.subheadline)
                    }
                }
                Text(taste.rarely)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.top, Spacing.xs)
            }
        }
    }
    
    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.lg)
            .background(LinearGradient.hero)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
            .padding(.horizontal, Spacing.lg)
    }
}

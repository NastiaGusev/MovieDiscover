//
//  DesignSystem.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//
import SwiftUI

extension Color {
    static let brand = Color(red: 0.58, green: 0.36, blue: 0.92)
}

extension LinearGradient {
    static let hero = LinearGradient(
        colors: [Color(red: 0.28, green: 0.14, blue: 0.52),
                 Color(red: 0.50, green: 0.24, blue: 0.78)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let topGlow = LinearGradient(
        colors: [Color.brand.opacity(0.28), .clear],
        startPoint: .top, endPoint: .bottom
    )
    static let blindSpot = LinearGradient(
        colors: [Color(red: 0.55, green: 0.22, blue: 0.30),
                 Color(red: 0.35, green: 0.15, blue: 0.28)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

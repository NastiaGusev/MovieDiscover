//
//  Theme.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 29/07/2026.
//

import SwiftUI

nonisolated enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 44
}

nonisolated enum CornerRadius {
    static let sm: CGFloat = 6
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
}

nonisolated enum AspectRatio {
    static let poster: CGFloat = 2.0 / 3.0
    static let backDrop: CGFloat = 16.0 / 9.0
    
}

nonisolated enum GridColumns {
    static let trending = 2
    static let genre = 3
    static let streaming = 3
}

extension Color {
    static let placeholder = Color.gray.opacity(0.2)
}

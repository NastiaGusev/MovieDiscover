//
//  ImageLoader.swift
//  MovieDiscover
//
//  Created by Nastia Gusev on 30/07/2026.
//

import SwiftUI
import UIKit

@MainActor
final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    private var inFlight: [URL: Task<UIImage?, Never>] = [:]
    
    func image(for url: URL) async -> UIImage? {
        if let cached = cache.object(forKey: url as NSURL) { return cached }
        if let existing = inFlight[url] { return await existing.value }
        
        let task = Task<UIImage?, Never> {
            let image = await Self.download(url)
            if let image { cache.setObject(image, forKey: url as NSURL) }
            inFlight[url] = nil
            return image
        }
        inFlight[url] = task
        return await task.value
    }
    
    private static func download(_ url: URL) async -> UIImage? {
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return nil }
        return UIImage(data: data)
    }
}

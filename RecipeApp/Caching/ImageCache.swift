//
//  ImageCache.swift
//  RecipeApp
//
//  Created by Austin Beck on 2/1/25.
//

import UIKit
import CryptoKit

// Made an actor to avoid race conditions
actor ImageCache {
    static let shared = ImageCache()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private var memoryCache: [String: UIImage] = [:]
    
    init() {
        // Create a directory for cached images in the caches directory.
        guard let cachesDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access caches directory")
        }
        cacheDirectory = cachesDir.appendingPathComponent("ImageCache", isDirectory: true)
        
        // Create the directory if needed.
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    /// Computes a unique file name for a given URL using SHA256. This is due to the last path component being the same for all URLs and not being unique
    private func fileName(for url: URL) -> String {
        let urlString = url.absoluteString
        let hash = SHA256.hash(data: Data(urlString.utf8))
        // Convert the hash to a hex string.
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    /// Returns the cached image for the given URL if it exists.
    func image(for url: URL) -> UIImage? {
        let key = url.absoluteString
        if let image = memoryCache[key] {
            return image
        }
        
        let fileName = self.fileName(for: url)
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            memoryCache[key] = image
            return image
        }
        return nil
    }
    
    /// Saves an image to the cache.
    func save(image: UIImage, for url: URL) {
        let key = url.absoluteString
        memoryCache[key] = image
        
        let fileName = self.fileName(for: url)
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
    
    /// Asynchronously downloads an image and caches it.
    func loadImage(from url: URL) async throws -> UIImage {
        if let cached = image(for: url) {
            return cached
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        save(image: image, for: url)
        return image
    }
}



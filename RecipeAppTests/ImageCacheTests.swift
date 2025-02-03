//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Austin Beck on 2/1/25.
//

import XCTest
@testable import RecipeApp

final class ImageCacheTests: XCTestCase {
    func testImageCaching() async throws {
        let imageCache = ImageCache.shared
        
        // URl for placeholder image
        let imageURL = URL(string: "https://picsum.photos/200")!
        
        // First, capture the image from the cache (should be nil initially)
        let initialCachedImage = await imageCache.image(for: imageURL)
        XCTAssertNil(initialCachedImage)
        
        // Download the image.
        let image = try await imageCache.loadImage(from: imageURL)
        XCTAssertNotNil(image)
        
        // Now it should be in the cache; capture it first then assert.
        let cachedImage = await imageCache.image(for: imageURL)
        XCTAssertNotNil(cachedImage)
    }
}

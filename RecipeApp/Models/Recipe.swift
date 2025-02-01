//
//  Recipe.swift
//  RecipeApp
//
//  Created by Austin Beck on 2/1/25.
//

import Foundation

struct RecipeList: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let cuisine: String
    let name: String
    let photo_url_large: URL?
    let photo_url_small: URL?
    let uuid: UUID
    let source_url: URL?
    let youtube_url: URL?
    
    var id: UUID { uuid }
}

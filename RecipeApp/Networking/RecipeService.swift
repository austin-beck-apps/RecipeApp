//
//  RecipeService.swift
//  RecipeApp
//
//  Created by Austin Beck on 2/1/25.
//

import Foundation

enum RecipeServiceError: Error {
    case invalidURL
    case emptyData
}

class RecipeService {
    static let shared = RecipeService()

    private let recipesURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    /// Fetches the list of recipes asynchronously.
    func fetchRecipes() async throws -> [Recipe] {
        let (data, response) = try await URLSession.shared.data(from: recipesURL)
        
        // Check for HTTP errors
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // Decode the JSON – if the data is malformed then throw an error.
        let decoder = JSONDecoder()
        do {
            let recipeList = try decoder.decode(RecipeList.self, from: data)
            if recipeList.recipes.isEmpty {
                throw RecipeServiceError.emptyData
            }
            return recipeList.recipes
        } catch {
            // In the event of any decoding error we disregard the entire list.
            throw error
        }
    }
}

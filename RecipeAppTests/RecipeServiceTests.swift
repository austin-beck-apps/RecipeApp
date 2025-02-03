//
//  RecipeServiceTests.swift
//  RecipeAppTests
//
//  Created by Austin Beck on 2/1/25.
//

import XCTest
@testable import RecipeApp

final class RecipeServiceTests: XCTestCase {
    
    /// Use a custom URL protocol or local JSON file to simulate a response.
    func testFetchRecipesSuccess() async throws {
        // Given a valid URL, for example using a local JSON file bundled with tests.
        let service = RecipeService.shared
        // Here I assume the live endpoint is available.
        do {
            let recipes = try await service.fetchRecipes()
            XCTAssertFalse(recipes.isEmpty, "Recipes list should not be empty")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRecipesEmptyData() async {
        // Use an endpoint that returns empty data:
        let emptyURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!

        // Here we simulate by creating a temporary method for testing.
        do {
            let (data, _) = try await URLSession.shared.data(from: emptyURL)
            let decoder = JSONDecoder()
            let recipeList = try decoder.decode(RecipeList.self, from: data)
            XCTAssertTrue(recipeList.recipes.isEmpty, "Recipes list should be empty")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}


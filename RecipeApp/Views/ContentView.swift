//
//  ContentView.swift
//  RecipeApp
//
//  Created by Austin Beck on 2/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewState = ViewState()
    
    var body: some View {
        NavigationView {
            Group {
                if viewState.isLoading {
                    ProgressView("Loading recipes...")
                } else if let errorMessage = viewState.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error: \(errorMessage)")
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await loadRecipes() }
                        }
                    }
                    .padding()
                } else if viewState.recipes.isEmpty {
                    VStack(spacing: 16) {
                        Text("No recipes available.")
                        Button("Refresh") {
                            Task { await loadRecipes() }
                        }
                    }
                } else {
                    List(viewState.recipes) { recipe in
                        if viewState.isLargeView {
                            // Large view layout: more spacious, uses the large image
                            VStack(alignment: .leading, spacing: 12) {
                                AsyncImageView(url: recipe.photo_url_large)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, maxHeight: 200)
                                    .clipped()
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(recipe.name)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text(recipe.cuisine)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                if let youtubeURL = recipe.youtube_url {
                                    Link(destination: youtubeURL) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "play.rectangle.fill")
                                                .foregroundColor(.red)
                                            Text("Watch on YouTube")
                                                .font(.subheadline)
                                        }
                                    }
                                    .accessibilityLabel("Watch \(recipe.name) on YouTube")
                                }
                            }
                            .padding(.vertical, 8)
                        } else {
                            // Small view layout: HStack using the small image
                            HStack {
                                AsyncImageView(url: recipe.photo_url_small)
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recipe.name)
                                        .font(.headline)
                                    Text(recipe.cuisine)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    if let youtubeURL = recipe.youtube_url {
                                        Link(destination: youtubeURL) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "play.rectangle.fill")
                                                    .foregroundColor(.red)
                                                Text("Watch on YouTube")
                                                    .font(.subheadline)
                                            }
                                        }
                                        .accessibilityLabel("Watch \(recipe.name) on YouTube")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        await loadRecipes()
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                // Add a segmented control in the navigation bar to toggle between view modes.
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("View Mode", selection: $viewState.isLargeView) {
                        Text("Small").tag(false)
                        Text("Large").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task { await loadRecipes() }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                Task { await loadRecipes() }
            }
        }
    }
    
    private func loadRecipes() async {
        viewState.isLoading = true
        viewState.errorMessage = nil
        do {
            let fetchedRecipes = try await RecipeService.shared.fetchRecipes()
            await MainActor.run {
                self.viewState.recipes = fetchedRecipes
                self.viewState.isLoading = false
            }
        } catch RecipeServiceError.emptyData {
            await MainActor.run {
                self.viewState.recipes = []
                self.viewState.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.viewState.errorMessage = error.localizedDescription
                self.viewState.isLoading = false
            }
        }
    }
}

extension ContentView {
    struct ViewState {
        var recipes: [Recipe] = []
        var isLoading = false
        var errorMessage: String?
        var isLargeView: Bool = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

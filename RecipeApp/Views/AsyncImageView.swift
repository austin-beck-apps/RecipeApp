//
//  AsyncImageView.swift
//  RecipeApp
//
//  Created by Austin Beck on 2/1/25.
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else if isLoading {
                ProgressView()
            } else if error != nil {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
            } else {
                Color.gray
            }
        }
        .onAppear {
            loadImageIfNeeded()
        }
    }
    
    private func loadImageIfNeeded() {
        guard !isLoading, let url = url else { return }
        isLoading = true
        Task {
            do {
                // Await the actor function
                let fetchedImage = try await ImageCache.shared.loadImage(from: url)
                await MainActor.run {
                    self.image = fetchedImage
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
}


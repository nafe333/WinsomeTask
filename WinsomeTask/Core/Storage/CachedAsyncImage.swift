//
//  CachedAsyncImage.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import SwiftUI
import SwiftData

struct CachedAsyncImage: View {
    let productId: Int
    let url: URL?

    @Environment(\.modelContext) private var modelContext
    @State private var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Color.gray.opacity(0.1)
                    .overlay(ProgressView())
            }
        }
        .task(id: productId) {
            await loadImage()
        }
    }

    private func loadImage() async {
        let cacheService = ProductCacheService(modelContext: modelContext)

        if let savedData = await cacheService.imageData(forProductId: productId),
           let savedImage = UIImage(data: savedData) {
            uiImage = savedImage
            return
        }

        guard let url else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return }
            await cacheService.saveImageData(data, forProductId: productId)
            uiImage = image
        } catch {
        }
    }
}

//
//  FavouritesManager.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class FavoritesManager: ObservableObject {
    @Published private(set) var favoriteProducts: [Product] = []

    private var modelContext: ModelContext?

    /// Called once, after the environment's ModelContext becomes available.
    func configure(modelContext: ModelContext) {
        guard self.modelContext == nil else { return }
        self.modelContext = modelContext
        loadFavorites()
    }

    func isFavorite(_ productId: Int?) -> Bool {
        guard let productId else { return false }
        return favoriteProducts.contains { $0.id == productId }
    }

    func toggle(_ product: Product) {
        guard let modelContext, let id = product.id else { return }

        if isFavorite(id) {
            let descriptor = FetchDescriptor<FavoriteProduct>(predicate: #Predicate { $0.id == id })
            if let existing = try? modelContext.fetch(descriptor).first {
                modelContext.delete(existing)
            }
        } else {
            modelContext.insert(FavoriteProduct(from: product))
        }

        try? modelContext.save()
        loadFavorites()
    }

    private func loadFavorites() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<FavoriteProduct>()
        let stored = (try? modelContext.fetch(descriptor)) ?? []
        favoriteProducts = stored.map { $0.toProduct() }
    }
}

//
//  FavouritesViewModel.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 02/09/2026.
//

import Foundation
import Combine
@MainActor
final class FavouritesViewModel: ObservableObject {
    @Published private(set) var favoriteProducts: [Product] = []

    private let favoritesManager: FavoritesManager
    private var cancellables = Set<AnyCancellable>()

    init(favoritesManager: FavoritesManager) {
        self.favoritesManager = favoritesManager
        favoritesManager.$favoriteProducts
            .assign(to: &$favoriteProducts)
    }

    func toggleFavorite(_ product: Product) {
        favoritesManager.toggle(product)
    }
}

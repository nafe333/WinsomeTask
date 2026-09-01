//
//  FavouritesView.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject private var favoritesManager: FavoritesManager

        var body: some View {
            NavigationStack {
                VStack(alignment: .leading, spacing: 12) {
                    if favoritesManager.favoriteProducts.isEmpty {
                        emptyState
                    } else {
                        Text("\(favoritesManager.favoriteProducts.count) saved")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)

                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(favoritesManager.favoriteProducts) { product in
                                    SingleProduct(
                                        productId: product.id ?? 0,
                                        category: product.category ?? "General",
                                        title: product.title ?? "Untitled",
                                        rating: product.rating ?? 0,
                                        price: product.price ?? 0,
                                        imageURL: product.thumbnail ?? "",
                                        isFavorited: true,
                                        onToggleFavorite: { favoritesManager.toggle(product) }
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .animation(.easeInOut(duration: 0.25), value: favoritesManager.favoriteProducts.count)
                        }
                    }
                }
                .navigationTitle("Favorites")
            }
        }

        private var emptyState: some View {
            VStack(spacing: 12) {
                Spacer()
                Image(systemName: "heart")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
                Text("No favourites yet")
                    .font(.headline)
                Text("Tap the heart on any product to save it here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
}

#Preview {
    FavouritesView()
}

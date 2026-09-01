//
//  FavouritesView.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import SwiftUI
import Combine

struct FavouritesView: View {
    @EnvironmentObject private var favoritesManager: FavoritesManager
    @StateObject private var viewModel: FavouritesViewModel

    init(viewModel: FavouritesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                if viewModel.favoriteProducts.isEmpty {
                    emptyState
                } else {
                    Text("\(viewModel.favoriteProducts.count) saved")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(viewModel.favoriteProducts) { product in
                                NavigationLink(value: product) {
                                    SingleProduct(
                                        productId: product.id ?? 0,
                                        category: product.category ?? "General",
                                        title: product.title ?? "Untitled",
                                        rating: product.rating ?? 0,
                                        price: product.price ?? 0,
                                        imageURL: product.thumbnail ?? "",
                                        isFavorited: true,
                                        onToggleFavorite: { viewModel.toggleFavorite(product) }
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.favoriteProducts.count)
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: Product.self) { product in
                ProductDetailsView(product: product)
            }
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
    FavouritesView(viewModel: FavouritesViewModel(favoritesManager: FavoritesManager()))
}

//
//  ProductDetailsView.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import SwiftUI

struct ProductDetailsView: View {
    @StateObject private var viewModel: ProductDetailViewModel
    @EnvironmentObject private var favoritesManager: FavoritesManager
    @Environment(\.dismiss) private var dismiss
    
    init(product: Product) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(product: product))
    }
    private var product: Product { viewModel.product }

    var body: some View {
          ScrollView {
              VStack(alignment: .leading, spacing: 16) {
                  heroImage
                  infoCard
                  aboutCard
                  quantityCard
                  continueButton
              }
          }
          .background(Color(.systemGray6))
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
              ToolbarItem(placement: .principal) {
                  Text(product.title ?? "Product")
                      .font(.headline)
                      .lineLimit(1)
              }
              ToolbarItem(placement: .navigationBarTrailing) {
                  Button {
                      favoritesManager.toggle(product)
                  } label: {
                      Image(systemName: favoritesManager.isFavorite(product.id) ? "heart.fill" : "heart")
                          .foregroundStyle(favoritesManager.isFavorite(product.id) ? .red : .primary)
                  }
              }
          }
      }
}

extension ProductDetailsView {
    private var heroImage: some View {
           CachedAsyncImage(productId: product.id ?? 0, url: URL(string: product.thumbnail ?? ""))
               .aspectRatio(contentMode: .fill)
               .frame(height: 260)
               .clipped()
       }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text((product.category ?? "General").capitalized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.15), in: Capsule())
                    .foregroundStyle(.blue)

                Spacer()

                stockLabel
            }

            Text(product.title ?? "Untitled")
                .font(.title2)
                .fontWeight(.bold)

            RatingView(rating: product.rating ?? 0)

            Text("$\(product.price ?? 0, specifier: "%.2f")")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    @ViewBuilder
    private var stockLabel: some View {
        if viewModel.isOutOfStock {
            Text("Out of stock")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.red)
        } else if let stock = product.stock {
            Text("\(stock) in stock")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.green)
        }
    }
    
       private var aboutCard: some View {
           VStack(alignment: .leading, spacing: 8) {
               Text("About this item")
                   .font(.headline)
               Text(product.description ?? "No description available.")
                   .font(.subheadline)
                   .foregroundStyle(.secondary)
           }
           .padding()
           .frame(maxWidth: .infinity, alignment: .leading)
           .background(.white, in: RoundedRectangle(cornerRadius: 16))
           .padding(.horizontal)
       }

       private var quantityCard: some View {
           VStack(spacing: 12) {
               HStack {
                   Text("Quantity")
                       .font(.headline)
                   Spacer()
                   stepper
               }
               Divider()
               HStack {
                   Text("Total")
                       .font(.headline)
                   Spacer()
                   Text("$\(viewModel.total, specifier: "%.2f")")
                       .font(.title3)
                       .fontWeight(.bold)
                       .foregroundStyle(.blue)
               }
           }
           .padding()
           .background(.white, in: RoundedRectangle(cornerRadius: 16))
           .padding(.horizontal)
       }

    private var stepper: some View {
        HStack(spacing: 16) {
            Button {
                viewModel.decrement()
            } label: {
                Image(systemName: "minus")
                    .frame(width: 28, height: 28)
                    .background(Color(.systemGray5), in: Circle())
            }
            .disabled(!viewModel.canDecrement)
            .opacity(viewModel.canDecrement ? 1 : 0.4)

            Text("\(viewModel.quantity)")
                .font(.headline)
                .frame(minWidth: 20)

            Button {
                viewModel.increment()
            } label: {
                Image(systemName: "plus")
                    .frame(width: 28, height: 28)
                    .background(Color(.systemGray5), in: Circle())
            }
            .disabled(!viewModel.canIncrement)
            .opacity(viewModel.canIncrement ? 1 : 0.4)
        }
        .foregroundStyle(.primary)
    }

    private var continueButton: some View {
        Button {
            // Hook up navigation to checkout/order flow here later.
        } label: {
            Text(viewModel.isOutOfStock ? "Out of Stock" : "Continue to Order")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    (viewModel.isOutOfStock ? Color.gray : Color(red: 0.1, green: 0.15, blue: 0.3)),
                    in: RoundedRectangle(cornerRadius: 14)
                )
        }
        .disabled(viewModel.isOutOfStock)
        .padding(.horizontal)
        .padding(.bottom)
    }
}

#Preview {
    NavigationStack {
        ProductDetailsView(product: Product(
            id: 1, title: "TSA Luggage Lock Set (3-Pack)",
            description: "Set of 3 TSA-approved zinc alloy combination locks with a re-settable 3-digit code.",
            category: "security", price: 19.99, rating: 4.5, stock: 42,
            tags: nil, brand: nil, shippingInformation: nil, images: nil,
            thumbnail: "https://cdn.dummyjson.com/product-images/1/thumbnail.png"
        ))
        .environmentObject(FavoritesManager())
    }
}

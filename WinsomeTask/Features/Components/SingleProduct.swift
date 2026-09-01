//
//  SingleProduct.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import SwiftUI

struct SingleProduct: View {
    let productId: Int
    let category: String
    let title: String
    let rating: Double
    let price: Double
    let imageURL: String
    let isFavorited: Bool
    let onToggleFavorite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                CachedAsyncImage(productId: productId, url: URL(string: imageURL))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .clipped()

                Button(action: onToggleFavorite) {
                                   Image(systemName: isFavorited ? "heart.fill" : "heart")
                                       .foregroundStyle(isFavorited ? .red : .gray)
                                       .padding(8)
                                       .background(.white, in: Circle())
                                       .shadow(color: .black.opacity(0.15), radius: 3, y: 1)
                               
                }
                .padding(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(category.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, minHeight: 40, alignment: .topLeading)

                RatingView(rating: rating)

                Text("$\(price, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
    }
}

#Preview {
    SingleProduct(
        productId: 1,
        category: "Comfort",
        title: "Memory Foam Neck Pillow",
        rating: 4.7,
        price: 34.99,
        imageURL: "placeholder", isFavorited: false, onToggleFavorite: {}
    )
    .frame(width: 180)
}

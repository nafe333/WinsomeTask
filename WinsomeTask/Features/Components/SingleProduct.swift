//
//  SingleProduct.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import SwiftUI

struct SingleProduct: View {
    let category: String
    let title: String
    let rating: Double
    let price: Double
    let imageURL: String
    @State private var isFavorited: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack(alignment: .topTrailing) {
                
                
                AsyncImage(url: URL(string: imageURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 160)
                                            .background(Color.gray.opacity(0.1))
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .foregroundStyle(.gray)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 160)
                                            .background(Color.gray.opacity(0.1))
                                    @unknown default:
                                        EmptyView()
                                    }
                                }

                            Button {
                                isFavorited.toggle()
                            } label: {
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
                 //   .fixedSize(horizontal: false, vertical: true)

                RatingView(rating: rating)

                Text("$\(price, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding()
        }
        .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 8, y: 8)
    }
}
#Preview {
    SingleProduct(
        category: "Comfort",
        title: "Memory Foam Neck Pillow",
        rating: 4.7,
        price: 34.99,
        imageURL: "placeholder"
    )
    .frame(width: 180)
}

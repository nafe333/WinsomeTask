//
//  FavoriteProduct.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation
import SwiftData

@Model
final class FavoriteProduct {
    @Attribute(.unique) var id: Int
    var title: String
    var category: String
    var price: Double
    var rating: Double
    var thumbnail: String

    init(id: Int, title: String, category: String, price: Double, rating: Double, thumbnail: String) {
        self.id = id
        self.title = title
        self.category = category
        self.price = price
        self.rating = rating
        self.thumbnail = thumbnail
    }
}

extension FavoriteProduct {
    convenience init(from product: Product) {
        self.init(
            id: product.id ?? 0,
            title: product.title ?? "Untitled",
            category: product.category ?? "General",
            price: product.price ?? 0,
            rating: product.rating ?? 0,
            thumbnail: product.thumbnail ?? ""
        )
    }

    func toProduct() -> Product {
        Product(
            id: id, title: title, description: nil, category: category,
            price: price, rating: rating, stock: nil, tags: nil,
            brand: nil, shippingInformation: nil, images: nil, thumbnail: thumbnail
        )
    }
}

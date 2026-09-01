//
//  ProductDetailsViewModel.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation
import Combine

@MainActor
final class ProductDetailViewModel: ObservableObject {
    let product: Product
    @Published private(set) var quantity: Int = 1

    private var maxQuantity: Int {
        max(product.stock ?? 1, 1)
    }

    var isOutOfStock: Bool {
        (product.stock ?? 0) <= 0
    }

    var total: Double {
        (product.price ?? 0) * Double(quantity)
    }

    var canIncrement: Bool {
        !isOutOfStock && quantity < maxQuantity
    }

    var canDecrement: Bool {
        !isOutOfStock && quantity > 1
    }

    func increment() {
        guard canIncrement else { return }
        quantity += 1
    }

    func decrement() {
        guard canDecrement else { return }
        quantity -= 1
    }

    init(product: Product) {
        self.product = product
    }
}

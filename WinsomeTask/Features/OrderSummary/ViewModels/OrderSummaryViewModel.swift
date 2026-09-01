//
//  OrderSummaryViewModel.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation
import Combine
import AudioToolbox

@MainActor
final class OrderSummaryViewModel: ObservableObject {
    let product: Product
    let quantity: Int
    
    private let serviceFeeRate: Double = 0.05
    @Published var showConfirmationAlert = false
    private var orderService: OrderServiceProtocol?
    @Published private(set) var isSubmitting = false


    
    var unitPrice: Double {
            product.price ?? 0
        }
    var subtotal: Double {
        unitPrice * Double(quantity)
    }

    var serviceFee: Double {
        subtotal * serviceFeeRate
    }

    var total: Double {
        subtotal + serviceFee
    }

    // MARK: - Behaviour
    
    init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
    
    func configure(orderService: OrderServiceProtocol) {
        self.orderService = orderService
    }
    
    func confirmOrder(ordersViewModel: OrdersViewModel) {
        guard !isSubmitting else { return }

        isSubmitting = true

        let order = Order(
            productId: product.id ?? 0,
            title: product.title ?? "Untitled",
            category: product.category ?? "General",
            thumbnail: product.thumbnail ?? "",
            quantity: quantity,
            unitPrice: unitPrice,
            total: total
        )

        Task {
            do {
                try await orderService?.save(order)

                ordersViewModel.addOrder(order)

                AudioServicesPlaySystemSound(1005)
                showConfirmationAlert = true
            } catch {
                print("Failed to save order: \(error.localizedDescription)")
            }

            isSubmitting = false
        }
    }
    
}

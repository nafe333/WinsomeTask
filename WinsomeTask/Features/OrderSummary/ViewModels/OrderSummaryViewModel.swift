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

    init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
    
    
}

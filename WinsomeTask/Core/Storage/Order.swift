//
//  Order.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation
import SwiftData
@Model
final class Order {
    @Attribute(.unique) var id: UUID
    var productId: Int
    var title: String
    var category: String
    var thumbnail: String
    var quantity: Int
    var unitPrice: Double
    var total: Double
    var status: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        productId: Int,
        title: String,
        category: String,
        thumbnail: String,
        quantity: Int,
        unitPrice: Double,
        total: Double,
        status: String = "Delivered",
        createdAt: Date = .now
    ) {
        self.id = id
        self.productId = productId
        self.title = title
        self.category = category
        self.thumbnail = thumbnail
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.total = total
        self.status = status
        self.createdAt = createdAt
    }
}

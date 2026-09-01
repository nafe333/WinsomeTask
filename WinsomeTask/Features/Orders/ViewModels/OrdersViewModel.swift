//
//  OrdersViewModel.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation
import Combine

@MainActor
final class OrdersViewModel: ObservableObject {
    @Published private(set) var orders: [Order] = []
    private var orderService: OrderServiceProtocol?

    
    func configure(orderService: OrderServiceProtocol) {
        guard self.orderService == nil else { return }
        self.orderService = orderService
        Task { await loadOrders() }
    }
    
    func loadOrders() async {
        orders = await orderService?.loadAll() ?? []
    }
    
    func addOrder(_ order: Order) {
        orders.insert(order, at: 0)
    }
}

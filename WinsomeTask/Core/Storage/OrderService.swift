//
//  OrderCacheService.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation
import SwiftData

protocol OrderServiceProtocol {
    func save(_ order: Order) async
    func loadAll() async -> [Order]
}

@MainActor
final class OrderService: OrderServiceProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ order: Order) async {
           modelContext.insert(order)
           try? modelContext.save()
       }

       func loadAll() async -> [Order] {
           let descriptor = FetchDescriptor<Order>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
           return (try? modelContext.fetch(descriptor)) ?? []
       }
}

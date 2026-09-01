//
//  ProductCacheService.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation
import SwiftData

protocol ProductCacheServiceProtocol {
    func save(_ products: [Product]) async
    func loadCached() async -> [Product]
    func imageData(forProductId id: Int) async -> Data?
    func saveImageData(_ data: Data, forProductId id: Int) async
}

@MainActor
final class ProductCacheService: ProductCacheServiceProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save(_ products: [Product]) async {
        try? modelContext.delete(model: CachedProduct.self)
        for product in products {
            modelContext.insert(CachedProduct(from: product))
        }
        try? modelContext.save()
    }
    
    func loadCached() async -> [Product] {
        let descriptor = FetchDescriptor<CachedProduct>()
        let cached = (try? modelContext.fetch(descriptor)) ?? []
        return cached.map { $0.toProduct() }
    }
    
    func imageData(forProductId id: Int) async -> Data? {
           let descriptor = FetchDescriptor<CachedProduct>(predicate: #Predicate { $0.id == id })
           return (try? modelContext.fetch(descriptor))?.first?.imageData
       }
    
    func saveImageData(_ data: Data, forProductId id: Int) async {
           let descriptor = FetchDescriptor<CachedProduct>(predicate: #Predicate { $0.id == id })
           guard let product = (try? modelContext.fetch(descriptor))?.first else { return }
           product.imageData = data
           try? modelContext.save()
       }
}

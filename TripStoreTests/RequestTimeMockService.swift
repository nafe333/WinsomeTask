//
//  RequestTimeMockService.swift
//  TripStoreTests
//
//  Created by Nafe3's Macbook on 02/09/2026.
//

import XCTest
@testable import WinsomeTask

final class RequestTimeMockService: ProductServiceProtocol {
    private var callCount = 0

    func getProducts(params: ProductQueryParams) async throws -> ProductResponse {
        callCount += 1
        let isFirstCall = callCount == 1
// we test here request time outdated 
        if isFirstCall {
            try? await Task.sleep(nanoseconds: 300_000_000)
            let staleProduct = Product(id: 1, title: "STALE", description: nil, category: nil, price: 1, rating: nil, stock: 1, tags: nil, brand: nil, shippingInformation: nil, images: nil, thumbnail: nil)
            return ProductResponse(products: [staleProduct], total: 1, skip: 0, limit: 20)
        } else {
            let freshProduct = Product(id: 2, title: "FRESH", description: nil, category: nil, price: 2, rating: nil, stock: 1, tags: nil, brand: nil, shippingInformation: nil, images: nil, thumbnail: nil)
            return ProductResponse(products: [freshProduct], total: 1, skip: 0, limit: 20)
        }
    }
}

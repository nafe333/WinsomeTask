//
//  MockProductService.swift
//  TripStoreTests
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation
@testable import WinsomeTask

final class MockProductService: ProductServiceProtocol {
    var stubbedResponse = ProductResponse(products: [], total: 0, skip: 0, limit: 20)
    var stubbedError: Error?
    var capturedParams: [ProductQueryParams] = []

    func getProducts(params: ProductQueryParams) async throws -> ProductResponse {
        capturedParams.append(params)
        if let stubbedError {
            throw stubbedError
        }
        return stubbedResponse
    }
}

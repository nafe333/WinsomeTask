//
//  ProductServiceTests.swift
//  TripStoreTests
//
//  Created by Nafe3's Macbook on 02/09/2026.
//

import XCTest
@testable import WinsomeTask
final class ProductServiceTests: XCTestCase {

    func testGetProductsReturnsWhatNetworkManagerProvides() async throws {
        let mockNetwork = MockNetworkManager()
        let product = Product(id: 1, title: "Mock Product", description: nil, category: nil, price: 9.99, rating: nil, stock: 3, tags: nil, brand: nil, shippingInformation: nil, images: nil, thumbnail: nil)
        mockNetwork.stubbedResponse = ProductResponse(products: [product], total: 1, skip: 0, limit: 20)

        let service = await ProductService(networkManager: mockNetwork)
        let params = ProductQueryParams(searchQuery: nil, category: nil, sortBy: nil, order: nil, limit: 20, skip: 0)
        let result = try await service.getProducts(params: params)

        let firstProductTitle = await result.products?.first?.title
        XCTAssertEqual(firstProductTitle, "Mock Product")
    }
}

//
//  ProductsViewModelTests.swift
//  TripStoreTests
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import XCTest
@testable import WinsomeTask

@MainActor
final class ProductsViewModelTests: XCTestCase {
    let mockService = MockProductService()

    func testSelectingCategorySendsCorrectParam() async {
        let viewModel = ProductsViewModel(service: mockService)

        viewModel.selectCategory("beauty")

        try? await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertEqual(mockService.capturedParams.last?.category, "beauty")
    }
    
    func testSortOptionSendsCorrectParams() async {
        let viewModel = ProductsViewModel(service: mockService)

        viewModel.selectSort(.priceLowToHigh)

        try? await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertEqual(mockService.capturedParams.last?.sortBy, "price")
        XCTAssertEqual(mockService.capturedParams.last?.order, "asc")
    }
    
    func testSuccessfulFetchSetsLoadedState() async {
        let product = Product(id: 1, title: "Test", description: nil, category: nil, price: 10, rating: 4, stock: 5, tags: nil, brand: nil, shippingInformation: nil, images: nil, thumbnail: nil)
        mockService.stubbedResponse = ProductResponse(products: [product], total: 1, skip: 0, limit: 20)

        let viewModel = ProductsViewModel(service: mockService)
        await viewModel.refresh()

        XCTAssertEqual(viewModel.state, .loaded)
    }

    func testEmptyResultSetsEmptyState() async {
        mockService.stubbedResponse = ProductResponse(products: [], total: 0, skip: 0, limit: 20)

        let viewModel = ProductsViewModel(service: mockService)
        await viewModel.refresh()

        XCTAssertEqual(viewModel.state, .empty)
    }
    
    func testFailedFetchWithNoCacheSetsErrorState() async {
        mockService.stubbedError = NetworkError.invalidResponse

        let viewModel = ProductsViewModel(service: mockService)
        await viewModel.refresh()

        if case .error = viewModel.state {
        } else {
            XCTFail("Expected .error state, got \(viewModel.state)")
        }
    }
}

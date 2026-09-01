//
//  ProductDetailViewModelTests.swift
//  TripStoreTests
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import XCTest
@testable import WinsomeTask
@MainActor
final class ProductDetailViewModelTests: XCTestCase {

    func testCannotIncrementPastStock() {
        let product = Product(
            id: 1, title: "Test", description: nil, category: nil,
            price: 10, rating: nil, stock: 1, tags: nil, brand: nil,
            shippingInformation: nil, images: nil, thumbnail: nil
        )
        let viewModel = ProductDetailViewModel(product: product)

        viewModel.increment()

        XCTAssertEqual(viewModel.quantity, 1)
    }

    func testCannotDecrementBelowOne() {
        let product = Product(
            id: 1, title: "Test", description: nil, category: nil,
            price: 10, rating: nil, stock: 10, tags: nil, brand: nil,
            shippingInformation: nil, images: nil, thumbnail: nil
        )
        let viewModel = ProductDetailViewModel(product: product)

        viewModel.decrement()

        XCTAssertEqual(viewModel.quantity, 1)
    }
}

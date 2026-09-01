//
//  OrderSummaryViewModelTests.swift
//  TripStoreTests
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import XCTest
@testable import WinsomeTask

@MainActor
final class OrderSummaryViewModelTests: XCTestCase {

    func testServiceFeeIsFivePercentOfSubtotal() {
        let product = Product(
            id: 1, title: "Test", description: nil, category: nil,
            price: 20, rating: nil, stock: 10, tags: nil, brand: nil,
            shippingInformation: nil, images: nil, thumbnail: nil
        )
        let viewModel = OrderSummaryViewModel(product: product, quantity: 1)

        XCTAssertEqual(viewModel.serviceFee, 1.0, accuracy: 0.001)
    }
    
    func testTotalIncludesSubtotalAndFee() {
        let product = Product(
            id: 1, title: "Test", description: nil, category: nil,
            price: 20, rating: nil, stock: 10, tags: nil, brand: nil,
            shippingInformation: nil, images: nil, thumbnail: nil
        )
        let viewModel = OrderSummaryViewModel(product: product, quantity: 1)

        XCTAssertEqual(viewModel.total, 21.0, accuracy: 0.001)
    }
}

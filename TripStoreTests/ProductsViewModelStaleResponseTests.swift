//
//  ProductsViewModelStaleResponseTests.swift
//  TripStoreTests
//
//  Created by Nafe3's Macbook on 02/09/2026.
//

import XCTest
@testable import WinsomeTask
@MainActor
final class ProductsViewModelStaleResponseTests: XCTestCase {

    func testStaleSlowResponseDoesNotOverwriteNewerResult() async {
        let mockService = RequestTimeMockService()
        let viewModel = ProductsViewModel(service: mockService)

        let staleTask = Task { await viewModel.refresh() }
        try? await Task.sleep(nanoseconds: 50_000_000)
        await viewModel.refresh()
        await staleTask.value

        XCTAssertEqual(viewModel.visibleProducts.first?.title, "FRESH")
    }
}

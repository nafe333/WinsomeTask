//
//  ProductsViewModel.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import Foundation
import Combine

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service: ProductServiceProtocol
    
    init(service: ProductServiceProtocol = ProductService()) {
            self.service = service
        }

    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await service.getProducts()
            products = response.products ?? []
        } catch {
            errorMessage = "Failed to load products. Please try again."
        }
        isLoading = false
    }
}

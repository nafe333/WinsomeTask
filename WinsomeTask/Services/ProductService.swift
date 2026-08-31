//
//  ProductService.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import Foundation

protocol ProductServiceProtocol {
    func getProducts() async throws -> ProductResponse
}

class ProductService: ProductServiceProtocol {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging = NetworkingManager()) {
        self.networkManager = networkManager
    }
    
    func getProducts() async throws -> ProductResponse {
        try await networkManager.fetch(.products)
    }
    
}

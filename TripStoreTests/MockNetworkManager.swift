//
//  MockNetworkManager.swift
//  TripStoreTests
//
//  Created by Nafe3's Macbook on 02/09/2026.
//

import XCTest
@testable import WinsomeTask

final class MockNetworkManager: NetworkManaging {
    var stubbedResponse: ProductResponse?
    var stubbedError: Error?

    func fetch<T>(_ endpoint: Endpoint) async throws -> T where T: Decodable {
        if let stubbedError {
            throw stubbedError
        }
        guard let response = stubbedResponse as? T else {
            throw NetworkError.decodingFailed(NSError(domain: "Mock", code: 0))
        }
        return response
    }
}

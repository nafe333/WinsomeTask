//
//  Endpoints.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import Foundation
enum Endpoint {
    case products
    case product(id: Int)

    var path: String {
        switch self {
        case .products:
            return "/products"
        case .product(let id):
            return "/products/\(id)"
        }
    }

    var url: URL? {
        URL(string: Constants.baseURL + path)
    }
}

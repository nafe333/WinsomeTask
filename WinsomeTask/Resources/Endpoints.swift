//
//  Endpoints.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import Foundation

struct ProductQueryParams: Sendable {
    var searchQuery: String?
    var category: String?
    var sortBy: String?
    var order: String?
    var limit: Int
    var skip: Int
}

enum Endpoint: Sendable {
    case products(ProductQueryParams)
  //  case product(id: Int)

    var path: String {
        switch self {
        case .products:
            return "/products"
//        case .product(let id):
//            return "/products/\(id)"
        }
    }

    var url: URL? {
        guard var components = URLComponents(string: Constants.baseURL) else { return nil }
        
        switch self {
               case .products(let params):
                   if let query = params.searchQuery, !query.isEmpty {
                       components.path = "/products/search"
                       components.queryItems = baseItems(params) + [URLQueryItem(name: "q", value: query)]
                   } else if let category = params.category {
                       components.path = "/products/category/\(category)"
                       components.queryItems = baseItems(params)
                   } else {
                       components.path = "/products"
                       components.queryItems = baseItems(params)
                   }
        }
               return components.url
           }
    
    private func baseItems(_ params: ProductQueryParams) -> [URLQueryItem] {
           var items = [
               URLQueryItem(name: "limit", value: "\(params.limit)"),
               URLQueryItem(name: "skip", value: "\(params.skip)")
           ]
           if let sortBy = params.sortBy { items.append(URLQueryItem(name: "sortBy", value: sortBy)) }
           if let order = params.order { items.append(URLQueryItem(name: "order", value: order)) }
           return items
       }
}

//
//  ProductResponse.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]?
    let total: Int?
    let skip: Int?
    let limit: Int?
    
    enum CodingKeys: String, CodingKey {
        case products = "products"
        case total = "total"
        case skip = "skip"
        case limit = "limit"
    }
}

// MARK: - Product
struct Product: Codable, Identifiable, Hashable {
    let id: Int?
    let title: String?
    let description: String?
    let category: String?
    let price: Double?
    let rating: Double?
    let stock: Int?
    let tags: [String]?
    let brand: String?
    let shippingInformation: String?
    let images: [String]?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case category = "category"
        case price = "price"
        case rating = "rating"
        case stock = "stock"
        case tags = "tags"
        case brand = "brand"
        case shippingInformation = "shippingInformation"
        case images = "images"
        case thumbnail = "thumbnail"
    }
}



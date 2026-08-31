//
//  SortOptions.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case none = "Default"
    case priceLowToHigh = "Price: Low to High"
    case priceHighToLow = "Price: High to Low"
    case ratingHighToLow = "Rating: High to Low"

    var id: String { rawValue }

    var apiSortBy: String? {
        switch self {
        case .none: return nil
        case .priceLowToHigh, .priceHighToLow: return "price"
        case .ratingHighToLow: return "rating"
        }
    }

    var apiOrder: String? {
        switch self {
        case .none: return nil
        case .priceLowToHigh: return "asc"
        case .priceHighToLow, .ratingHighToLow: return "desc"
        }
    }
}

enum LoadState: Equatable {
    case idle
    case loading
    case loadingMore
    case loaded
    case empty
    case error(String)
}

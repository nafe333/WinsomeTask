//
//  networkError.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed(Error)
    case requestFailed(Error)
    case statusCode(Int)
}

//
//  WinsomeTaskApp.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 30/08/2026.
//

import SwiftUI
import SwiftData

@main
struct WinsomeTaskApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: CachedProduct.self)

    }
}

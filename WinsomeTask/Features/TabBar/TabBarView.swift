//
//  TabBarView.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import SwiftUI
import SwiftData

struct TabBarView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var favoritesManager = FavoritesManager()

    var body: some View {
        TabView {
            NavigationStack {
                            HomeView()
                        }                            .tabItem {
                                Label("Shop", systemImage: "house")
                            }
            
            NavigationStack {
                            FavouritesView()
                        }                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
            
            
        }
        .environmentObject(favoritesManager)
                .task {
                    favoritesManager.configure(modelContext: modelContext)
                }
    }
}

#Preview {
    TabBarView()
}

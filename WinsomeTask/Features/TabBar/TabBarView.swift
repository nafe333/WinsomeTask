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
    @StateObject private var ordersViewModel = OrdersViewModel()


    var body: some View {
        TabView {
            NavigationStack {
                            HomeView()
                        }                            .tabItem {
                                Label("Shop", systemImage: "bag")
                            }
            
            NavigationStack {
                            FavouritesView()
                        }                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
            
            OrdersView()
                            .tabItem { Label("Orders", systemImage: "shippingbox") }
                            .badge(ordersViewModel.orders.count)
            
            
        }
        .environmentObject(favoritesManager)
                .task {
                    favoritesManager.configure(modelContext: modelContext)
                                ordersViewModel.configure(orderService: OrderService(modelContext: modelContext))
                }
    }
}

#Preview {
    TabBarView()
}

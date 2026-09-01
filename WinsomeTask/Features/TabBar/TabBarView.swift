//
//  TabBarView.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
            
            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
            
            
        }
    }
}

#Preview {
    TabBarView()
}

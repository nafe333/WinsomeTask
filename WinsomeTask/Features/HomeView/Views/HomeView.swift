//
//  ContentView.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 30/08/2026.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = ProductsViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
            } else {
                VStack(alignment: .leading) {
                  Text("TripStore")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
             productsSection
            }
                    .padding()
                }
            }

                .task{
                    await viewModel.loadProducts()
                }
        }
    }


#Preview {
    HomeView()
}
extension HomeView {
    private var productsSection: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.products) { product in
                    SingleProduct(
                        category: product.category ?? "General",
                        title: product.title ?? "Untitled",
                        rating: product.rating ?? 0,
                        price: product.price ?? 0,
                        imageURL: product.thumbnail ?? ""
                    )
                }
            }
        }
    }
}

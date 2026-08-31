//
//  ContentView.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 30/08/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ProductsViewModel()
    @State private var showFilterSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("TripStore")
                .font(.largeTitle)
                .fontWeight(.heavy)

            searchBarSection
            categoryFilterSection
            filterSortSection

            contentSection
        }
        .padding(.horizontal)
        .task {
            await viewModel.loadInitialIfNeeded()
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheet(viewModel: viewModel)
        }
    }
}

extension HomeView {

    @ViewBuilder
    private var contentSection: some View {
        switch viewModel.state {
        case .idle, .loading:
            loadingView
        case .empty:
            emptyView
        case .error(let message):
            errorView(message)
        case .loaded, .loadingMore:
            productsSection
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Loading products…")
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "shippingbox")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No products found")
                .font(.headline)
            Text("Try adjusting your search or filters.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if viewModel.hasActiveFilters {
                Button("Reset filters") {
                    withAnimation { viewModel.resetFilters() }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 4)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundStyle(.orange)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Retry") {
                Task { await viewModel.retry() }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }

    private var productsSection: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.visibleProducts) { product in
                    SingleProduct(
                        category: product.category ?? "General",
                        title: product.title ?? "Untitled",
                        rating: product.rating ?? 0,
                        price: product.price ?? 0,
                        imageURL: product.thumbnail ?? ""
                    )
                    .onAppear {
                        Task { await viewModel.loadNextPageIfNeeded(currentItem: product) }
                    }
                }
            }
            .padding(.vertical, 4)
            .animation(.easeInOut(duration: 0.25), value: viewModel.selectedCategory)

            if viewModel.isLoadingMore {
                ProgressView()
                    .padding(.vertical, 12)
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    private var searchBarSection: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search accessories", text: $viewModel.searchText)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }

    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Text(category.capitalized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(viewModel.selectedCategory == category ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(viewModel.selectedCategory == category ? Color.black : Color(.systemGray6))
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                viewModel.selectCategory(category)
                            }
                        }
                }
            }
        }
    }

    private var filterSortSection: some View {
        HStack {
            Button {
                showFilterSheet = true
            } label: {
                Label("Filter", systemImage: "slider.horizontal.3")
            }

            sortMenu

            Spacer()
            Text("\(viewModel.visibleProducts.count) items")
                .foregroundStyle(.secondary)
        }
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundStyle(.primary)
    }

    private var sortMenu: some View {
        Menu {
            ForEach(SortOption.allCases) { option in
                Button {
                    viewModel.selectSort(option)
                } label: {
                    if viewModel.sortOption == option {
                        Label(option.rawValue, systemImage: "checkmark")
                    } else {
                        Text(option.rawValue)
                    }
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
    }
}

#Preview {
    HomeView()
}

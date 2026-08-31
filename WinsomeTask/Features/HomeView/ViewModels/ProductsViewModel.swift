//
//  ProductsViewModel.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import Foundation
import Combine

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var state: LoadState = .idle
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"
    @Published var sortOption: SortOption = .none
    @Published var minRating: Double = 0

    private let service: ProductServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentSkip = 0
    private let pageSize = 20
    private var canLoadMorePages = true
    private var activeRequestID = UUID()

    
    convenience init() {
        self.init(service: ProductService())
    }

    init(service: ProductServiceProtocol) {
        self.service = service
        observeSearchText()
    }
    
    // MARK: - Properties
    
    var visibleProducts: [Product] {
        minRating > 0 ? products.filter { ($0.rating ?? 0) >= minRating } : products
    }

    var categories: [String] {
        ["All"] + Set(products.compactMap(\.category)).sorted()
    }

    var hasActiveFilters: Bool {
        !searchText.isEmpty || selectedCategory != "All" || sortOption != .none || minRating > 0
    }
    
    var isLoadingMore: Bool {
        if case .loadingMore = state { return true }
        return false
    }

    
    // MARK: - User actions

       func selectCategory(_ category: String) {
           selectedCategory = category
           Task { await refresh() }
       }

       func selectSort(_ option: SortOption) {
           sortOption = option
           Task { await refresh() }
       }

       func setMinRating(_ rating: Double) {
           minRating = rating
           state = visibleProducts.isEmpty ? .empty : .loaded
       }

       func resetFilters() {
           searchText = ""
           selectedCategory = "All"
           sortOption = .none
           minRating = 0
           Task { await refresh() }
       }
    
    private func observeSearchText() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.refresh() }
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Loading

      func loadInitialIfNeeded() async {
          guard state == .idle else { return }
          await refresh()
      }

    func refresh() async {
        currentSkip = 0
        canLoadMorePages = true
        await fetch(isFirstPage: true)
    }

    func loadNextPageIfNeeded(currentItem product: Product) async {
        guard product.id == products.last?.id, canLoadMorePages, state == .loaded else { return }
        await fetch(isFirstPage: false)
    }


      func retry() async {
          await refresh()
      }

    private func fetch(isFirstPage: Bool) async {
           let requestID = UUID()
           activeRequestID = requestID
           state = isFirstPage ? .loading : .loadingMore

           let params = ProductQueryParams(
               searchQuery: searchText.isEmpty ? nil : searchText,
               category: selectedCategory == "All" ? nil : selectedCategory,
               sortBy: sortOption.apiSortBy,
               order: sortOption.apiOrder,
               limit: pageSize,
               skip: currentSkip
           )

           do {
               let response = try await service.getProducts(params: params)
               guard requestID == activeRequestID else { return }

               let newProducts = response.products ?? []
               products = isFirstPage ? newProducts : products + newProducts
               currentSkip += newProducts.count
               canLoadMorePages = products.count < (response.total ?? products.count) && !newProducts.isEmpty

               state = visibleProducts.isEmpty ? .empty : .loaded
           } catch {
               guard requestID == activeRequestID else { return }
               if isFirstPage {
                   state = .error("Failed to load products. Please try again.")
               } else {
                   state = .loaded
               }
           }
       }
}

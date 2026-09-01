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
    @Published private(set) var isShowingCachedData = false
    @Published private(set) var categories: [String] = ["All"]
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"
    @Published var sortOption: SortOption = .none
    @Published var minRating: Double = 0

    private let service: ProductServiceProtocol
    private var cacheService: ProductCacheServiceProtocol?
    private let networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()
    private var currentSkip = 0
    private let pageSize = 20
    private var canLoadMorePages = true
    private var activeRequestID = UUID()


    init(
        service: ProductServiceProtocol = ProductService(),
        networkMonitor: NetworkMonitor = .shared
    ) {
        self.service = service
        self.networkMonitor = networkMonitor
        observeSearchText()
    }
    
    // MARK: - Properties
    
    var visibleProducts: [Product] {
        minRating > 0 ? products.filter { ($0.rating ?? 0) >= minRating } : products
    }

    var hasActiveFilters: Bool {
        !searchText.isEmpty || selectedCategory != "All" || sortOption != .none || minRating > 0
    }
    
    var isLoadingMore: Bool {
        if case .loadingMore = state { return true }
        return false
    }

    
    // MARK: - User actions

    func configureCache(_ cacheService: ProductCacheServiceProtocol) {
        self.cacheService = cacheService
    }
    
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
          await loadCategoriesIfNeeded()
      }

    func refresh() async {
        currentSkip = 0
        canLoadMorePages = true
        await fetch(isFirstPage: true)
    }

    func loadNextPageIfNeeded(currentItem product: Product) async {
        guard product.id == products.last?.id,
              canLoadMorePages,
              state == .loaded,
              networkMonitor.isConnected else { return }
        await fetch(isFirstPage: false)
    }


      func retry() async {
          await refresh()
      }

    private func fetch(isFirstPage: Bool, isPullToRefresh: Bool = false) async {
        let requestID = UUID()
        activeRequestID = requestID
        if !isPullToRefresh {
            state = isFirstPage ? .loading : .loadingMore
        }
        
        guard networkMonitor.isConnected else {
            await loadFromCache(requestID: requestID)
            return
        }
        
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
            isShowingCachedData = false
            
            if isFirstPage {
                await cacheService?.save(newProducts)
            }
            state = visibleProducts.isEmpty ? .empty : .loaded
        } catch {
            guard requestID == activeRequestID else { return }
            if isFirstPage && !isPullToRefresh {
                await loadFromCache(requestID: requestID)
            } else {
                state = .loaded
            }
        }
    }
    
    private func loadFromCache(requestID: UUID) async {
           let cached = await cacheService?.loadCached() ?? []  
           guard requestID == activeRequestID else { return }

           if cached.isEmpty {
               state = .error("No internet connection and no cached products available.")
           } else {
               products = cached
               isShowingCachedData = true
               state = .loaded
           }
       }
    
    
    // MARK: - Refreshing logic
    func pullToRefresh() async {
    currentSkip = 0
    canLoadMorePages = true
    await fetch(isFirstPage: true, isPullToRefresh: true)
}

    
    // MARK: - Categories
    
    private func loadCategoriesIfNeeded() async {
        guard categories.count <= 1 else { return }
        do {
            let allProductsResponse = try await service.getProducts(params: ProductQueryParams(
                searchQuery: nil, category: nil, sortBy: nil, order: nil, limit: 100, skip: 0
            ))
            let unique = Set((allProductsResponse.products ?? []).compactMap(\.category))
            categories = ["All"] + unique.sorted()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

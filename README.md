# Winsome Task -- TripStore 🛍️
This is a SwiftUI iOS shopping app built using the MVVM architecture. It pulls product data from the DummyJSON API and lets users browse, search, filter, sort, favourite items, and place a simple order — with offline support and local caching.

This repo (`WinsomeTask`) was built as a take-home task for Winsome's iOS application process.

---

## What the app does

The app is a simple product catalogue — think a small e-commerce browsing screen. You can search products, filter by category and rating, sort by price or rating, save favourites, tap into a product for details, and go through a basic order-confirmation flow. It also works offline by caching the last-loaded products and images.

---

## Main features

- Product catalogue with pagination (loads more as you scroll)
- Debounced search, category filter, minimum-rating filter, and sort by price/rating
- Pull-to-refresh, with distinct loading / empty / error states
- Offline support — cached products and images load automatically when there's no internet
- Favourites, persisted with SwiftData
- Product details screen with quantity stepper and stock validation
- Order summary screen with price breakdown, saved to an Orders history
- Unit tests covering pricing logic, filtering, view-model states, and a concurrency edge case

---
## Architecture

The project follows MVVM:
- **Models** — data structures, both API responses and SwiftData models
- **Views** — SwiftUI screens, kept as dumb as possible
- **ViewModels** — all business logic, state, and API/cache calls live here
- **Services** — protocol-backed classes that fetch or persist data (networking and SwiftData), so ViewModels never talk to `URLSession` or `ModelContext` directly
- **Core** — shared low-level pieces as networking client
- **Resources** -- contains assets and shared endpoints and constants
  
  Goal was the same as always: keep Views free of logic, and make everything else easy to test in isolation.

  ---

## APIs used

- [DummyJSON](https://dummyjson.com/products) — for all product data (no API key needed)

---

## Tech stack

- SwiftUI
- Combine (debounced search)
- MVVM
- SwiftData (caching, favourites, orders)
- Network framework (offline detection)
- URLSession for networking
- XCTest for unit tests

---

## Project structure

- App
- Models
- Services
- Core → Network / Storage / Utilities
- Features → one folder per screen (Home, ProductDetails, OrderSummary, Orders, Favourites)
- Resources

## Setup

1. Open `WinsomeTask.xcodeproj` in Xcode 16+.
2. Run on any iOS 17+ simulator with **⌘R**.
3. No API keys or config needed — DummyJSON is public.

## Running tests

Press **⌘U**, or run the `WinsomeTaskTests` scheme. All tests are self-contained (mocked network and services), so they run instantly with no setup.

---

## Assumptions & trade-offs

- Treated DummyJSON as a stable public API with no auth needed.
- "Out of stock" is just `stock == 0` from the API — there's no separate status field.
- Order status is set straight to "Delivered" on confirmation, since there's no real backend to simulate a Processing → Shipped flow.
- Minimum-rating filter is applied client-side on top of whatever's already paginated in, since DummyJSON has no rating filter param — so the item count only reflects loaded pages, not the whole catalogue.
- The product cache stores only the latest fetched page (replaced each refresh), not the full paginated history — kept simple since its only job is offline fallback, not a full offline mirror.
- Product images are cached as data blobs inside the same SwiftData record as their product, rather than a separate file cache — simpler, and images get cleaned up automatically with their product.  

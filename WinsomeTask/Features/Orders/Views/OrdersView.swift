//
//  OrdersView.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import SwiftUI
import SwiftData

struct OrdersView: View {
    @StateObject private var viewModel = OrdersViewModel()
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack {
                   Group {
                       if viewModel.orders.isEmpty {
                           emptyState
                       } else {
                           List(viewModel.orders) { order in
                               orderRow(order)
                           }
                           .listStyle(.plain)
                       }
                   }
                   .padding()
                   .navigationTitle("Orders")
                   .task {
                       viewModel.configure(orderService: OrderService(modelContext: modelContext))
                   }
               }
    }
    
    private func orderRow(_ order: Order) -> some View {
            HStack(spacing: 12) {
                CachedAsyncImage(productId: order.productId, url: URL(string: order.thumbnail))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(order.title)
                        .font(.headline)
                        .lineLimit(1)

                    Text("Qty: \(order.quantity) · \(order.createdAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 6, height: 6)
                        Text(order.status)
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                }

                Spacer()

                Text("$\(order.total, specifier: "%.2f")")
                    .font(.headline)
            }
            .padding(.vertical, 6)
        }

        private var emptyState: some View {
            VStack(spacing: 12) {
                Spacer()
                Image(systemName: "shippingbox")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
                Text("No orders yet")
                    .font(.headline)
                Text("Your placed orders will show up here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
}

#Preview {
    OrdersView()
}

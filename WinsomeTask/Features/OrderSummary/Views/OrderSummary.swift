//
//  OrderSummary.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import SwiftUI
import SwiftData

struct OrderSummary: View {
    @StateObject private var viewModel: OrderSummaryViewModel
    @EnvironmentObject private var ordersViewModel: OrdersViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    init(product: Product, quantity: Int) {
        _viewModel = StateObject(wrappedValue: OrderSummaryViewModel(product: product, quantity: quantity))
    }

    
    var body: some View {
        ScrollView {
                   VStack(spacing: 16) {
                       productCard
                       priceDetailsCard
                       confirmButton
                       termsNotice
                   }
                   .padding(.top, 8)
               }
        .background(Color(.systemGray6))
                .navigationTitle("Order Summary")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                            viewModel.configure(orderService: OrderService(modelContext: modelContext))
                        }
                        .alert("Order Confirmed", isPresented: $viewModel.showConfirmationAlert) {
                            Button("OK") {
                                dismiss()
                            }
                        } message: {
                            Text("Your order for \(viewModel.product.title ?? "this item") has been placed.")
                        }
    }
}
extension OrderSummary {
    private var productCard: some View {
           HStack(alignment: .top, spacing: 12) {
               CachedAsyncImage(productId: viewModel.product.id ?? 0, url: URL(string: viewModel.product.thumbnail ?? ""))
                   .aspectRatio(contentMode: .fill)
                   .frame(width: 72, height: 72)
                   .clipShape(RoundedRectangle(cornerRadius: 12))

               VStack(alignment: .leading, spacing: 4) {
                   Text((viewModel.product.category ?? "General").uppercased())
                       .font(.caption)
                       .fontWeight(.bold)
                       .foregroundStyle(.blue)

                   Text(viewModel.product.title ?? "Untitled")
                       .font(.headline)
                       .lineLimit(2)

                   Text("Qty: \(viewModel.quantity)")
                       .font(.subheadline)
                       .foregroundStyle(.secondary)
               }

               Spacer()
           }
           .padding()
           .background(.white, in: RoundedRectangle(cornerRadius: 16))
           .padding(.horizontal)
       }
    
    private var priceDetailsCard: some View {
           VStack(alignment: .leading, spacing: 14) {
               Text("Price Details")
                   .font(.headline)

               priceRow(
                label: "$\(viewModel.unitPrice, default: "%.2f") × \(viewModel.quantity)",
                   value: viewModel.subtotal,
                   valueWeight: .semibold
               )

               priceRow(
                   label: "Service fee (5%)",
                   value: viewModel.serviceFee,
                   valueWeight: .semibold
               )

               Divider()

               HStack {
                   Text("Total")
                       .font(.headline)
                   Spacer()
                   Text("$\(viewModel.total, specifier: "%.2f")")
                       .font(.title3)
                       .fontWeight(.bold)
                       .foregroundStyle(.blue)
               }
           }
           .padding()
           .background(.white, in: RoundedRectangle(cornerRadius: 16))
           .padding(.horizontal)
       }

       private func priceRow(label: String, value: Double, valueWeight: Font.Weight) -> some View {
           HStack {
               Text(label)
                   .foregroundStyle(.secondary)
               Spacer()
               Text("$\(value, specifier: "%.2f")")
                   .fontWeight(valueWeight)
           }
       }

    private var confirmButton: some View {
        Button {
            viewModel.confirmOrder(ordersViewModel: ordersViewModel)
        } label: {
            Text(viewModel.isSubmitting ? "Placing Order..." : "Confirm Order")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    Color(
                        red: 0.1,
                        green: 0.15,
                        blue: 0.3
                    ),
                    in: RoundedRectangle(cornerRadius: 14)
                )
        }
        .disabled(viewModel.isSubmitting)
        .padding(.horizontal)
    }
       

       private var termsNotice: some View {
           Text("By confirming you agree to our Terms of Service. Returns accepted within 30 days of delivery.")
               .font(.caption)
               .foregroundStyle(.secondary)
               .multilineTextAlignment(.center)
               .padding(.horizontal, 32)
       }
}

#Preview {
    NavigationStack {
        OrderSummary(
            product: Product(
                id: 1, title: "TSA Luggage Lock Set (3-Pack)",
                description: nil, category: "security", price: 19.99, rating: 4.5, stock: 42,
                tags: nil, brand: nil, shippingInformation: nil, images: nil,
                thumbnail: "https://cdn.dummyjson.com/product-images/1/thumbnail.png"
            ),
            quantity: 1
        )
    }
}

//
//  FilterSheet.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 01/09/2026.
//

import SwiftUI

struct FilterSheet: View {
    @ObservedObject var viewModel: ProductsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Minimum Rating") {
                    Slider(value: $viewModel.minRating, in: 0...5, step: 0.5)
                    Text("\(viewModel.minRating, specifier: "%.1f") ★ and above")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Filter")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") { viewModel.resetFilters() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    FilterSheet(viewModel: ProductsViewModel())
}

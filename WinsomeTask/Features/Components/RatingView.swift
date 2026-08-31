//
//  RatingView.swift
//  WinsomeTask
//
//  Created by Nafe3's Macbook on 31/08/2026.
//

import SwiftUI

struct RatingView: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: starName(for: index))
                    .foregroundStyle(.yellow)
            }

            Text(String(format: "%.1f", rating))
        }
        .font(.caption)
    }

    private func starName(for index: Int) -> String {
        if rating >= Double(index) {
            return "star.fill"
        } else if rating >= Double(index) - 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

//
//  CalendarTodayButton.swift
//  macmo
//
//  Created by 신동규 on 1/25/26.
//

import SwiftUI

struct CalendarTodayButton: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "calendar")
            Text("Today")
                .fontWeight(.medium)
        }
        .font(.subheadline)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .strokeBorder(.secondary.opacity(0.3), lineWidth: 0.5)
        )
    }
}

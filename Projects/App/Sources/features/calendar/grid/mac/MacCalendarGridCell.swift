//
//  MacCalendarGridCell.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import MacmoDomain
import SwiftUI

struct MacCalendarGridCell: View {
    let data: MacCalendarDayPresentation
    var body: some View {
        Text("MacCalendarGridCell")
    }
}

private struct MacCalendarGridCellPreview: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 1) {
            ForEach(1...28, id: \.self) { day in
                MacCalendarGridCell(data: .init(year: 2026, month: 2, day: day, memos: day % 3 == 0 ? [
                    .init(
                        id: "\(day)",
                        title: "title\(day)",
                        contents: "contents",
                        due: Date(),
                        done: false,
                        eventIdentifier: nil,
                        createdAt: Date(),
                        updatedAt: Date(),
                        images: []
                    )
                ] : []))
            }
        }
        .padding()
        .frame(width: 1000)
    }
}

#Preview {
    MacCalendarGridCellPreview()
        .preferredColorScheme(.dark)
}

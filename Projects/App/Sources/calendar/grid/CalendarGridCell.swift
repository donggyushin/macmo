//
//  CalendarGridCell.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import SwiftUI

struct CalendarGridCell: View {
    let today: Date
    let calendarUtility: CalendarUtility

    @State private var gridCells: [Int?] = []

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]

    init(date: Date, today: Date = Date()) {
        self.today = today
        self.calendarUtility = .init(date: date)
    }

    var body: some View {
        VStack(spacing: 2) {
            // 월 헤더
            Text("\(String(calendarUtility.month))월")
                .font(.system(size: 10, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.bottom, 1)

            // 날짜 그리드
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(Array(gridCells.enumerated()), id: \.offset) { _, cellData in
                    if let day = cellData {
                        Text("\(day)")
                            .font(.system(size: 7))
                            .frame(width: 12, height: 12)
                    } else {
                        Color.clear
                            .frame(width: 12, height: 12)
                    }
                }
            }
        }
        .padding(4)
        .onAppear {
            gridCells = calendarUtility.gridCells
        }
    }
}

private struct CalendarGridCellPreview: View {
    var body: some View {
        CalendarGridCell(date: Date())
            .frame(width: 130)
    }
}

#Preview {
    CalendarGridCellPreview()
        .preferredColorScheme(.dark)
}

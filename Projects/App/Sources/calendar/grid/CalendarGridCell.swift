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
                .font(.system(size: 12, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.bottom, 1)

            // 날짜 그리드
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(Array(gridCells.enumerated()), id: \.offset) { _, cellData in
                    if let day = cellData {
                        ZStack {
                            // 오늘인 경우 원형 배경
                            if isToday(day: day) {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 10, height: 10)
                            }

                            Text("\(day)")
                                .font(.system(size: 10, weight: isToday(day: day) ? .bold : .regular))
                                .foregroundStyle(isToday(day: day) ? .white : .primary)
                        }
                        .frame(width: 14, height: 14)
                    } else {
                        Color.clear
                            .frame(width: 14, height: 14)
                            
                    }
                }
            }
        }
        .padding(4)
        .onAppear {
            gridCells = calendarUtility.gridCells
        }
    }

    private func isToday(day: Int) -> Bool {
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)

        return todayComponents.year == calendarUtility.year &&
               todayComponents.month == calendarUtility.month &&
               todayComponents.day == day
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

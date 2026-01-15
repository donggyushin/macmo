//
//  CalendarGridCell.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import SwiftUI

struct CalendarGridCell: View {
    let today: Date
    @StateObject var calendarUtility: CalendarUtility

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)

    init(calendarUtility: CalendarUtility, today: Date = Date()) {
        self.today = today
        self._calendarUtility = .init(wrappedValue: calendarUtility)
    }

    var body: some View {
        VStack(spacing: 2) {
            // 월 헤더
            HStack {
                Text("\(String(calendarUtility.month))")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.bottom, 1)
                Spacer()
            }

            // 날짜 그리드
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(Array(calendarUtility.gridCells.enumerated()), id: \.offset) { _, cellData in
                    if let day = cellData {
                        ZStack {
                            // 오늘인 경우 원형 배경
                            if isToday(day: day) {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 14, height: 14)
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

            Spacer()
        }
        .padding(4)
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
        CalendarGridCell(calendarUtility: .init(date: Date()))
            .frame(width: 130)
    }
}

#Preview {
    CalendarGridCellPreview()
        .preferredColorScheme(.dark)
}

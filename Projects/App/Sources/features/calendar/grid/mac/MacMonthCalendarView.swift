//
//  MacMonthCalendarView.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import SwiftUI

struct MacMonthCalendarView: View {
    @StateObject var model: MacMonthCalendarViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
    private let weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    var body: some View {
        VStack(spacing: 0) {
            // monthHeader
            weekdayHeader
            calendarGrid
        }
        .onAppear {
            model.drawEmptyCells()
        }
    }

    private var monthHeader: some View {
        HStack {
            Text(verbatim: "\(model.util.year)년 \(model.util.month)월")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(Array(weekdays.enumerated()), id: \.offset) { index, day in
                Text(day)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(weekdayColor(for: index))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
        }
        .background(Color.gray.opacity(0.1))
    }

    private func weekdayColor(for index: Int) -> Color {
        switch index {
        case 0: return .red.opacity(0.8) // 일요일
        case 6: return .blue.opacity(0.8) // 토요일
        default: return .secondary
        }
    }

    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 1) {
            ForEach(model.cells) { cell in
                MacCalendarGridCell(data: cell)
            }
        }
        .background(Color.gray.opacity(0.2))
    }
}

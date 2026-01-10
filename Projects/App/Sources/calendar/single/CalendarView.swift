//
//  CalendarView.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var model: CalendarViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        VStack(spacing: 26) {
            // 년월 헤더
            HStack {
                Text("\(String(model.calendarUtility.year))년 \(String(model.calendarUtility.month))월")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                // 요일 헤더
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(Array(weekdays.enumerated()), id: \.offset) { _, weekday in
                        Text(weekday)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }

                // 날짜 그리드
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(Array(model.gridCells.enumerated()), id: \.offset) { _, cellData in
                        if let day = cellData {
                            // 날짜 셀
                            VStack(spacing: 4) {
                                ZStack {
                                    // 오늘인 경우 원형 배경
                                    if isToday(day: day) {
                                        Circle()
                                            .fill(.blue)
                                            .frame(width: 32, height: 32)
                                    }

                                    Text("\(day)")
                                        .font(.body)
                                        .fontWeight(isToday(day: day) ? .bold : .regular)
                                        .foregroundStyle(isToday(day: day) ? .white : .primary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)

                                // 이벤트 점 표시 (개수에 따라)
                                let count = model.eventCount(on: day)
                                if count > 0 {
                                    HStack(spacing: 2) {
                                        if count <= 3 {
                                            // 점을 개수만큼 표시 (최대 3개)
                                            ForEach(0 ..< count, id: \.self) { _ in
                                                Circle()
                                                    .fill(.blue)
                                                    .frame(width: 4, height: 4)
                                            }
                                        } else {
                                            // 점 2개 + "+숫자" 표시
                                            Circle()
                                                .fill(.blue)
                                                .frame(width: 4, height: 4)
                                            Circle()
                                                .fill(.blue)
                                                .frame(width: 4, height: 4)
                                            Text("+\(count - 2)")
                                                .font(.system(size: 8))
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                    .frame(height: 8)
                                } else {
                                    // 정렬을 위한 투명 공간
                                    Color.clear
                                        .frame(height: 8)
                                }
                            }
                        } else {
                            // 빈 셀
                            Color.clear
                                .frame(height: 40)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            try? model.fetchData()
        }
    }

    private func isToday(day: Int) -> Bool {
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: model.today)

        return todayComponents.year == model.calendarUtility.year &&
            todayComponents.month == model.calendarUtility.month &&
            todayComponents.day == day
    }
}

private struct CalendarViewPreview: View {
    var body: some View {
        CalendarView(model: .init(Date()))
    }
}

#Preview {
    CalendarViewPreview()
        .preferredColorScheme(.dark)
}

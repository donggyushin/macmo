//
//  CalendariOSView.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import SwiftUI

struct CalendariOSView: View {
    @StateObject var model: CalendarViewModel

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        VStack(spacing: 16) {
            // 년월 헤더
            Text("\(String(model.year))년 \(String(model.month))월")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            VStack(spacing: 12) {
                // 요일 헤더
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(weekdays, id: \.self) { weekday in
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
                                Text("\(day)")
                                    .font(.body)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)

                                // 이벤트 점 표시 (데이터 있을 때)
                                if model.hasEvent(on: day) {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 4, height: 4)
                                } else {
                                    // 정렬을 위한 투명한 원
                                    Circle()
                                        .fill(.clear)
                                        .frame(width: 4, height: 4)
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
}

private struct CalendariOSViewPreview: View {
    var body: some View {
        CalendariOSView(model: .init(Date()))
    }
}

#Preview {
    CalendariOSViewPreview()
        .preferredColorScheme(.dark)
}

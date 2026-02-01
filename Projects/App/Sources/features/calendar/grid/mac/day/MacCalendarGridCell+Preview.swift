//
//  MacCalendarGridCell+Preview.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import SwiftUI
import MacmoDomain

private struct MacCalendarGridCellPreview: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)

    private func makeMemos(for day: Int) -> [Memo] {
        let calendar = Calendar.current
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)

        switch day {
        case 1:
            // 오늘: 완료된 메모
            return [
                .init(id: "1", title: "완료된 작업", due: today, done: true, createdAt: today, updatedAt: today)
            ]
        case 3:
            // Urgent 메모 (1시간 후 마감)
            let urgentDue = today.addingTimeInterval(3600)
            return [
                .init(id: "2", title: "긴급 회의", due: urgentDue, done: false, createdAt: today, updatedAt: today)
            ]
        case 5:
            // Overdue 메모 (어제 마감)
            let overdueDue = today.addingTimeInterval(-86400)
            return [
                .init(id: "3", title: "지난 마감", due: overdueDue, done: false, createdAt: today, updatedAt: today)
            ]
        case 10:
            // 여러 메모 (4개 이상 → +n 표시)
            let baseDue = calendar.date(from: DateComponents(year: year, month: month, day: 10, hour: 9))!
            return [
                .init(id: "4", title: "회의 준비", due: baseDue, done: false, createdAt: today, updatedAt: today),
                .init(id: "5", title: "보고서 작성", due: baseDue.addingTimeInterval(3600), done: true, createdAt: today, updatedAt: today),
                .init(id: "6", title: "팀 미팅", due: baseDue.addingTimeInterval(7200), done: false, createdAt: today, updatedAt: today),
                .init(id: "7", title: "코드 리뷰", due: baseDue.addingTimeInterval(10800), done: false, createdAt: today, updatedAt: today),
                .init(id: "8", title: "문서 정리", due: nil, done: false, createdAt: today, updatedAt: today)
            ]
        case 15:
            // 일반 메모
            let futureDue = calendar.date(from: DateComponents(year: year, month: month, day: 15, hour: 14))!
            return [
                .init(id: "9", title: "일반 작업", due: futureDue, done: false, createdAt: today, updatedAt: today),
                .init(id: "10", title: "추가 작업", due: nil, done: false, createdAt: today, updatedAt: today)
            ]
        default:
            return []
        }
    }

    var body: some View {
        let calendar = Calendar.current
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let todayDay = calendar.component(.day, from: today)

        LazyVGrid(columns: columns, spacing: 1) {
            // 이전 달 빈 셀 2개
            ForEach(0..<2, id: \.self) { _ in
                MacCalendarGridCell(data: .init(year: nil, month: nil, day: nil, memos: []))
            }
            // 현재 달 28일
            ForEach(1...28, id: \.self) { day in
                MacCalendarGridCell(data: .init(
                    year: year,
                    month: month,
                    day: day == 1 ? todayDay : day,
                    memos: makeMemos(for: day)
                ))
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


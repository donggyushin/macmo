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

    private let maxVisibleMemos = 3
    private let cellHeight: CGFloat = 120

    private var isToday: Bool {
        guard let year = data.year, let month = data.month, let day = data.day else { return false }
        let calendar = Calendar.current
        let today = Date()
        return calendar.component(.year, from: today) == year
            && calendar.component(.month, from: today) == month
            && calendar.component(.day, from: today) == day
    }

    private var sortedMemos: [Memo] {
        data.memos.sorted { memo1, memo2 in
            switch (memo1.due, memo2.due) {
            case let (due1?, due2?):
                return due1 < due2
            case (nil, _?):
                return false
            case (_?, nil):
                return true
            case (nil, nil):
                return memo1.createdAt < memo2.createdAt
            }
        }
    }

    private var visibleMemos: [Memo] {
        Array(sortedMemos.prefix(maxVisibleMemos))
    }

    private var remainingCount: Int {
        max(0, sortedMemos.count - maxVisibleMemos)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            dayHeader
            if !data.isEmptyCell {
                memoList
            }
            Spacer(minLength: 0)
        }
        .frame(height: cellHeight)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(6)
        .background(cellBackground)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    @ViewBuilder
    private var dayHeader: some View {
        if let day = data.day {
            Text("\(day)")
                .font(.system(size: 14, weight: isToday ? .bold : .regular))
                .foregroundStyle(dayTextColor)
                .frame(width: 24, height: 24)
                .background(isToday ? Color.accentColor : Color.clear)
                .clipShape(Circle())
        }
    }

    private var dayTextColor: Color {
        if data.isEmptyCell {
            return .secondary.opacity(0.3)
        }
        if isToday {
            return .white
        }
        return .primary
    }

    private var cellBackground: Color {
        data.isEmptyCell ? Color.clear : Color.gray.opacity(0.1)
    }

    @ViewBuilder
    private var memoList: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(visibleMemos, id: \.id) { memo in
                MemoRow(memo: memo)
            }
            if remainingCount > 0 {
                Text("+\(remainingCount)")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct MemoRow: View {
    let memo: Memo

    private var backgroundColor: Color {
        if memo.done {
            return .green.opacity(0.2)
        }
        if memo.isOverDue {
            return .red.opacity(0.3)
        }
        if memo.isUrgent {
            return .orange.opacity(0.3)
        }
        return .blue.opacity(0.2)
    }

    private var textColor: Color {
        if memo.done {
            return .secondary
        }
        if memo.isOverDue {
            return .red
        }
        if memo.isUrgent {
            return .orange
        }
        return .primary
    }

    var body: some View {
        HStack(spacing: 4) {
            if memo.done {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(.green)
            } else if memo.isOverDue {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(.red)
            } else if memo.isUrgent {
                Image(systemName: "clock.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(.orange)
            }

            Text(memo.title)
                .font(.system(size: 10))
                .foregroundStyle(textColor)
                .strikethrough(memo.done)
                .lineLimit(1)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}

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

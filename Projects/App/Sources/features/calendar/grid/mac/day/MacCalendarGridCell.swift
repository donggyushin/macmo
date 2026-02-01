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

    @Environment(\.openWindow) private var openWindow
    @State private var showAllMemos = false

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
        .overlay {
            if showAllMemos {
                allMemosOverlay
            }
        }
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

    private var allMemosOverlay: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let day = data.day {
                    Text(verbatim: "\(day)일")
                        .font(.system(size: 14, weight: .bold))
                }
                Spacer()
                Button {
                    showAllMemos = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(sortedMemos.enumerated()), id: \.offset) { _, memo in
                        MemoRow(memo: memo)
                            .onTapGesture {
                                openWindow(id: "memo-detail-with-id", value: memo.id)
                                showAllMemos = false
                            }
                    }
                }
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    @ViewBuilder
    private var memoList: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(Array(visibleMemos.enumerated()), id: \.offset) { _, memo in
                MemoRow(memo: memo)
                    .onTapGesture {
                        openWindow(id: "memo-detail-with-id", value: memo.id)
                    }
            }
            if remainingCount > 0 {
                Text("+\(remainingCount)")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        showAllMemos = true
                    }
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

//
//  MacMonthCalendarListView.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import SwiftUI

struct MacMonthCalendarListView: View {
    @StateObject var model: MacMonthCalendarListViewModel

    private let calendar = Calendar.current

    private var currentViewModel: MacMonthCalendarViewModel {
        model.getViewModel(model.selectedDate)
    }

    private var monthYearText: String {
        let year = calendar.component(.year, from: model.selectedDate)
        let month = calendar.component(.month, from: model.selectedDate)
        return "\(year)년 \(month)월"
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationHeader
            Divider()
            calendarContent
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear {
            initializeDateListIfNeeded()
        }
    }

    private var navigationHeader: some View {
        HStack {
            Button(action: goToPreviousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.leftArrow, modifiers: [])

            Spacer()

            Text(verbatim: monthYearText)
                .font(.title2)
                .fontWeight(.semibold)

            Spacer()

            Button(action: goToNextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.rightArrow, modifiers: [])
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var calendarContent: some View {
        MacMonthCalendarView(model: currentViewModel)
            .id(model.selectedDate)
    }

    private func initializeDateListIfNeeded() {
        if model.dateList.count == 1 {
            model.fetchLeft()
            model.fetchRight()
        }
    }

    private func goToPreviousMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: model.selectedDate) else { return }

        withAnimation(.easeInOut(duration: 0.2)) {
            model.selectedDate = newDate
        }

        // dateList 시작 부근이면 더 가져오기
        if let firstDate = model.dateList.first,
           let monthsDiff = monthsDifference(from: firstDate, to: newDate),
           monthsDiff <= 2 {
            model.fetchLeft()
        }
    }

    private func goToNextMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: 1, to: model.selectedDate) else { return }

        withAnimation(.easeInOut(duration: 0.2)) {
            model.selectedDate = newDate
        }

        // dateList 끝 부근이면 더 가져오기
        if let lastDate = model.dateList.last,
           let monthsDiff = monthsDifference(from: newDate, to: lastDate),
           monthsDiff <= 2 {
            model.fetchRight()
        }
    }

    private func monthsDifference(from startDate: Date, to endDate: Date) -> Int? {
        let components = calendar.dateComponents([.month], from: startDate, to: endDate)
        return components.month.map { abs($0) }
    }
}

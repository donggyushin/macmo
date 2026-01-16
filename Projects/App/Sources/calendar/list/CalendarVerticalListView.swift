//
//  CalendarVerticalListView.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import SwiftUI

struct CalendarVerticalListView: View {
    @StateObject var model: CalendarVerticalListViewModel
    @State private var scrollTarget: Date?
    @State private var scrollAnimation: Bool = false
    @State private var ignoreScrollFetchAction = true

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(model.dates, id: \.self) { date in
                        VStack {
                            if model.getCalendarViewModel(from: date).calendarUtility.month == 1 {
                                Text(String(model.getCalendarViewModel(from: date).calendarUtility.year))
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            CalendarView(model: model.getCalendarViewModel(from: date))
                                .tapDate(model.tapDate)
                                .setSelectedDate(model.selectedDate)
                                .id(date)
                                .onAppear {
                                    Task {
                                        if date == model.dates.first {
                                            guard !ignoreScrollFetchAction else { return }
                                            ignoreScrollFetchAction = true
                                            model.fetchPrevDates(date: date)
                                            try await Task.sleep(for: .seconds(0.2))
                                            scrollTo(date)
                                            try await Task.sleep(for: .seconds(0.3))
                                            ignoreScrollFetchAction = false
                                        } else if date == model.dates.last {
                                            guard !ignoreScrollFetchAction else { return }
                                            ignoreScrollFetchAction = true
                                            model.fetchNextDates(date: date)
                                            try await Task.sleep(for: .seconds(0.3))
                                            ignoreScrollFetchAction = false
                                        }
                                    }
                                }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .onAppear {
                Task {
                    guard model.dates.isEmpty || model.dates.count == 1 else { return }
                    model.fetchNextDates(date: model.dates.last)
                    model.fetchPrevDates(date: model.dates.first)
                    let totalCount = model.dates.count
                    let targetIndex = totalCount / 2
                    let targetDate = model.dates[targetIndex]

                    // 뷰가 완전히 레이아웃된 후 스크롤
                    try await Task.sleep(for: .seconds(0.1))
                    scrollTo(targetDate)

                    try await Task.sleep(for: .seconds(0.3))
                    ignoreScrollFetchAction = false
                }
            }
            .onChange(of: scrollTarget) { _, newTarget in
                if let target = newTarget {
                    if scrollAnimation {
                        withAnimation {
                            proxy.scrollTo(target, anchor: .top)
                        }

                    } else {
                        proxy.scrollTo(target, anchor: .top)
                    }
                    // 스크롤 완료 후 target 리셋 (중복 스크롤 방지)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        scrollTarget = nil
                    }
                }
            }
            .sheet(isPresented: specificDayMemoListViewPresent) {
                specificDayMemoListContainer
            }
        }
    }

    var specificDayMemoListContainer: some View {
        SpecificDayMemoListContainer(
            model: .init(date: model.selectedDate ?? Date()),
            present: specificDayMemoListViewPresent
        )
        .selectedDateChanged { date in
            model.selectedDate = date

            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: date)
            if let targetDate = calendar.date(from: components) {
                scrollTo(targetDate, animated: true)
            }
        }
    }

    var specificDayMemoListViewPresent: Binding<Bool> {
        Binding(
            get: { model.selectedDate != nil },
            set: { newValue, _ in
                if newValue == false {
                    model.selectedDate = nil
                }
            }
        )
    }

    private func scrollTo(_ date: Date, animated: Bool = false) {
        scrollAnimation = animated
        scrollTarget = date
    }
}

#Preview {
    CalendarVerticalListView(model: .init())
        .preferredColorScheme(.dark)
}

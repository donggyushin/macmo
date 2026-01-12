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
                        CalendarView(model: .init(date))
                            .tapDate(model.tapDate)
                            .setSelectedDate(model.selectedDate)
                            .id(date)
                            .onAppear {
                                Task {
                                    if date == model.dates.first {
                                        guard !ignoreScrollFetchAction else { return }
                                        ignoreScrollFetchAction = true
                                        model.fetchPrevDates(date: date)
                                        try await Task.sleep(for: .seconds(0.1))
                                        scrollTo(date)
                                        try await Task.sleep(for: .seconds(0.1))
                                        ignoreScrollFetchAction = false
                                    } else if date == model.dates.last {
                                        guard !ignoreScrollFetchAction else { return }
                                        ignoreScrollFetchAction = true
                                        model.fetchNextDates(date: date)
                                        try await Task.sleep(for: .seconds(0.1))
                                        ignoreScrollFetchAction = false
                                    }
                                }
                            }
                    }
                }
            }
            .onAppear {
                guard model.dates.isEmpty || model.dates.count == 1 else { return }
                model.fetchNextDates(date: model.dates.last)
                model.fetchPrevDates(date: model.dates.first)
                let totalCount = model.dates.count
                let targetIndex = totalCount / 2
                let targetDate = model.dates[targetIndex]
                scrollTo(targetDate)
                try await Task.sleep(for: .seconds(0.1))
                ignoreScrollFetchAction = false
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
                SpecificDayMemoListView(
                    model: .init(date: model.selectedDate ?? Date()),
                    present: specificDayMemoListViewPresent
                )
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

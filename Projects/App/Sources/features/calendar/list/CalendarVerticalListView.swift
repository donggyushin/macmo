//
//  CalendarVerticalListView.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

#if os(iOS)
import SwiftUI

struct CalendarVerticalListView: View {
    @StateObject var model: CalendarVerticalListViewModel
    @State private var scrollTarget: Date?
    @State private var scrollAnimation: Bool = false
    @State private var ignoreScrollFetchAction = true

    @State private var allDotsVisibleHelperTextVisible = false
    @State private var visibleDates: Set<Date> = []

    private var isTodayVisible: Bool {
        let calendar = Calendar.current
        let now = Date()
        let nowComponents = calendar.dateComponents([.year, .month], from: now)

        return visibleDates.contains { date in
            let dateComponents = calendar.dateComponents([.year, .month], from: date)
            return dateComponents.year == nowComponents.year && dateComponents.month == nowComponents.month
        }
    }

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
                                .allCalendarDotsVisible(model.allDotsVisible)
                                .tapDate(model.tapDate)
                                .setSelectedDate(model.selectedDate)
                                .id(date)
                                .onAppear {
                                    visibleDates.insert(date)
                                }
                                .onDisappear {
                                    visibleDates.remove(date)
                                }
                                .task {
                                    if date == model.dates.first {
                                        guard !ignoreScrollFetchAction else { return }
                                        ignoreScrollFetchAction = true
                                        model.fetchPrevDates(date: date)
                                        scrollTo(date)
                                        try? await Task.sleep(for: .seconds(0.2))
                                        scrollTo(date)
                                        try? await Task.sleep(for: .seconds(0.3))
                                        ignoreScrollFetchAction = false
                                    } else if date == model.dates.last {
                                        guard !ignoreScrollFetchAction else { return }
                                        ignoreScrollFetchAction = true
                                        model.fetchNextDates(date: date)
                                        try? await Task.sleep(for: .seconds(0.3))
                                        ignoreScrollFetchAction = false
                                    }
                                }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .task {
                model.configAllDotsVisible()
                guard model.dates.isEmpty || model.dates.count == 1 else { return }
                model.fetchNextDates(date: model.dates.last)
                model.fetchPrevDates(date: model.dates.first)
                let totalCount = model.dates.count
                let targetIndex = totalCount / 2
                let targetDate = model.dates[targetIndex]

                // 뷰가 완전히 레이아웃된 후 스크롤
                scrollTo(targetDate)
                try? await Task.sleep(for: .seconds(0.1))
                scrollTo(targetDate)

                try? await Task.sleep(for: .seconds(0.3))
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
                specificDayMemoListContainer
            }
        }
        .overlay(alignment: .topTrailing) {
            VStack(alignment: .trailing) {
                Toggle("", isOn: $model.allDotsVisible)

                if allDotsVisibleHelperTextVisible {
                    Text(model
                        .allDotsVisible ? "Presents all tasks on the calendar" :
                        "Presents uncompleted tasks on the calendar")
                        .font(.body)
                        .italic()
                        .opacity(0.5)
                        .onAppear {
                            Task {
                                try await Task.sleep(for: .seconds(3))
                                withAnimation {
                                    allDotsVisibleHelperTextVisible = false
                                }
                            }
                        }
                }
            }
            .padding(.trailing)
            .onChange(of: model.allDotsVisible) {
                model.userPreferenceRepository
                    .setCalendarDotVisibleMode(model.allDotsVisible ? .all : .onlyNotCompleted)

                withAnimation {
                    allDotsVisibleHelperTextVisible = true
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if !isTodayVisible {
                Button {
                    goToToday()
                } label: {
                    CalendarTodayButton()
                }
                .buttonStyle(.plain)
                .padding(.trailing, 20)
                .padding(.bottom, 20)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.3), value: isTodayVisible)
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

    private func goToToday(now: Date = Date()) {
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.year, .month], from: now)

        if let targetDate = model.dates.first(where: { date in
            let dateComponents = calendar.dateComponents([.year, .month], from: date)
            return dateComponents.year == nowComponents.year && dateComponents.month == nowComponents.month
        }) {
            scrollTo(targetDate, animated: true)
        }
    }
}

#Preview {
    CalendarVerticalListView(model: .init())
        .preferredColorScheme(.dark)
}
#endif

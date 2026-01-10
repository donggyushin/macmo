//
//  YearCalendarVerticalListView.swift
//  macmo
//
//  Created by 신동규 on 1/10/26.
//

import SwiftUI

struct YearCalendarVerticalListView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject var model: YearCalendarVerticalListViewModel
    @State private var scrollTarget: Date?
    @State private var scrollAnimation: Bool = false

    var tapCalendar: ((Date) -> Void)?
    func tapCalendar(_ action: ((Date) -> Void)?) -> Self {
        var copy = self
        copy.tapCalendar = action
        return copy
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(model.dates, id: \.self) { date in
                        YearCalendarGridView(model: .init(date: date))
                            .tapCalendar(tapCalendar)
                            .id(date)
                    }
                }
            }
            .scrollIndicators(.never)
            .onAppear {
                Task {
                    guard model.dates.isEmpty else { return }
                    model.fetchNextDates(date: model.dates.last)
                    model.fetchPrevDates(date: model.dates.first)
                    let totalCount = model.dates.count
                    let targetIndex = totalCount / 2
                    let targetDate = model.dates[targetIndex]
                    try await Task.sleep(for: .seconds(0.1))
                    scrollTo(targetDate)
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
        }
    }

    private func scrollTo(_ date: Date, animated: Bool = false) {
        scrollAnimation = animated
        scrollTarget = date
    }
}

private struct YearCalendarVerticalListViewPreview: View {
    @StateObject var navigationManager = NavigationManager()
    var body: some View {
        YearCalendarVerticalListView(model: .init())
            .environmentObject(navigationManager)
    }
}

#Preview {
    YearCalendarVerticalListViewPreview()
        .preferredColorScheme(.dark)
}

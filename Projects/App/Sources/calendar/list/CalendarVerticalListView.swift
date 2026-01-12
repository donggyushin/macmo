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

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(model.dates, id: \.self) { date in
                        CalendarView(model: .init(date))
                            .tapDate { date in
                                model.selectedDate = date
                            }
                            .setSelectedDate(model.selectedDate)
                            .id(date)
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

#Preview {
    CalendarVerticalListView(model: .init())
        .preferredColorScheme(.dark)
}

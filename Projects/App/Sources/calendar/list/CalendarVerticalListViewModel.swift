//
//  CalendarVerticalListViewModel.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import Combine
import Foundation

final class CalendarVerticalListViewModel: ObservableObject {
    @Published var dates: [Date] = []

    private let monthsToLoad = 6 // 한 번에 로드할 개월 수

    init(dates: [Date] = []) {
        self.dates = dates
    }

    @MainActor func fetchNextDates(date: Date?) {
        let baseDate = date ?? Date()
        let calendar = Calendar.current

        var newDates: [Date] = []

        // baseDate로부터 1개월, 2개월, 3개월... 미래 날짜 생성
        for i in 1...monthsToLoad {
            if let futureDate = calendar.date(byAdding: .month, value: i, to: baseDate) {
                newDates.append(futureDate)
            }
        }

        // 기존 dates에 추가 (뒤에 append)
        dates.append(contentsOf: newDates)
    }

    @MainActor func fetchPrevDates(date: Date?) {
        let baseDate = date ?? Date()
        let calendar = Calendar.current

        var newDates: [Date] = []

        // baseDate로부터 1개월, 2개월, 3개월... 과거 날짜 생성
        for i in 1...monthsToLoad {
            if let pastDate = calendar.date(byAdding: .month, value: -i, to: baseDate) {
                newDates.append(pastDate)
            }
        }

        // 최근 날짜가 앞에 오도록 역순으로 정렬
        newDates.reverse()

        // 기존 dates의 앞에 추가 (insert)
        dates.insert(contentsOf: newDates, at: 0)
    }
}

//
//  YearCalendarVerticalListViewModel.swift
//  macmo
//
//  Created by 신동규 on 1/10/26.
//

import Combine
import Foundation

final class YearCalendarVerticalListViewModel: ObservableObject {
    @Published var dates: [Date] = []

    private let yearsToLoad = 20 // 한 번에 로드할 연 수

    init(dates: [Date] = []) {
        self.dates = dates
    }

    @MainActor func fetchNextDates(date: Date?) {
        let baseDate = date ?? Date()
        if dates.isEmpty {
            dates = [baseDate]
        }
        let calendar = Calendar.current

        var newDates: [Date] = []

        // baseDate로부터 1년, 2년, 3년... 미래 날짜 생성
        for i in 1 ... yearsToLoad {
            if let futureDate = calendar.date(byAdding: .year, value: i, to: baseDate) {
                newDates.append(futureDate)
            }
        }

        // 기존 dates에 추가 (뒤에 append)
        dates.append(contentsOf: newDates)
    }

    @MainActor func fetchPrevDates(date: Date?) {
        let baseDate = date ?? Date()
        if dates.isEmpty {
            dates = [baseDate]
        }
        let calendar = Calendar.current

        var newDates: [Date] = []

        // baseDate로부터 1년, 2년, 3년... 과거 날짜 생성
        for i in 1 ... yearsToLoad {
            if let pastDate = calendar.date(byAdding: .year, value: -i, to: baseDate) {
                newDates.append(pastDate)
            }
        }

        // 최근 날짜가 앞에 오도록 역순으로 정렬
        newDates.reverse()

        // 기존 dates의 앞에 추가 (insert)
        dates.insert(contentsOf: newDates, at: 0)
    }
}

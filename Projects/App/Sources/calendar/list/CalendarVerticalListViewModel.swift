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

    init(dates: [Date] = []) {
        self.dates = dates
    }

    @MainActor func fetchNextDates(date _: Date?) {
        // date 를 인자로 받으면 해당 date 로부터 1달, 2달, 3달, 4달,..... 미래의 date 들을 구해서 self.dates 에 넣는다. 만약 date 가 nil 이라면 Date()
        // 값으로 한다
    }

    @MainActor func fetchPrevDates(date _: Date?) {
        // fetchNextDates 와 비슷하게 동작하는데 이제 과거의 date 값들을 구하는 함수
    }
}

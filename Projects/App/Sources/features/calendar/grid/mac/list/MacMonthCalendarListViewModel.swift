//
//  MacMonthCalendarListViewModel.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import Combine
import Foundation

final class MacMonthCalendarListViewModel: ObservableObject {
    // 현재 화면을 그리고 있는 date
    @Published var selectedDate: Date
    // 각 달별로 1개씩의 date 를 가짐
    @Published var dateList: [Date] = []

    private var viewModelCache: [String: MacMonthCalendarViewModel] = [:]

    init(date: Date) {
        self.selectedDate = date
        self.dateList = [date]
    }

    // dateList 의 왼쪽에 6개의 date 를 붙인다.
    @MainActor func fetchLeft() {}

    // dateList 의 우측에 6개의 date 를 붙인다.
    @MainActor func fetchRight() {}

    func getViewModel(_ date: Date) -> MacMonthCalendarViewModel {
        let key = cacheKey(for: date)
        if let viewModel = viewModelCache[key] {
            return viewModel
        } else {
            let viewModel = MacMonthCalendarViewModel(date: date)
            viewModelCache[key] = viewModel
            return viewModel
        }
    }

    private func cacheKey(for date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return "\(year)-\(month)"
    }
}

//
//  YearCalendarGridViewModel.swift
//  macmo
//
//  Created by 신동규 on 1/10/26.
//

import Combine
import Foundation

final class YearCalendarGridViewModel: ObservableObject {
    let date: Date
    let today: Date
    var year: Int {
        Calendar.current.component(.year, from: date)
    }

    // 각 달의 첫날을 담은 배열
    private var _monthDates: [Date] = []
    private func setMonthDates() {
        let calendar = Calendar.current
        _monthDates = (1 ... 12).compactMap { month in
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1
            return calendar.date(from: components)
        }
    }

    var monthDates: [Date] {
        if _monthDates.isEmpty {
            setMonthDates()
        }
        return _monthDates
    }

    private var calendarUtilities: [Date: CalendarUtility] = [:]

    init(date: Date, today: Date = Date()) {
        self.date = date
        self.today = today
    }

    func getCalendarUtility(from date: Date) -> CalendarUtility {
        if let cached = calendarUtilities[date] {
            return cached
        } else {
            let util = CalendarUtility(date: date)
            calendarUtilities[date] = util
            return util
        }
    }
}

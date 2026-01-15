//
//  CalendarUtility.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import Foundation

class CalendarUtility: ObservableObject {
    let date: Date
    let year: Int
    let month: Int

    init(date: Date) {
        self.date = date
        let (year, month) = Self.getYearAndMonth(from: date)
        self.year = year
        self.month = month
    }

    /// 해당 월의 총 일수
    var daysInMonth: Int {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        guard let date = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: date)
        else {
            return 0
        }
        return range.count
    }

    /// 해당 월 1일의 요일 (1=일요일, 2=월요일, ..., 7=토요일)
    var firstWeekday: Int {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let firstDay = calendar.date(from: components) else {
            return 1
        }
        return calendar.component(.weekday, from: firstDay)
    }

    /// 그리드에 표시할 셀 데이터 (nil = 빈 셀, Int = 날짜)
    private var _gridCells: [Int?] = []
    private func setGridCells() {
        var cells: [Int?] = []

        // 월의 첫날 이전 빈 셀 추가
        for _ in 1 ..< firstWeekday {
            cells.append(nil)
        }

        // 실제 날짜 셀 추가
        for day in 1 ... daysInMonth {
            cells.append(day)
        }

        _gridCells = cells
    }

    var gridCells: [Int?] {
        if _gridCells.isEmpty {
            setGridCells()
        }

        return _gridCells
    }

    private static func getYearAndMonth(from date: Date) -> (Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        return (year, month)
    }
}

//
//  CalendarViewModel.swift
//  macmo
//
//  Created by ratel on 1/9/26.
//

import Factory
import Foundation
import MacmoDomain

public final class CalendarViewModel: ObservableObject {
    private let date: Date

    @Published var year: Int = 0
    @Published var month: Int = 0
    @Published var calendarDays: [CalendarDay] = []

    @Injected(\.calendarRepository) private var calendarRepository

    public init(_ date: Date) {
        self.date = date
    }

    @MainActor func fetchData() throws {
        let (year, month) = getYearAndMonth(from: date)
        self.year = year
        self.month = month
        calendarDays = try calendarRepository.find(year: year, month: month)
    }

    // MARK: - Calendar Grid Helpers

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
    var gridCells: [Int?] {
        var cells: [Int?] = []

        // 월의 첫날 이전 빈 셀 추가
        for _ in 1 ..< firstWeekday {
            cells.append(nil)
        }

        // 실제 날짜 셀 추가
        for day in 1 ... daysInMonth {
            cells.append(day)
        }

        return cells
    }

    /// 특정 날짜의 이벤트 개수 반환
    func eventCount(on day: Int) -> Int {
        calendarDays.filter { $0.day == day }.count
    }

    private func getYearAndMonth(from date: Date) -> (Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        return (year, month)
    }
}

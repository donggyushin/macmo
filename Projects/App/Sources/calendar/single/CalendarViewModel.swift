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
    let calendarUtility: CalendarUtility
    @Published var calendarDays: [CalendarDay] = []

    @Injected(\.calendarRepository) private var calendarRepository

    public init(_ date: Date) {
        self.calendarUtility = .init(date: date)
    }

    @MainActor func fetchData() throws {
        let year = calendarUtility.year
        let month = calendarUtility.month
        calendarDays = try calendarRepository.find(year: year, month: month)
    }

    /// 특정 날짜의 이벤트 개수 반환
    func eventCount(on day: Int) -> Int {
        calendarDays.filter { $0.day == day }.count
    }
}

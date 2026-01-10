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
    let today: Date

    @Published var calendarDays: [CalendarDay] = []
    @Published var gridCells: [Int?] = []

    @Injected(\.calendarRepository) private var calendarRepository

    public init(_ date: Date, today: Date = Date()) {
        self.calendarUtility = .init(date: date)
        self.today = today
    }

    @MainActor func fetchData() throws {
        gridCells = calendarUtility.gridCells
        let year = calendarUtility.year
        let month = calendarUtility.month
        calendarDays = try calendarRepository.find(year: year, month: month)
    }

    /// 특정 날짜의 이벤트 개수 반환
    func eventCount(on day: Int) -> Int {
        calendarDays.filter { $0.day == day }.count
    }
}

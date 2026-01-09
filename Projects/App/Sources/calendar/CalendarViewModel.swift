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

    private func getYearAndMonth(from date: Date) -> (Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        return (year, month)
    }
}

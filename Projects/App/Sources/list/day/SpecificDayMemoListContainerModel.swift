//
//  SpecificDayMemoListContainerModel.swift
//  macmo
//
//  Created by ratel on 1/12/26.
//

import Combine
import Foundation

final class SpecificDayMemoListContainerModel: ObservableObject {
    let date: Date
    @Published var dates: [Date]
    @Published var selectedDate: Date

    let datesCountPerPage = 8

    init(date: Date) {
        self.date = date

        self.dates = [date]
        self.selectedDate = date
    }

    @MainActor func fetchPrevDates(date: Date) {
        var newDates: [Date] = []
        for i in (1 ... datesCountPerPage).reversed() {
            if let prevDate = Calendar.current.date(byAdding: .day, value: -i, to: date) {
                newDates.append(prevDate)
            }
        }
        dates.insert(contentsOf: newDates, at: 0)
    }

    @MainActor func fetchNextDates(date: Date) {
        var newDates: [Date] = []
        for i in 1 ... datesCountPerPage {
            if let nextDate = Calendar.current.date(byAdding: .day, value: i, to: date) {
                newDates.append(nextDate)
            }
        }
        dates.append(contentsOf: newDates)
    }
}

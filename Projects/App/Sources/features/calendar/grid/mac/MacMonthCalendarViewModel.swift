//
//  MacMonthCalendarViewModel.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import Combine
import Factory
import Foundation
import MacmoDomain

final class MacMonthCalendarViewModel: ObservableObject {
    let util: CalendarUtility

    @Published var cells: [MacCalendarDayPresentation] = []

    @Injected(\.calendarRepository) private var calendarRepository

    init(date: Date) {
        self.util = .init(date: date)
    }

    @MainActor func drawEmptyCells() {
        guard cells.isEmpty else { return }
        let year = util.year
        let month = util.month
        let cells: [MacCalendarDayPresentation] = util.gridCells.map { day in
            if let day {
                return .init(year: year, month: month, day: day, memos: [])
            } else {
                return .init(year: nil, month: nil, day: nil, memos: [])
            }
        }
        self.cells = cells
    }

    @MainActor func fetchDatas() throws {
        let year = util.year
        let month = util.month
        let days = try calendarRepository.find(year: year, month: month)

        var cells = self.cells

        for calendarDay in days {
            if let index = cells.firstIndex(where: { $0.day == calendarDay.day }) {
                var updatedMemos = cells[index].memos
                updatedMemos.append(calendarDay.memo)
                cells[index] = .init(
                    year: year,
                    month: month,
                    day: calendarDay.day,
                    memos: updatedMemos
                )
            }
        }

        self.cells = cells
    }
}

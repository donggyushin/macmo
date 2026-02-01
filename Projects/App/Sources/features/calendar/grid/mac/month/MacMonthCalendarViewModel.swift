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
    @Published var error: Error?

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

    @MainActor func fetchData() {
        let year = util.year
        let month = util.month

        let days: [CalendarDay]
        do {
            days = try calendarRepository.find(year: year, month: month)
        } catch {
            self.error = error
            return
        }

        // O(n) lookup을 위한 dictionary 생성
        var cellIndexByDay: [Int: Int] = [:]
        for (index, cell) in cells.enumerated() {
            if let day = cell.day {
                cellIndexByDay[day] = index
            }
        }

        var cells = self.cells
        cells = cells.map { cell in
            var cell = cell
            cell.memos = []
            return cell
        }

        // 메모 데이터 매핑
        for calendarDay in days {
            if let index = cellIndexByDay[calendarDay.day] {
                cells[index].memos.append(calendarDay.memo)
            }
        }

        self.cells = cells
    }
}

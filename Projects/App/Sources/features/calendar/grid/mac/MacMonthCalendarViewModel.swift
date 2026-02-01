//
//  MacMonthCalendarViewModel.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import Combine
import Foundation
import MacmoDomain

final class MacMonthCalendarViewModel: ObservableObject {
    let util: CalendarUtility

    @Published var cells: [MacCalendarDayPresentation] = []

    init(date: Date) {
        self.util = .init(date: date)
    }

    @MainActor func drawEmptyCells() {
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
}

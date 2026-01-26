//
//  CalendarGridCellModel.swift
//  macmo
//
//  Created by ratel on 1/15/26.
//

import Combine
import Foundation

final class CalendarGridCellModel: ObservableObject {
    let month: Int
    let gridCells: [Int?]

    let date: Date
    let calendarUtility: CalendarUtility

    init(date: Date) {
        self.date = date
        self.calendarUtility = .init(date: date)

        self.month = calendarUtility.month
        self.gridCells = calendarUtility.gridCells
    }
}

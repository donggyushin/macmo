//
//  YearCalendarGridViewModel.swift
//  macmo
//
//  Created by 신동규 on 1/10/26.
//

import Combine
import Foundation

final class YearCalendarGridViewModel: ObservableObject {
    let date: Date
    var year: Int {
        Calendar.current.component(.year, from: date)
    }

    init(date: Date) {
        self.date = date
    }
}

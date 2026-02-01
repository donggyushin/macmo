//
//  MacCalendarDayPresentation.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import Foundation
import MacmoDomain

struct MacCalendarDayPresentation: Identifiable {
    var id: String {
        guard let year, let month, let day else { return UUID().uuidString }
        return "\(year).\(month).\(day)"
    }

    var isEmptyCell: Bool {
        year == nil || month == nil || day == nil
    }

    let year: Int?
    let month: Int?
    let day: Int?
    let memos: [Memo]
}

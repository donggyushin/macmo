//
//  CalendarDay.swift
//  MacmoDomain
//
//  Created by ratel on 1/9/26.
//

import Foundation

public struct CalendarDay: Codable {
    public let year: Int
    public let month: Int
    public let day: Int
    public let memo: Memo

    public init(year: Int, month: Int, day: Int, memo: Memo) {
        self.year = year
        self.month = month
        self.day = day
        self.memo = memo
    }
}

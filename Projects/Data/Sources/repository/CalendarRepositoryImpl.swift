//
//  CalendarRepositoryImpl.swift
//  MacmoData
//
//  Created by ratel on 1/9/26.
//

import Foundation
import MacmoDomain

public final class CalendarRepositoryImpl: CalendarRepository {
    private let dao: CalendarDAO

    public init(dao: CalendarDAO) {
        self.dao = dao
    }

    public func find(year: Int, month: Int) throws -> [CalendarDay] {
        try dao.find(year: year, month: month)
    }
}

//
//  CalendarDAO.swift
//  MacmoData
//
//  Created by ratel on 1/9/26.
//

import Foundation
import MacmoDomain

public protocol CalendarDAO {
    func find(year: Int, month: Int) throws -> [CalendarDay]
}

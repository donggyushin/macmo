//
//  CalendarRepository.swift
//  MacmoDomain
//
//  Created by ratel on 1/9/26.
//

import Foundation

public protocol CalendarRepository {
    func find(year: Int, month: Int) throws -> [CalendarDay]
}

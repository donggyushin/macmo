//
//  Navigation.swift
//  macmo
//
//  Created by 신동규 on 10/3/25.
//

import Foundation
import MacmoDomain

enum Navigation: Hashable {
    case list
    case detail(String?)
    case setting
    case search
    case calendarVerticalList(Date?)

    init(_ domain: NavigationDomain) {
        switch domain {
        case let .detail(id):
            self = .detail(id)
        case .setting:
            self = .setting
        case .search:
            self = .search
        case .list:
            self = .list
        case let .calendarVerticalList(date):
            self = .calendarVerticalList(date)
        }
    }

    var domain: NavigationDomain {
        switch self {
        case .list:
            .list
        case let .detail(id):
            .detail(id)
        case .setting:
            .setting
        case .search:
            .search
        case let .calendarVerticalList(date):
            .calendarVerticalList(date)
        }
    }
}

//
//  Navigation.swift
//  macmo
//
//  Created by 신동규 on 10/3/25.
//

import Foundation

enum Navigation: Hashable {
    case detail(String?)
    case setting
    case search

    init(_ domain: NavigationDomain) {
        switch domain {
        case let .detail(id):
            self = .detail(id)
        case .setting:
            self = .setting
        case .search:
            self = .search
        }
    }
}

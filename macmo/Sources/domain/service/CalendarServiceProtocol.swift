//
//  CalendarServiceProtocol.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation

public protocol CalendarServiceProtocol {
    var isSyncCalendar: Bool { get set }
    
    /// Request calendar access permission
    func requestAccess() async throws -> Bool

    /// Save a memo to the calendar as an event
    /// - Parameter memo: The memo to save
    /// - Returns: The event identifier if successful
    func saveToCalendar(memo: Memo) async throws -> String?

    /// Remove an event from the calendar
    /// - Parameter eventIdentifier: The event identifier to remove
    func removeFromCalendar(eventIdentifier: String) async throws
}

//
//  MockCalendarService.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation

final class MockCalendarService: CalendarServiceProtocol {
    
    @UserDefault(key: "isCalendarSyncEnabled", defaultValue: true) var isCalendarSyncEnabled
    
    func requestAccess() async throws -> Bool {
        true
    }
    
    func saveToCalendar(memo: Memo) async throws -> String? {
        nil
    }
    
    func removeFromCalendar(eventIdentifier: String) async throws {
        
    }
}

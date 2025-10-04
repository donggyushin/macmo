//
//  MockCalendarService.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation

final class MockCalendarService: CalendarServiceProtocol {

    @UserDefault(key: "isCalendarSyncEnabled", defaultValue: true) var isCalendarSyncEnabled

    // MARK: - Test Tracking Properties
    var requestAccessCallCount = 0
    var saveToCalendarCallCount = 0
    var removeFromCalendarCallCount = 0

    var lastSavedMemo: Memo?
    var lastRemovedEventIdentifier: String?

    // MARK: - Stub Return Values
    var stubAccessResult: Bool = true
    var stubEventIdentifier: String? = "mock-event-id"
    var shouldThrowError: CalendarServiceError?

    // MARK: - Protocol Implementation
    func requestAccess() async throws -> Bool {
        requestAccessCallCount += 1

        if let error = shouldThrowError {
            throw error
        }

        return stubAccessResult
    }

    func saveToCalendar(memo: Memo) async throws -> String? {
        saveToCalendarCallCount += 1
        lastSavedMemo = memo

        if let error = shouldThrowError {
            throw error
        }

        return stubEventIdentifier
    }

    func removeFromCalendar(eventIdentifier: String) async throws {
        removeFromCalendarCallCount += 1
        lastRemovedEventIdentifier = eventIdentifier

        if let error = shouldThrowError {
            throw error
        }
    }

    // MARK: - Test Helpers
    func reset() {
        requestAccessCallCount = 0
        saveToCalendarCallCount = 0
        removeFromCalendarCallCount = 0
        lastSavedMemo = nil
        lastRemovedEventIdentifier = nil
        stubAccessResult = true
        stubEventIdentifier = "mock-event-id"
        shouldThrowError = nil
    }
}

//
//  CalendarServiceMock.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation
import MacmoDomain

public final class CalendarServiceMock: CalendarService {
    @UserDefault(key: "isCalendarSyncEnabled", defaultValue: true) public var isCalendarSyncEnabled

    public init() {}

    // MARK: - Test Tracking Properties

    public var requestAccessCallCount = 0
    public var saveToCalendarCallCount = 0
    public var removeFromCalendarCallCount = 0

    public var lastSavedMemo: Memo?
    public var lastRemovedEventIdentifier: String?

    // MARK: - Stub Return Values

    public var stubAccessResult: Bool = true
    public var stubEventIdentifier: String? = "mock-event-id"
    public var shouldThrowError: CalendarServiceError?

    // MARK: - Protocol Implementation

    public func requestAccess() async throws -> Bool {
        requestAccessCallCount += 1

        if let error = shouldThrowError {
            throw error
        }

        return stubAccessResult
    }

    public func saveToCalendar(memo: Memo) async throws -> String? {
        saveToCalendarCallCount += 1
        lastSavedMemo = memo

        if let error = shouldThrowError {
            throw error
        }

        return stubEventIdentifier
    }

    public func removeFromCalendar(eventIdentifier: String) async throws {
        removeFromCalendarCallCount += 1
        lastRemovedEventIdentifier = eventIdentifier

        if let error = shouldThrowError {
            throw error
        }
    }

    // MARK: - Test Helpers

    public func reset() {
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

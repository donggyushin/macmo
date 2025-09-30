//
//  CalendarService.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation
import EventKit

final class CalendarService: CalendarServiceProtocol {
    private let eventStore = EKEventStore()
    
    @UserDefault(key: "isCalendarSyncEnabled", defaultValue: true) var isCalendarSyncEnabled
    
    func requestAccess() async throws -> Bool {
        return try await eventStore.requestFullAccessToEvents()
    }

    func saveToCalendar(memo: Memo) async throws -> String? {
        // Ensure we have calendar access
        let hasAccess = try await requestAccess()
        guard hasAccess else {
            throw CalendarServiceError.accessDenied
        }

        // Memo must have a due date to create a calendar event
        guard let dueDate = memo.due else {
            throw CalendarServiceError.noDueDate
        }

        // Create the event
        let event = EKEvent(eventStore: eventStore)
        event.title = memo.title.isEmpty ? "Memo" : memo.title
        event.notes = memo.contents
        event.startDate = dueDate
        event.endDate = dueDate.addingTimeInterval(3600) // 1 hour duration
        event.calendar = eventStore.defaultCalendarForNewEvents

        // Save the event
        do {
            try eventStore.save(event, span: .thisEvent)
            return event.eventIdentifier
        } catch {
            throw CalendarServiceError.eventCreationFailed
        }
    }

    func removeFromCalendar(eventIdentifier: String) async throws {
        // Ensure we have calendar access
        let hasAccess = try await requestAccess()
        guard hasAccess else {
            throw CalendarServiceError.accessDenied
        }

        // Find the event
        guard let event = eventStore.event(withIdentifier: eventIdentifier) else {
            throw CalendarServiceError.eventNotFound
        }

        // Remove the event
        try eventStore.remove(event, span: .thisEvent)
    }
}

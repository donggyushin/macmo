//
import MacmoDomain
import MacmoData
//  MemoUseCaseTests.swift
//  macmo
//
//  Created by Claude on 10/4/25.
//

import Factory
import Foundation
import Testing
@testable import macmo

struct MemoUseCaseTests {
    // MARK: - Save Tests

    @Test("Save with due date calls calendar service")
    func saveWithDueDateCallsCalendarService() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        mockCalendarService?.reset()

        let memo = Memo(
            id: UUID().uuidString,
            title: "Test Memo",
            contents: "Test Content",
            due: Date().addingTimeInterval(3600),
            done: false
        )

        try await useCase.save(memo)

        #expect(mockCalendarService?.saveToCalendarCallCount == 1)
        #expect(mockCalendarService?.lastSavedMemo?.id == memo.id)

        // Cleanup
        Container.shared.reset()
    }

    @Test("Save without due date does not call calendar service")
    func saveWithoutDueDateDoesNotCallCalendarService() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        mockCalendarService?.reset()

        let memo = Memo(
            id: UUID().uuidString,
            title: "Test Memo",
            contents: "Test Content",
            due: nil,
            done: false
        )

        try await useCase.save(memo)

        #expect(mockCalendarService?.saveToCalendarCallCount == 0)

        // Cleanup
        Container.shared.reset()
    }

    @Test("Save with due date saves event identifier to memo")
    func saveWithDueDateSavesEventIdentifierToMemo() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        let mockRepository = Container.shared.memoRepository()
        mockCalendarService?.reset()

        let memo = Memo(
            id: UUID().uuidString,
            title: "Test Memo",
            contents: "Test Content",
            due: Date().addingTimeInterval(3600),
            done: false
        )
        mockCalendarService?.stubEventIdentifier = "custom-event-id"

        try await useCase.save(memo)

        let savedMemo = try mockRepository.findById(memo.id)
        #expect(savedMemo?.eventIdentifier == "custom-event-id")

        // Cleanup
        Container.shared.reset()
    }

    @Test("Save when calendar service fails still saves memo")
    func saveWhenCalendarServiceFailsStillSavesMemo() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        let mockRepository = Container.shared.memoRepository()
        mockCalendarService?.reset()

        let memo = Memo(
            id: UUID().uuidString,
            title: "Test Memo",
            contents: "Test Content",
            due: Date().addingTimeInterval(3600),
            done: false
        )
        mockCalendarService?.shouldThrowError = .accessDenied

        try await useCase.save(memo)

        let savedMemo = try mockRepository.findById(memo.id)
        #expect(savedMemo != nil)
        #expect(savedMemo?.eventIdentifier == nil)

        // Cleanup
        Container.shared.reset()
    }

    // MARK: - Update Tests

    @Test("Update removes old calendar event and creates new")
    func updateRemovesOldCalendarEventAndCreatesNew() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        let mockRepository = Container.shared.memoRepository()
        mockCalendarService?.reset()

        let originalMemo = Memo(
            id: UUID().uuidString,
            title: "Original Memo",
            contents: "Original Content",
            due: Date().addingTimeInterval(3600),
            done: false,
            eventIdentifier: "old-event-id"
        )
        try mockRepository.save(originalMemo)

        var updatedMemo = originalMemo
        updatedMemo.title = "Updated Memo"
        updatedMemo.due = Date().addingTimeInterval(7200)
        mockCalendarService?.stubEventIdentifier = "new-event-id"

        try await useCase.update(updatedMemo)

        #expect(mockCalendarService?.removeFromCalendarCallCount == 1)
        #expect(mockCalendarService?.lastRemovedEventIdentifier == "old-event-id")
        #expect(mockCalendarService?.saveToCalendarCallCount == 1)

        let savedMemo = try mockRepository.findById(originalMemo.id)
        #expect(savedMemo?.eventIdentifier == "new-event-id")

        // Cleanup
        Container.shared.reset()
    }

    @Test("Update removes calendar event when due date is removed")
    func updateRemovesCalendarEventWhenDueDateIsRemoved() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        let mockRepository = Container.shared.memoRepository()
        mockCalendarService?.reset()

        let originalMemo = Memo(
            id: UUID().uuidString,
            title: "Original Memo",
            contents: "Original Content",
            due: Date().addingTimeInterval(3600),
            done: false,
            eventIdentifier: "event-to-remove"
        )
        try mockRepository.save(originalMemo)

        var updatedMemo = originalMemo
        updatedMemo.due = nil

        try await useCase.update(updatedMemo)

        #expect(mockCalendarService?.removeFromCalendarCallCount == 1)
        #expect(mockCalendarService?.lastRemovedEventIdentifier == "event-to-remove")
        #expect(mockCalendarService?.saveToCalendarCallCount == 0)

        let savedMemo = try mockRepository.findById(originalMemo.id)
        #expect(savedMemo?.eventIdentifier == nil)

        // Cleanup
        Container.shared.reset()
    }

    @Test("Update without previous event creates new event")
    func updateWithoutPreviousEventCreatesNewEvent() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        let mockRepository = Container.shared.memoRepository()
        mockCalendarService?.reset()

        let originalMemo = Memo(
            id: UUID().uuidString,
            title: "Original Memo",
            contents: "Original Content",
            due: nil,
            done: false
        )
        try mockRepository.save(originalMemo)

        var updatedMemo = originalMemo
        updatedMemo.due = Date().addingTimeInterval(3600)
        mockCalendarService?.stubEventIdentifier = "new-event-id"

        try await useCase.update(updatedMemo)

        #expect(mockCalendarService?.removeFromCalendarCallCount == 0)
        #expect(mockCalendarService?.saveToCalendarCallCount == 1)

        let savedMemo = try mockRepository.findById(originalMemo.id)
        #expect(savedMemo?.eventIdentifier == "new-event-id")

        // Cleanup
        Container.shared.reset()
    }

    // MARK: - Delete Tests

    @Test("Delete removes calendar event if exists")
    func deleteRemovesCalendarEventIfExists() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        let mockRepository = Container.shared.memoRepository()
        mockCalendarService?.reset()

        let memo = Memo(
            id: UUID().uuidString,
            title: "To Delete",
            contents: "Content",
            due: Date().addingTimeInterval(3600),
            done: false,
            eventIdentifier: "event-to-delete"
        )
        try mockRepository.save(memo)

        try await useCase.delete(memo.id)

        #expect(mockCalendarService?.removeFromCalendarCallCount == 1)
        #expect(mockCalendarService?.lastRemovedEventIdentifier == "event-to-delete")

        let deletedMemo = try mockRepository.findById(memo.id)
        #expect(deletedMemo == nil)

        // Cleanup
        Container.shared.reset()
    }

    @Test("Delete without calendar event still deletes memo")
    func deleteWithoutCalendarEventStillDeletesMemo() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        let mockRepository = Container.shared.memoRepository()
        mockCalendarService?.reset()

        let memo = Memo(
            id: UUID().uuidString,
            title: "To Delete",
            contents: "Content",
            due: nil,
            done: false
        )
        try mockRepository.save(memo)

        try await useCase.delete(memo.id)

        #expect(mockCalendarService?.removeFromCalendarCallCount == 0)

        let deletedMemo = try mockRepository.findById(memo.id)
        #expect(deletedMemo == nil)

        // Cleanup
        Container.shared.reset()
    }

    @Test("Delete when calendar service fails still deletes memo")
    func deleteWhenCalendarServiceFailsStillDeletesMemo() async throws {
        // Setup
        Container.shared.reset()
        let useCase = Container.shared.memoUseCase()
        let mockCalendarService = Container.shared.calendarService() as? CalendarServiceMock
        let mockRepository = Container.shared.memoRepository()
        mockCalendarService?.reset()

        let memo = Memo(
            id: UUID().uuidString,
            title: "To Delete",
            contents: "Content",
            due: Date().addingTimeInterval(3600),
            done: false,
            eventIdentifier: "event-id"
        )
        try mockRepository.save(memo)
        mockCalendarService?.shouldThrowError = .eventNotFound

        try await useCase.delete(memo.id)

        let deletedMemo = try mockRepository.findById(memo.id)
        #expect(deletedMemo == nil)

        // Cleanup
        Container.shared.reset()
    }
}

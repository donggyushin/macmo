//
//  MemoUseCaseTests.swift
//  macmo
//
//  Created by Claude on 10/4/25.
//

import XCTest
import Factory
@testable import macmo

final class MemoUseCaseTests: XCTestCase {

    var useCase: MemoUseCase!
    var mockCalendarService: MockCalendarService!
    var mockRepository: MemoRepositoryProtocol!

    override func setUp() {
        super.setUp()

        // Factory가 자동으로 .onTest로 Mock을 주입해줌
        Container.shared.reset()
        useCase = Container.shared.memoUseCase()

        // Mock 서비스 직접 참조 (호출 추적용)
        mockCalendarService = Container.shared.calendarService() as? MockCalendarService
        mockRepository = Container.shared.memoRepository()

        // Mock 상태 초기화
        mockCalendarService?.reset()
    }

    override func tearDown() {
        useCase = nil
        mockCalendarService = nil
        mockRepository = nil
        Container.shared.reset()
        super.tearDown()
    }

    // MARK: - Save Tests

    func testSave_withDueDate_callsCalendarService() async throws {
        // Given
        let memo = Memo(
            id: UUID().uuidString,
            title: "Test Memo",
            contents: "Test Content",
            due: Date().addingTimeInterval(3600),
            done: false
        )

        // When
        try await useCase.save(memo)

        // Then
        XCTAssertEqual(mockCalendarService.saveToCalendarCallCount, 1, "saveToCalendar should be called once")
        XCTAssertEqual(mockCalendarService.lastSavedMemo?.id, memo.id, "Saved memo should match")
    }

    func testSave_withoutDueDate_doesNotCallCalendarService() async throws {
        // Given
        let memo = Memo(
            id: UUID().uuidString,
            title: "Test Memo",
            contents: "Test Content",
            due: nil,
            done: false
        )

        // When
        try await useCase.save(memo)

        // Then
        XCTAssertEqual(mockCalendarService.saveToCalendarCallCount, 0, "saveToCalendar should NOT be called")
    }

    func testSave_withDueDate_savesEventIdentifierToMemo() async throws {
        // Given
        let memo = Memo(
            id: UUID().uuidString,
            title: "Test Memo",
            contents: "Test Content",
            due: Date().addingTimeInterval(3600),
            done: false
        )
        mockCalendarService.stubEventIdentifier = "custom-event-id"

        // When
        try await useCase.save(memo)

        // Then
        let savedMemo = try mockRepository.findById(memo.id)
        XCTAssertEqual(savedMemo?.eventIdentifier, "custom-event-id", "Event identifier should be saved to memo")
    }

    func testSave_whenCalendarServiceFails_stillSavesMemo() async throws {
        // Given
        let memo = Memo(
            id: UUID().uuidString,
            title: "Test Memo",
            contents: "Test Content",
            due: Date().addingTimeInterval(3600),
            done: false
        )
        mockCalendarService.shouldThrowError = .accessDenied

        // When
        try await useCase.save(memo)

        // Then
        let savedMemo = try mockRepository.findById(memo.id)
        XCTAssertNotNil(savedMemo, "Memo should still be saved even if calendar sync fails")
        XCTAssertNil(savedMemo?.eventIdentifier, "Event identifier should be nil when calendar sync fails")
    }

    // MARK: - Update Tests

    func testUpdate_removesOldCalendarEventAndCreatesNew() async throws {
        // Given: 기존에 저장된 메모 (calendar event 있음)
        let originalMemo = Memo(
            id: UUID().uuidString,
            title: "Original Memo",
            contents: "Original Content",
            due: Date().addingTimeInterval(3600),
            done: false,
            eventIdentifier: "old-event-id"
        )
        try mockRepository.save(originalMemo)

        // When: due date를 변경하여 업데이트
        var updatedMemo = originalMemo
        updatedMemo.title = "Updated Memo"
        updatedMemo.due = Date().addingTimeInterval(7200)
        mockCalendarService.stubEventIdentifier = "new-event-id"

        try await useCase.update(updatedMemo)

        // Then
        XCTAssertEqual(mockCalendarService.removeFromCalendarCallCount, 1, "Old event should be removed")
        XCTAssertEqual(mockCalendarService.lastRemovedEventIdentifier, "old-event-id")
        XCTAssertEqual(mockCalendarService.saveToCalendarCallCount, 1, "New event should be created")

        let savedMemo = try mockRepository.findById(originalMemo.id)
        XCTAssertEqual(savedMemo?.eventIdentifier, "new-event-id", "New event identifier should be saved")
    }

    func testUpdate_removesCalendarEventWhenDueDateIsRemoved() async throws {
        // Given: 기존에 due date와 event identifier가 있는 메모
        let originalMemo = Memo(
            id: UUID().uuidString,
            title: "Original Memo",
            contents: "Original Content",
            due: Date().addingTimeInterval(3600),
            done: false,
            eventIdentifier: "event-to-remove"
        )
        try mockRepository.save(originalMemo)

        // When: due date를 제거하여 업데이트
        var updatedMemo = originalMemo
        updatedMemo.due = nil

        try await useCase.update(updatedMemo)

        // Then
        XCTAssertEqual(mockCalendarService.removeFromCalendarCallCount, 1, "Event should be removed")
        XCTAssertEqual(mockCalendarService.lastRemovedEventIdentifier, "event-to-remove")
        XCTAssertEqual(mockCalendarService.saveToCalendarCallCount, 0, "No new event should be created")

        let savedMemo = try mockRepository.findById(originalMemo.id)
        XCTAssertNil(savedMemo?.eventIdentifier, "Event identifier should be nil")
    }

    func testUpdate_withoutPreviousEvent_createsNewEvent() async throws {
        // Given: event identifier가 없는 메모
        let originalMemo = Memo(
            id: UUID().uuidString,
            title: "Original Memo",
            contents: "Original Content",
            due: nil,
            done: false
        )
        try mockRepository.save(originalMemo)

        // When: due date를 추가하여 업데이트
        var updatedMemo = originalMemo
        updatedMemo.due = Date().addingTimeInterval(3600)
        mockCalendarService.stubEventIdentifier = "new-event-id"

        try await useCase.update(updatedMemo)

        // Then
        XCTAssertEqual(mockCalendarService.removeFromCalendarCallCount, 0, "No event to remove")
        XCTAssertEqual(mockCalendarService.saveToCalendarCallCount, 1, "New event should be created")

        let savedMemo = try mockRepository.findById(originalMemo.id)
        XCTAssertEqual(savedMemo?.eventIdentifier, "new-event-id")
    }

    // MARK: - Delete Tests

    func testDelete_removesCalendarEventIfExists() async throws {
        // Given: event identifier가 있는 메모
        let memo = Memo(
            id: UUID().uuidString,
            title: "To Delete",
            contents: "Content",
            due: Date().addingTimeInterval(3600),
            done: false,
            eventIdentifier: "event-to-delete"
        )
        try mockRepository.save(memo)

        // When
        try await useCase.delete(memo.id)

        // Then
        XCTAssertEqual(mockCalendarService.removeFromCalendarCallCount, 1, "Event should be removed")
        XCTAssertEqual(mockCalendarService.lastRemovedEventIdentifier, "event-to-delete")

        // Verify memo is deleted
        let deletedMemo = try mockRepository.findById(memo.id)
        XCTAssertNil(deletedMemo, "Memo should be deleted")
    }

    func testDelete_withoutCalendarEvent_stillDeletesMemo() async throws {
        // Given: event identifier가 없는 메모
        let memo = Memo(
            id: UUID().uuidString,
            title: "To Delete",
            contents: "Content",
            due: nil,
            done: false
        )
        try mockRepository.save(memo)

        // When
        try await useCase.delete(memo.id)

        // Then
        XCTAssertEqual(mockCalendarService.removeFromCalendarCallCount, 0, "No event to remove")

        // Verify memo is deleted
        let deletedMemo = try mockRepository.findById(memo.id)
        XCTAssertNil(deletedMemo, "Memo should be deleted")
    }

    func testDelete_whenCalendarServiceFails_stillDeletesMemo() async throws {
        // Given
        let memo = Memo(
            id: UUID().uuidString,
            title: "To Delete",
            contents: "Content",
            due: Date().addingTimeInterval(3600),
            done: false,
            eventIdentifier: "event-id"
        )
        try mockRepository.save(memo)
        mockCalendarService.shouldThrowError = .eventNotFound

        // When
        try await useCase.delete(memo.id)

        // Then: Calendar 실패해도 메모는 삭제되어야 함
        let deletedMemo = try mockRepository.findById(memo.id)
        XCTAssertNil(deletedMemo, "Memo should still be deleted even if calendar fails")
    }
}

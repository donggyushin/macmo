//
//  MemoUseCase.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation
import WidgetKit

public final class MemoUseCase {
    let memoRepository: MemoRepository
    let calendarService: CalendarService
    let pushNotificationService: PushNotificationService

    public init(
        memoRepository: MemoRepository,
        calendarService: CalendarService,
        pushNotificationService: PushNotificationService
    ) {
        self.memoRepository = memoRepository
        self.calendarService = calendarService
        self.pushNotificationService = pushNotificationService
    }

    public func save(_ memo: Memo, now: Date = Date()) async throws {
        var memo = memo
        // Only save to calendar if memo has a due date and not completed
        if memo.due != nil, !memo.done {
            if let identifier = try? await calendarService.saveToCalendar(memo: memo) {
                memo.eventIdentifier = identifier
            }
        }

        try? await registerLocalPushNotificationIfNeeded(memo: memo, now: now)

        try memoRepository.save(memo)
        WidgetCenter.shared.reloadAllTimelines()
    }

    public func update(_ memo: Memo) async throws {
        let oldMemo = try? memoRepository.findById(memo.id)
        var memo = memo

        // Remove old calendar event if it exists
        if let oldIdentifier = oldMemo?.eventIdentifier {
            try? await calendarService.removeFromCalendar(eventIdentifier: oldIdentifier)
            memo.eventIdentifier = nil
        }

        // Create new calendar event only if memo has due date and not completed
        if memo.due != nil, !memo.done {
            if let identifier = try? await calendarService.saveToCalendar(memo: memo) {
                memo.eventIdentifier = identifier
            }
        }

        try memoRepository.update(memo)
        WidgetCenter.shared.reloadAllTimelines()
    }

    public func delete(_ id: String) async throws {
        if let memo = try? memoRepository.findById(id), let identifier = memo.eventIdentifier {
            try? await calendarService.removeFromCalendar(eventIdentifier: identifier)
        }

        try memoRepository.delete(id)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func registerLocalPushNotificationIfNeeded(memo: Memo, now _: Date) async throws {
        let pushAuthorizedStatus = try await pushNotificationService.requestAuthorization()
        try await pushNotificationService.removeNotification(identifier: memo.id)
        if pushAuthorizedStatus {
            guard let due = memo.due else { return }
            _ = try await pushNotificationService.scheduleNotification(
                identifier: memo.id,
                title: memo.title,
                body: memo.contents ?? "",
                subtitle: nil,
                dueDate: due
            )
        }
    }
}

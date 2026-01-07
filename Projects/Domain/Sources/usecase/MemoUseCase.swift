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
        let memo = try await registerCalendarIfNeeded(memo: memo, oldMemo: nil)
        try? await registerLocalPushNotificationIfNeeded(memo: memo, now: now)

        try memoRepository.save(memo)
        WidgetCenter.shared.reloadAllTimelines()
    }

    public func update(_ memo: Memo, now: Date = Date()) async throws {
        let oldMemo = try? memoRepository.findById(memo.id)
        let memo = try await registerCalendarIfNeeded(memo: memo, oldMemo: oldMemo)
        try? await registerLocalPushNotificationIfNeeded(memo: memo, now: now)
        try memoRepository.update(memo)
        WidgetCenter.shared.reloadAllTimelines()
    }

    public func delete(_ id: String) async throws {
        if let memo = try? memoRepository.findById(id), let identifier = memo.eventIdentifier {
            try? await calendarService.removeFromCalendar(eventIdentifier: identifier)
        }

        try? await pushNotificationService.removeNotification(identifier: id)

        try memoRepository.delete(id)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func registerLocalPushNotificationIfNeeded(
        memo: Memo,
        now: Date,
        userInfo: [AnyHashable: Any] = [:]
    ) async throws {
        let pushAuthorizedStatus = try await pushNotificationService.requestAuthorization()
        if pushAuthorizedStatus {
            try await pushNotificationService.removeNotification(identifier: memo.id)
            guard let due = memo.due else { return }

            // due가 now보다 2시간 이상 이후인지 확인
            guard due.timeIntervalSince(now) >= 7200 else { return } // 7200 seconds = 2 hours

            // 알림은 due보다 2시간 전에 발생
            let notificationDate = due.addingTimeInterval(-7200)

            _ = try await pushNotificationService.scheduleNotification(
                identifier: memo.id,
                title: memo.title,
                body: memo.contents ?? "",
                subtitle: nil,
                dueDate: notificationDate,
                userInfo: userInfo
            )
        }
    }

    private func registerCalendarIfNeeded(memo: Memo, oldMemo: Memo?) async throws -> Memo {
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

        return memo
    }
}

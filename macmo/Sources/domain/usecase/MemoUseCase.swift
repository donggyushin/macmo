//
//  MemoUseCase.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation

public final class MemoUseCase {
    let memoRepository: MemoRepository
    let calendarService: CalendarServiceProtocol

    public init(memoRepository: MemoRepository, calendarService: CalendarServiceProtocol) {
        self.memoRepository = memoRepository
        self.calendarService = calendarService
    }

    public func save(_ memo: Memo) async throws {
        var memo = memo
        // Only save to calendar if memo has a due date
        if memo.due != nil {
            if let identifier = try? await calendarService.saveToCalendar(memo: memo) {
                memo.eventIdentifier = identifier
            }
        }

        try memoRepository.save(memo)
    }

    public func update(_ memo: Memo) async throws {
        let oldMemo = try? memoRepository.findById(memo.id)
        var memo = memo

        // Remove old calendar event if it exists
        if let oldIdentifier = oldMemo?.eventIdentifier {
            try? await calendarService.removeFromCalendar(eventIdentifier: oldIdentifier)
            memo.eventIdentifier = nil
        }

        // Create new calendar event only if memo has due date
        if memo.due != nil {
            if let identifier = try? await calendarService.saveToCalendar(memo: memo) {
                memo.eventIdentifier = identifier
            }
        }

        try memoRepository.update(memo)
    }

    public func delete(_ id: String) async throws {
        if let memo = try? memoRepository.findById(id), let identifier = memo.eventIdentifier {
            try? await calendarService.removeFromCalendar(eventIdentifier: identifier)
        }
        try memoRepository.delete(id)
    }
}

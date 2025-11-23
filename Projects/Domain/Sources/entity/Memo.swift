//
//  Memo.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation

public struct Memo: Equatable {
    public let id: String
    public var title: String
    public var contents: String?
    public var due: Date?
    public var done: Bool
    public var eventIdentifier: String?
    public let createdAt: Date
    public let updatedAt: Date

    public var images: [ImageAttachment] = []

    public var isUrgent: Bool {
        // Consider urgent if due within 3 days (259200 seconds) and not completed
        guard let due = due, !done else { return false }
        return due.timeIntervalSinceNow <= 259_200
    }

    public var isOverDue: Bool {
        guard let due else { return false }
        return due < Date()
    }

    public init(
        id: String = UUID().uuidString,
        title: String,
        contents: String? = nil,
        due: Date? = nil,
        done: Bool = false,
        eventIdentifier: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        images: [ImageAttachment] = []
    ) {
        self.id = id
        self.title = title
        self.contents = contents
        self.due = due
        self.done = done
        self.eventIdentifier = eventIdentifier
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.images = images
    }
}

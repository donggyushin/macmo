//
//  MemoDTO.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import SwiftData
import MacmoDomain

@Model
public class MemoDTO {
    public var id: String = ""
    public var title: String = ""
    public var contents: String?
    public var due: Date?
    public var done: Bool = false
    public var eventIdentifier: String?
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()

    public init(id: String = "", title: String = "", contents: String? = nil, due: Date? = nil, done: Bool = false, eventIdentifier: String? = nil, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.contents = contents
        self.due = due
        self.done = done
        self.eventIdentifier = eventIdentifier
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension MemoDTO {
    public func toDomain() -> Memo {
        return Memo(
            id: id,
            title: title,
            contents: contents,
            due: due,
            done: done,
            eventIdentifier: eventIdentifier,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    public static func fromDomain(_ memo: Memo) -> MemoDTO {
        return MemoDTO(
            id: memo.id,
            title: memo.title,
            contents: memo.contents,
            due: memo.due,
            done: memo.done,
            eventIdentifier: memo.eventIdentifier,
            createdAt: memo.createdAt,
            updatedAt: memo.updatedAt
        )
    }
}
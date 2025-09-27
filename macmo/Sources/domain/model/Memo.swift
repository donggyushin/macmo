//
//  Memo.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation

public struct Memo: Equatable {
    public let id: String
    public let title: String
    public let contents: String?
    public let due: Date?
    public let done: Bool
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String = UUID().uuidString,
        title: String,
        contents: String? = nil,
        due: Date? = nil,
        done: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.contents = contents
        self.due = due
        self.done = done
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

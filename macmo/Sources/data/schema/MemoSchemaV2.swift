//
//  MemoSchemaV2.swift
//  macmo
//
//  Created by Claude on 9/30/25.
//

import Foundation
import SwiftData

enum MemoSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version = .init(2, 0, 0)

    static var models: [any PersistentModel.Type] {
        [MemoDTO.self]
    }

    @Model
    class MemoDTO {
        var id: String = ""
        var title: String = ""
        var contents: String?
        var due: Date?
        var done: Bool = false
        var eventIdentifier: String?
        var createdAt: Date = Date()
        var updatedAt: Date = Date()

        init(id: String = "", title: String = "", contents: String? = nil, due: Date? = nil, done: Bool = false, eventIdentifier: String? = nil, createdAt: Date = Date(), updatedAt: Date = Date()) {
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
}
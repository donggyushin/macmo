//
//  MemoSchemaV1.swift
//  macmo
//
//  Created by Claude on 9/30/25.
//

import Foundation
import SwiftData

enum MemoSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)

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
        var createdAt: Date = Date()
        var updatedAt: Date = Date()

        init(id: String = "", title: String = "", contents: String? = nil, due: Date? = nil, done: Bool = false, createdAt: Date = Date(), updatedAt: Date = Date()) {
            self.id = id
            self.title = title
            self.contents = contents
            self.due = due
            self.done = done
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
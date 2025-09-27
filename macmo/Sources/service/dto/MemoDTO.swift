//
//  MemoDTO.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import SwiftData

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

extension MemoDTO {
    func toDomain() -> Memo {
        return Memo(
            id: id,
            title: title,
            contents: contents,
            due: due,
            done: done,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    static func fromDomain(_ memo: Memo) -> MemoDTO {
        return MemoDTO(
            id: memo.id,
            title: memo.title,
            contents: memo.contents,
            due: memo.due,
            done: memo.done,
            createdAt: memo.createdAt,
            updatedAt: memo.updatedAt
        )
    }
}
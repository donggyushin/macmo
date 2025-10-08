import Foundation
import SwiftData

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

    init(
        id: String = "", title: String = "", contents: String? = nil, due: Date? = nil,
        done: Bool = false, eventIdentifier: String? = nil, createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
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
    func toDomainData() -> MemoData {
        MemoData(id: id, title: title, content: contents ?? "", createdAt: createdAt, isCompleted: done)
    }
}


import Foundation

public struct MemoData: Identifiable {
    public let id: String
    public let title: String
    public let content: String
    public let createdAt: Date
    public let isCompleted: Bool
    public let due: Date?

    public var isUrgent: Bool {
        // Consider urgent if due within 3 days (259200 seconds) and not completed
        guard let due = due, !isCompleted else { return false }
        return due.timeIntervalSinceNow <= 259_200
    }

    init(
        id: String,
        title: String,
        content: String,
        createdAt: Date,
        isCompleted: Bool,
        due: Date?
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.isCompleted = isCompleted
        self.due = due
    }
}

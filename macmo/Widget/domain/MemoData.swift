
import Foundation

public struct MemoData: Identifiable {
    public let id: String
    public let title: String
    public let content: String
    public let createdAt: Date
    public let isCompleted: Bool

    init(
        id: String,
        title: String,
        content: String,
        createdAt: Date,
        isCompleted: Bool
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}

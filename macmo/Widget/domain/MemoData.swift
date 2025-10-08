
import Foundation

struct MemoData: Identifiable {
    let id: UUID
    let title: String
    let content: String
    let createdAt: Date
    let isCompleted: Bool
}

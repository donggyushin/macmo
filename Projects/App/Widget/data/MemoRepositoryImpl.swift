import Foundation
import MacmoData
import SwiftData

// Extension to convert MacmoData.MemoDTO to Widget's MemoData
private extension MacmoData.MemoDTO {
    func toWidgetMemoData() -> MemoData {
        MemoData(
            id: id,
            title: title,
            content: contents ?? "",
            createdAt: createdAt,
            updatedAt: updatedAt,
            isCompleted: done,
            due: due
        )
    }
}

public final class MemoRepositoryImpl: MemoRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func get() throws -> [MemoData] {
        let sortOrder: SortOrder = .reverse
        let sortDescriptor: SortDescriptor<MacmoData.MemoDTO> = SortDescriptor(\.updatedAt, order: sortOrder)

        var descriptor = FetchDescriptor<MacmoData.MemoDTO>(
            predicate: nil,
            sortBy: [sortDescriptor]
        )

        descriptor.fetchLimit = 1000

        let dtos = try modelContext.fetch(descriptor)

        // Convert to MemoData
        let allMemos = dtos.map { $0.toWidgetMemoData() }

        // Remove duplicates by ID, keeping the most recently updated memo
        var uniqueMemos: [String: MemoData] = [:]
        for memo in allMemos {
            if let existing = uniqueMemos[memo.id] {
                // Keep the memo with the most recent updatedAt
                if memo.updatedAt > existing.updatedAt {
                    uniqueMemos[memo.id] = memo
                }
            } else {
                uniqueMemos[memo.id] = memo
            }
        }

        // Convert back to array and sort
        return Array(uniqueMemos.values)
            .sorted { lhs, rhs in
                // 1. isCompleted 비교: false가 먼저
                if lhs.isCompleted != rhs.isCompleted {
                    return !lhs.isCompleted
                }

                // 2. due 존재 여부 및 값 비교
                switch (lhs.due, rhs.due) {
                case let (.some(lhsDue), .some(rhsDue)):
                    // 둘 다 due가 있으면 날짜 비교 (작은 값이 먼저)
                    return lhsDue < rhsDue
                case (.some, .none):
                    // lhs만 due가 있으면 lhs가 먼저
                    return true
                case (.none, .some):
                    // rhs만 due가 있으면 rhs가 먼저
                    return false
                case (.none, .none):
                    // 둘 다 없으면 순서 유지
                    return false
                }
            }
    }

    public func getPlaceholder() throws -> [MemoData] {
        let now = Date()
        return [
            MemoData(
                id: "sample",
                title: "Sample memo",
                content: "Can check recent memo from widget",
                createdAt: now,
                updatedAt: now,
                isCompleted: false,
                due: nil
            )
        ]
    }
}

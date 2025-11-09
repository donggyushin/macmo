import Foundation
import SwiftData

public final class MemoRepositoryImpl: MemoRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func get() throws -> [MemoData] {
        let sortOrder: SortOrder = .reverse
        let sortDescriptor: SortDescriptor<MemoDTO> = SortDescriptor(\.updatedAt, order: sortOrder)

        var descriptor = FetchDescriptor<MemoDTO>(
            predicate: nil,
            sortBy: [sortDescriptor]
        )

        descriptor.fetchLimit = 1000

        let dtos = try modelContext.fetch(descriptor)

        return dtos
            .map { $0.toDomainData() }
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
        return [
            MemoData(
                id: "sample",
                title: "Sample memo",
                content: "Can check recent memo from widget",
                createdAt: Date(),
                isCompleted: false,
                due: nil
            ),
        ]
    }
}

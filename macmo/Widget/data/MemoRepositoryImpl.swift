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

        descriptor.fetchLimit = 10

        let dtos = try modelContext.fetch(descriptor)

        return dtos.map { $0.toDomainData() }
    }

    public func getPlaceholder() throws -> [MemoData] {
        return [
            MemoData(
                id: "sample",
                title: "Sample memo",
                content: "Can check recent memo from widget",
                createdAt: Date(),
                isCompleted: false
            ),
        ]
    }
}

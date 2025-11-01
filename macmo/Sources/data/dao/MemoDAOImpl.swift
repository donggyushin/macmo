//
//  MemoDAOImpl.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import SwiftData

class MemoDAOImpl: MemoDAO {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ memo: Memo) throws {
        let dto = MemoDTO.fromDomain(memo)
        modelContext.insert(dto)
        try modelContext.save()
    }

    /// sortBy default value is createdAt,
    /// ascending default value is false
    func findAll(cursorId: String?, limit: Int, sortBy: MemoSort, ascending: Bool) throws -> [Memo] {
        let sortOrder: SortOrder = ascending ? .forward : .reverse
        let sortDescriptor: SortDescriptor<MemoDTO>

        switch sortBy {
        case .createdAt:
            sortDescriptor = SortDescriptor(\.createdAt, order: sortOrder)
        case .updatedAt:
            sortDescriptor = SortDescriptor(\.updatedAt, order: sortOrder)
        case .due:
            sortDescriptor = SortDescriptor(\.due, order: sortOrder)
        }

        var predicate: Predicate<MemoDTO>?

        if let cursorId = cursorId {
            let cursorPredicate = #Predicate<MemoDTO> { $0.id == cursorId }
            let cursorDescriptor = FetchDescriptor<MemoDTO>(predicate: cursorPredicate)
            let cursorDtos = try modelContext.fetch(cursorDescriptor)

            if let cursorDto = cursorDtos.first {
                switch sortBy {
                case .createdAt:
                    let cursorDate = cursorDto.createdAt
                    predicate = ascending ?
                        #Predicate<MemoDTO> { $0.createdAt > cursorDate } :
                        #Predicate<MemoDTO> { $0.createdAt < cursorDate }
                case .updatedAt:
                    let cursorDate = cursorDto.updatedAt
                    predicate = ascending ?
                        #Predicate<MemoDTO> { $0.updatedAt > cursorDate } :
                        #Predicate<MemoDTO> { $0.updatedAt < cursorDate }
                case .due:
                    // For due date sorting with cursor, we'll handle filtering in memory
                    // since SwiftData predicates don't handle optional date comparisons well
                    predicate = nil
                }
            }
        }

        var descriptor = FetchDescriptor<MemoDTO>(
            predicate: predicate,
            sortBy: [sortDescriptor]
        )

        // For due date sorting with cursor, we need to fetch all and filter in memory
        if sortBy == .due, cursorId != nil {
            // Don't set fetchLimit, we'll apply it after filtering
        } else {
            descriptor.fetchLimit = limit
        }

        let dtos = try modelContext.fetch(descriptor)
        var results = dtos.map { $0.toDomain() }

        // Handle cursor filtering for due date sorting in memory
        if sortBy == .due, let cursorId = cursorId, let cursorIndex = results.firstIndex(where: { $0.id == cursorId }) {
            let nextIndex = cursorIndex + 1
            if nextIndex < results.count {
                results = Array(results[nextIndex...])
            } else {
                results = []
            }
            // Apply limit after cursor filtering
            results = Array(results.prefix(limit))
        }

        return results
    }

    func findById(_ id: String) throws -> Memo? {
        let predicate = #Predicate<MemoDTO> { $0.id == id }
        let descriptor = FetchDescriptor<MemoDTO>(predicate: predicate)
        let dtos = try modelContext.fetch(descriptor)
        return dtos.first?.toDomain()
    }

    func update(_ memo: Memo) throws {
        let memoId = memo.id
        let predicate = #Predicate<MemoDTO> { $0.id == memoId }
        let descriptor = FetchDescriptor<MemoDTO>(predicate: predicate)
        let dtos = try modelContext.fetch(descriptor)

        if let dto = dtos.first {
            dto.title = memo.title
            dto.contents = memo.contents
            dto.due = memo.due
            dto.done = memo.done
            dto.updatedAt = Date()
            dto.eventIdentifier = memo.eventIdentifier
            try modelContext.save()
        }
    }

    func delete(_ id: String) throws {
        let predicate = #Predicate<MemoDTO> { $0.id == id }
        let descriptor = FetchDescriptor<MemoDTO>(predicate: predicate)
        let dtos = try modelContext.fetch(descriptor)

        if let dto = dtos.first {
            modelContext.delete(dto)
            try modelContext.save()
        }
    }

    func search(query: String, cursorId: String?, limit: Int, sortBy: MemoSort) throws -> [Memo] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        let searchQuery = query.lowercased()

        // Handle special search keywords that require in-memory filtering
        let isSpecialKeyword = ["urgent", "completed", "uncompleted"].contains(searchQuery)

        var filteredMemos: [Memo]

        // Fetch all memos and filter in memory for reliable case-insensitive search
        // let descriptor = FetchDescriptor<MemoDTO>(
        //     sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        // )
        let descriptor: FetchDescriptor<MemoDTO>

        switch sortBy {
        case .createdAt:
            descriptor = .init(
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
        case .updatedAt:
            descriptor = .init(
                sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
            )
        case .due:
            // For due date sorting with cursor, we'll handle filtering in memory
            // since SwiftData predicates don't handle optional date comparisons well
            descriptor = .init(
                sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
            )
        }

        let allDtos = try modelContext.fetch(descriptor)

        filteredMemos = allDtos.compactMap { dto -> Memo? in
            let memo = dto.toDomain()

            // Regular text matching
            let titleMatch = memo.title.localizedStandardContains(query)
            let contentMatch = memo.contents?.localizedStandardContains(query) ?? false

            // Special keyword matching (in addition to text matching)
            var specialMatch = false
            if isSpecialKeyword {
                if searchQuery == "urgent", let dueDate = memo.due, !memo.done {
                    let now = Date()
                    let timeInterval = dueDate.timeIntervalSince(now)
                    specialMatch = timeInterval <= 259_200
                } else if searchQuery == "completed", memo.done {
                    specialMatch = true
                } else if searchQuery == "uncompleted", !memo.done {
                    specialMatch = true
                }
            }

            return (titleMatch || contentMatch || specialMatch) ? memo : nil
        }

        // Apply cursor pagination
        if let cursorId = cursorId,
           let cursorIndex = filteredMemos.firstIndex(where: { $0.id == cursorId }) {
            let nextIndex = cursorIndex + 1
            if nextIndex < filteredMemos.count {
                filteredMemos = Array(filteredMemos[nextIndex...])
            } else {
                filteredMemos = []
            }
        }

        if sortBy == .due {
            filteredMemos = filteredMemos.sorted { memo1, memo2 in
                if let date1 = memo1.due, let date2 = memo2.due {
                    return date1 < date2
                } else if memo2.due != nil {
                    return false
                } else {
                    return true
                }
            }
        }

        // Apply limit
        return Array(filteredMemos.prefix(limit))
    }

    func search(query: String, cursorId: String?, limit: Int) throws -> [Memo] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        let searchQuery = query.lowercased()

        // Handle special search keywords that require in-memory filtering
        let isSpecialKeyword = ["urgent", "completed", "uncompleted"].contains(searchQuery)

        var filteredMemos: [Memo]

        // Fetch all memos and filter in memory for reliable case-insensitive search
        let descriptor = FetchDescriptor<MemoDTO>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        let allDtos = try modelContext.fetch(descriptor)

        filteredMemos = allDtos.compactMap { dto -> Memo? in
            let memo = dto.toDomain()

            // Regular text matching
            let titleMatch = memo.title.localizedStandardContains(query)
            let contentMatch = memo.contents?.localizedStandardContains(query) ?? false

            // Special keyword matching (in addition to text matching)
            var specialMatch = false
            if isSpecialKeyword {
                if searchQuery == "urgent", let dueDate = memo.due, !memo.done {
                    let now = Date()
                    let timeInterval = dueDate.timeIntervalSince(now)
                    specialMatch = timeInterval <= 259_200
                } else if searchQuery == "completed", memo.done {
                    specialMatch = true
                } else if searchQuery == "uncompleted", !memo.done {
                    specialMatch = true
                }
            }

            return (titleMatch || contentMatch || specialMatch) ? memo : nil
        }

        // Apply cursor pagination
        if let cursorId = cursorId,
           let cursorIndex = filteredMemos.firstIndex(where: { $0.id == cursorId }) {
            let nextIndex = cursorIndex + 1
            if nextIndex < filteredMemos.count {
                filteredMemos = Array(filteredMemos[nextIndex...])
            } else {
                filteredMemos = []
            }
        }

        // Apply limit
        return Array(filteredMemos.prefix(limit))
    }

    func getMemoStatics() -> MemoStatistics {
        // Fetch all memos and calculate statistics in memory to match search() behavior
        let descriptor = FetchDescriptor<MemoDTO>()
        guard let allDtos = try? modelContext.fetch(descriptor) else {
            return MemoStatistics(totalCount: 0, uncompletedCount: 0, urgentsCount: 0)
        }

        let allMemos = allDtos.map { $0.toDomain() }

        // 1. Total count
        let totalCount = allMemos.count

        // 2. Uncompleted count
        let uncompletedCount = allMemos.filter { !$0.done }.count

        // 3. Urgent count - using same logic as search() and Memo.isUrgent
        let now = Date()
        let urgentsCount = allMemos.filter { memo in
            guard let dueDate = memo.due, !memo.done else { return false }
            let timeInterval = dueDate.timeIntervalSince(now)
            return timeInterval <= 259_200
        }.count

        return MemoStatistics(
            totalCount: totalCount,
            uncompletedCount: uncompletedCount,
            urgentsCount: urgentsCount
        )
    }
}

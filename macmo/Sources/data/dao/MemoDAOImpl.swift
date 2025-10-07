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
    
    @UserDefault(key: "memo-sort", defaultValue: MemoSort.createdAt) var memoSortCache
    @UserDefault(key: "ascending", defaultValue: false) var ascendingCache

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ memo: Memo) throws {
        let dto = MemoDTO.fromDomain(memo)
        modelContext.insert(dto)
        try modelContext.save()
    }

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
        if sortBy == .due && cursorId != nil {
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

    func search(query: String, cursorId: String?, limit: Int) throws -> [Memo] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        // SwiftData predicates don't support case-insensitive search well,
        // so we fetch all and filter in memory for better user experience
        let descriptor = FetchDescriptor<MemoDTO>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        let allDtos = try modelContext.fetch(descriptor)

        // Convert to domain objects and filter case-insensitively
        let searchQuery = query.lowercased()
        var filteredMemos = allDtos.compactMap { dto -> Memo? in
            let memo = dto.toDomain()
            let titleMatch = memo.title.lowercased().contains(searchQuery)
            let contentMatch = memo.contents?.lowercased().contains(searchQuery) ?? false

            // Special "urgent" feature: include memos with approaching due dates
            var urgentMatch = false
            if searchQuery == "urgent", let dueDate = memo.due, !memo.done {
                let now = Date()
                let timeInterval = dueDate.timeIntervalSince(now)
                // Consider urgent if due within 3 days (259200 seconds) and not completed
                urgentMatch = timeInterval <= 259200
            }

            // Special "completed" feature: include all completed memos
            var completedMatch = false
            if searchQuery == "completed" && memo.done {
                completedMatch = true
            }
            
            // Special "uncompleted" feature: include all uncompleted memos
            var uncompletedMatch = false
            if searchQuery == "uncompleted" && memo.done == false {
                uncompletedMatch = true
            }

            return (titleMatch || contentMatch || urgentMatch || completedMatch || uncompletedMatch) ? memo : nil
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

    func get() -> MemoSort {
        return memoSortCache
    }
    
    
    func set(_ sort: MemoSort) {
        memoSortCache = sort
    }
    
    func getAscending() -> Bool {
        ascendingCache
    }
    
    func setAscending(_ ascending: Bool) {
        ascendingCache = ascending
    }
}

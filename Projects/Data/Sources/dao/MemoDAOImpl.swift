//
//  MemoDAOImpl.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import MacmoDomain
import SwiftData

public class MemoDAOImpl: MemoDAO {
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func save(_ memo: Memo) throws {
        let dto = MemoDTO.fromDomain(memo)
        modelContext.insert(dto)
        try modelContext.save()
    }

    public func find(year: Int, month: Int) throws -> [CalendarDay] {
        // 1. 해당 월의 시작일과 마지막일 계산
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        guard let startDate = Calendar.current.date(from: components) else {
            return []
        }

        // 다음 달의 시작일 (현재 달의 범위를 초과하지 않도록)
        guard let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) else {
            return []
        }

        // 2. due 날짜가 해당 월에 포함되는 메모들을 찾는 Predicate
        let predicate = #Predicate<MemoDTO> { memo in
            memo.due != nil && memo.due! >= startDate && memo.due! < endDate
        }

        // 3. FetchDescriptor 생성 및 쿼리 실행
        let descriptor = FetchDescriptor<MemoDTO>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.due, order: .forward)]
        )

        let dtos = try modelContext.fetch(descriptor)

        // 4. DTO를 CalendarDay로 변환
        let calendarDays = dtos.compactMap { dto -> CalendarDay? in
            guard let due = dto.due else { return nil }
            let components = Calendar.current.dateComponents([.year, .month, .day], from: due)
            guard let day = components.day else { return nil }

            return CalendarDay(
                year: year,
                month: month,
                day: day,
                memo: dto.toDomain()
            )
        }

        return calendarDays
    }

    /// sortBy default value is createdAt,
    /// ascending default value is false
    public func findAll(cursorId: String?, limit: Int, sortBy: MemoSort, ascending: Bool) throws -> [Memo] {
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

    public func findById(_ id: String) throws -> Memo? {
        let predicate = #Predicate<MemoDTO> { $0.id == id }
        let descriptor = FetchDescriptor<MemoDTO>(predicate: predicate)
        let dtos = try modelContext.fetch(descriptor)
        return dtos.first?.toDomain()
    }

    public func update(_ memo: Memo) throws {
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

    public func delete(_ id: String) throws {
        let predicate = #Predicate<MemoDTO> { $0.id == id }
        let descriptor = FetchDescriptor<MemoDTO>(predicate: predicate)
        let dtos = try modelContext.fetch(descriptor)

        if let dto = dtos.first {
            modelContext.delete(dto)
            try modelContext.save()
        }
    }

    public func search(query: String, cursorId: String?, limit: Int, sortBy: MemoSort) throws -> [Memo] {
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

    public func getMemoStatics() -> MemoStatistics {
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

    public func addImage(_ memo: Memo, image: ImageAttachment) throws {
        // 1. Find the MemoDTO
        let memoId = memo.id
        let predicate = #Predicate<MemoDTO> { $0.id == memoId }
        let descriptor = FetchDescriptor<MemoDTO>(predicate: predicate)
        let dtos = try modelContext.fetch(descriptor)

        guard let memoDTO = dtos.first else {
            throw AppError.notFound
        }

        // 2. Create ImageAttachmentDTO from domain
        let imageDTO = ImageAttachmentDTO(from: image)

        // 3. Insert the image into context
        modelContext.insert(imageDTO)

        // 4. Set up the relationship
        imageDTO.memo = memoDTO

        // 5. Add to memo's images array (handle optional)
        if memoDTO.images == nil {
            memoDTO.images = [imageDTO]
        } else {
            memoDTO.images?.append(imageDTO)
        }

        // 6. Update memo's updatedAt timestamp
        memoDTO.updatedAt = Date()

        // 7. Save changes
        try modelContext.save()
    }

    public func deleteImage(memoId: String, imageId: String) throws {
        // 1. Find the MemoDTO
        let memoPredicate = #Predicate<MemoDTO> { $0.id == memoId }
        let memoDescriptor = FetchDescriptor<MemoDTO>(predicate: memoPredicate)
        let memoDtos = try modelContext.fetch(memoDescriptor)

        guard let memoDTO = memoDtos.first else {
            throw AppError.notFound
        }

        // 2. Find the ImageAttachmentDTO
        let imagePredicate = #Predicate<ImageAttachmentDTO> { $0.id == imageId }
        let imageDescriptor = FetchDescriptor<ImageAttachmentDTO>(predicate: imagePredicate)
        let imageDtos = try modelContext.fetch(imageDescriptor)

        guard let imageDTO = imageDtos.first else {
            throw AppError.notFound
        }

        // 3. Verify the image belongs to this memo
        guard imageDTO.memo?.id == memoId else {
            throw AppError.custom("Image does not belong to this memo")
        }

        // 4. Remove from memo's images array
        if var images = memoDTO.images {
            images.removeAll { $0.id == imageId }
            memoDTO.images = images.isEmpty ? nil : images
        }

        // 5. Delete the ImageAttachmentDTO
        modelContext.delete(imageDTO)

        // 6. Update memo's updatedAt timestamp
        memoDTO.updatedAt = Date()

        // 7. Save changes
        try modelContext.save()
    }
}

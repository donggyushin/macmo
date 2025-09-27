//
//  MemoDAO.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import SwiftData

class MemoDAO: MemoDAOProtocol {
    private let modelContext: ModelContext

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
                    if let cursorDue = cursorDto.due {
                        predicate = ascending ?
                            #Predicate<MemoDTO> { $0.due != nil && $0.due! > cursorDue } :
                            #Predicate<MemoDTO> { $0.due != nil && $0.due! < cursorDue }
                    }
                }
            }
        }

        var descriptor = FetchDescriptor<MemoDTO>(
            predicate: predicate,
            sortBy: [sortDescriptor]
        )
        descriptor.fetchLimit = limit

        let dtos = try modelContext.fetch(descriptor)
        return dtos.map { $0.toDomain() }
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
}

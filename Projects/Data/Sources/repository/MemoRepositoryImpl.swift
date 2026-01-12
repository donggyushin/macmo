//
//  MemoRepositoryImpl.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation
import MacmoDomain

public final class MemoRepositoryImpl: MemoRepository {
    let memoDAO: MemoDAO

    public init(memoDAO: MemoDAO) {
        self.memoDAO = memoDAO
    }

    public func findByDate(_ date: Date) throws -> [Memo] {
        try memoDAO.findByDate(date)
    }

    public func save(_ memo: Memo) throws {
        try memoDAO.save(memo)
    }

    public func findAll(cursorId: String?, limit: Int, sortBy: MemoSort, ascending: Bool) throws -> [Memo] {
        try memoDAO.findAll(cursorId: cursorId, limit: limit, sortBy: sortBy, ascending: ascending)
    }

    public func findById(_ id: String) throws -> Memo? {
        try memoDAO.findById(id)
    }

    public func update(_ memo: Memo) throws {
        return try memoDAO.update(memo)
    }

    public func delete(_ id: String) throws {
        try memoDAO.delete(id)
    }

    public func search(query: String, cursorId: String?, limit: Int, sortBy: MemoSort) throws -> [Memo] {
        try memoDAO.search(query: query, cursorId: cursorId, limit: limit, sortBy: sortBy)
    }

    public func getMemoStatics() -> MemoStatistics {
        memoDAO.getMemoStatics()
    }

    public func addImage(_ memo: Memo, image: ImageAttachment) throws {
        try memoDAO.addImage(memo, image: image)
    }

    public func deleteImage(memoId: String, imageId: String) throws {
        try memoDAO.deleteImage(memoId: memoId, imageId: imageId)
    }
}

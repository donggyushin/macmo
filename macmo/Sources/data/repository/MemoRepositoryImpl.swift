//
//  MemoRepositoryImpl.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation

public final class MemoRepositoryImpl: MemoRepository {
    
    @UserDefault(key: "memo-sort", defaultValue: MemoSort.createdAt) var memoSortCache
    @UserDefault(key: "ascending", defaultValue: false) var ascendingCache
    
    let memoDAO: MemoDAO
    
    public init(memoDAO: MemoDAO) {
        self.memoDAO = memoDAO
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
    
    public func search(query: String, cursorId: String?, limit: Int) throws -> [Memo] {
        try memoDAO.search(query: query, cursorId: cursorId, limit: limit)
    }
    
    public func get() -> MemoSort {
        return memoSortCache
    }
    
    
    public func set(_ sort: MemoSort) {
        memoSortCache = sort
    }
    
    public func getAscending() -> Bool {
        ascendingCache
    }
    
    public func setAscending(_ ascending: Bool) {
        ascendingCache = ascending
    }
}

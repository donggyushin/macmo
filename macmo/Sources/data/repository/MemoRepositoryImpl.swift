//
//  MemoRepositoryImpl.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation

public final class MemoRepositoryImpl: MemoRepository {
    @UserDefault(key: "memo-sort", defaultValue: MemoSort.createdAt) var memoSortCache
    @UserDefault(key: "memo-sort-in-search", defaultValue: MemoSort.due) var memoSortCacheInSearch
    @UserDefault(key: "ascending", defaultValue: false) var ascendingCache
    @UserDefault(key: "statistics-enum", defaultValue: StatisticsEnum.chart) var statisticsEnum

    let memoDAO: MemoDAO

    public init(memoDAO: MemoDAO) {
        self.memoDAO = memoDAO
    }

    public func set(_ statisticsEnum: StatisticsEnum) {
        self.statisticsEnum = statisticsEnum
    }

    public func get() -> StatisticsEnum {
        statisticsEnum
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

    public func get() -> MemoSort {
        return memoSortCache
    }

    public func set(_ sort: MemoSort) {
        memoSortCache = sort
    }

    public func getMemoSortCacheInSearch() -> MemoSort {
        memoSortCacheInSearch
    }

    public func setMemoSortCacheInSearch(_ sort: MemoSort) {
        memoSortCacheInSearch = sort
    }

    public func getAscending() -> Bool {
        ascendingCache
    }

    public func setAscending(_ ascending: Bool) {
        ascendingCache = ascending
    }

    public func getMemoStatics() -> MemoStatistics {
        memoDAO.getMemoStatics()
    }
}

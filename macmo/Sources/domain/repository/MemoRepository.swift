//
//  MemoRepository.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

public protocol MemoRepository {
    func save(_ memo: Memo) throws
    func findAll(cursorId: String?, limit: Int, sortBy: MemoSort, ascending: Bool) throws -> [Memo]
    func findById(_ id: String) throws -> Memo?
    func update(_ memo: Memo) throws
    func delete(_ id: String) throws
    func search(query: String, cursorId: String?, limit: Int) throws -> [Memo]

    func get() -> MemoSort
    func set(_ sort: MemoSort)
    func getAscending() -> Bool
    func setAscending(_ ascending: Bool)
    func getMemoStatics() -> MemoStatistics
    func set(_ statisticsEnum: StatisticsEnum)
    func get() -> StatisticsEnum
}

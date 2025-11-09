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
    func search(query: String, cursorId: String?, limit: Int, sortBy: MemoSort) throws -> [Memo]
    func getMemoStatics() -> MemoStatistics
    func setMemoSearchQuery(_ query: String)
    func getMemoSearchQuery() -> String
    func setNavigationForCache(_ navigations: [NavigationDomain])
    func getNavigationForCache() -> [NavigationDomain]
}

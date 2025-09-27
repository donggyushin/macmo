//
//  MockMemoDAO.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation

class MockMemoDAO: MemoDAOProtocol {
    private var memos: [String: Memo] = [:]
    
    @UserDefault(key: "memo-sort", defaultValue: MemoSort.createdAt) var memoSortCache
    @UserDefault(key: "ascending", defaultValue: false) var ascendingCache

    init(initialMemos: [Memo] = []) {
        for memo in initialMemos {
            memos[memo.id] = memo
        }
    }

    func save(_ memo: Memo) throws {
        memos[memo.id] = memo
    }

    func findAll(cursorId: String?, limit: Int, sortBy: MemoSort, ascending: Bool) throws -> [Memo] {
        var allMemos = Array(memos.values)

        // Apply sorting
        switch sortBy {
        case .createdAt:
            allMemos.sort { ascending ? $0.createdAt < $1.createdAt : $0.createdAt > $1.createdAt }
        case .updatedAt:
            allMemos.sort { ascending ? $0.updatedAt < $1.updatedAt : $0.updatedAt > $1.updatedAt }
        case .due:
            allMemos.sort { memo1, memo2 in
                switch (memo1.due, memo2.due) {
                case (nil, nil): return false
                case (nil, _): return !ascending
                case (_, nil): return ascending
                case let (date1?, date2?):
                    return ascending ? date1 < date2 : date1 > date2
                }
            }
        }

        // Apply cursor pagination
        if let cursorId = cursorId,
           let cursorIndex = allMemos.firstIndex(where: { $0.id == cursorId }) {
            let nextIndex = cursorIndex + 1
            if nextIndex < allMemos.count {
                allMemos = Array(allMemos[nextIndex...])
            } else {
                allMemos = []
            }
        }

        // Apply limit
        return Array(allMemos.prefix(limit))
    }

    func findById(_ id: String) throws -> Memo? {
        return memos[id]
    }

    func update(_ memo: Memo) throws {
        guard memos[memo.id] != nil else { return }
        let updatedMemo = Memo(
            id: memo.id,
            title: memo.title,
            contents: memo.contents,
            due: memo.due,
            done: memo.done,
            createdAt: memo.createdAt,
            updatedAt: Date()
        )
        memos[memo.id] = updatedMemo
    }

    func delete(_ id: String) throws {
        memos.removeValue(forKey: id)
    }

    func search(query: String, cursorId: String?, limit: Int) throws -> [Memo] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        let searchQuery = query.lowercased()
        var filteredMemos = Array(memos.values).filter { memo in
            memo.title.lowercased().contains(searchQuery) ||
            (memo.contents?.lowercased().contains(searchQuery) ?? false)
        }

        // Sort by updatedAt in reverse order (newest first)
        filteredMemos.sort { $0.updatedAt > $1.updatedAt }

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
}

extension MockMemoDAO {
    static func withSampleData() -> MockMemoDAO {
        let sampleMemos = [
            Memo(
                title: "Buy groceries",
                contents: "# title\n## Title2\n### Title3\n\n- Hello\n- World \n\n\n [Github](https://www.google.com)",
                due: Calendar.current.date(byAdding: .day, value: -1, to: Date())
            ),
            Memo(
                title: "Meeting with team",
                contents: "Discuss project roadmap and sprint planning",
                due: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
                done: false
            ),
            Memo(
                title: "Complete SwiftUI tutorial",
                contents: nil,
                due: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
                done: true
            )
        ]
        return MockMemoDAO(initialMemos: sampleMemos)
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

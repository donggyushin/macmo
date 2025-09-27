//
//  MockMemoDAO.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation

class MockMemoDAO: MemoDAOProtocol {
    private var memos: [String: Memo] = [:]

    init(initialMemos: [Memo] = []) {
        for memo in initialMemos {
            memos[memo.id] = memo
        }
    }

    func save(_ memo: Memo) throws {
        memos[memo.id] = memo
    }

    func findAll() throws -> [Memo] {
        return Array(memos.values).sorted { $0.createdAt > $1.createdAt }
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
}

extension MockMemoDAO {
    static func withSampleData() -> MockMemoDAO {
        let sampleMemos = [
            Memo(
                title: "Buy groceries",
                contents: "Milk, bread, eggs, cheese",
                due: Calendar.current.date(byAdding: .day, value: 1, to: Date())
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
}
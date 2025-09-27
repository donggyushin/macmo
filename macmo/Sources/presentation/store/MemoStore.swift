//
//  MemoStore.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import Factory
import Combine

let memoStore = MemoStore()

final class MemoStore: ObservableObject {
    
    @Published var memos: [Memo] = []
    
    fileprivate init() { }
    
    @Injected(\.memoDAO) private var memoDAO
    
    @MainActor
    func fetchMemos(_ sort: MemoSort = .createdAt, ascending: Bool = false) throws {
        let memos = try memoDAO.findAll(cursorId: memos.last?.id, limit: 100, sortBy: sort, ascending: ascending)
        self.memos.append(contentsOf: memos)
    }
    
    @MainActor
    func refreshMemos(_ sort: MemoSort = .createdAt, ascending: Bool = false) throws {
        let memos = try memoDAO.findAll(cursorId: nil, limit: 100, sortBy: sort, ascending: ascending)
        self.memos = []
    }
}

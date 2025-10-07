//
//  MemoDAO.swift
//  macmo
//
//  Created by 신동규 on 9/30/25.
//

import Foundation

public protocol MemoDAO {
    func save(_ memo: Memo) throws
    func findAll(cursorId: String?, limit: Int, sortBy: MemoSort, ascending: Bool) throws -> [Memo]
    func findById(_ id: String) throws -> Memo?
    func update(_ memo: Memo) throws
    func delete(_ id: String) throws
    func search(query: String, cursorId: String?, limit: Int) throws -> [Memo]
}

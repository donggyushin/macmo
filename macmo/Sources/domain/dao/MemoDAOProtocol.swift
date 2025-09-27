//
//  MemoDAOProtocol.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//


public protocol MemoDAOProtocol {
    func save(_ memo: Memo) throws
    func findAll() throws -> [Memo]
    func findById(_ id: String) throws -> Memo?
    func update(_ memo: Memo) throws
    func delete(_ id: String) throws
}

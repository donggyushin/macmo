//
//  MemoDetailViewModel.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import Combine
import Factory

final class MemoDetailViewModel: ObservableObject {
    
    @Injected(\.memoDAO) private var memoDAO
    
    let store = memoStore
    
    @Published var memo: Memo?
    
    private var isNew = false
    
    init(id: String?) {
        Task { @MainActor in
            if let id {
                memo = try? memoDAO.findById(id)
            }
            
            if memo == nil {
                memo = .init(title: "")
                isNew = true
            }
        }
    }
    
    @MainActor
    func add() throws {
        guard let memo else { return }
        try store.add(memo)
    }
    
    @MainActor
    func update() throws {
        guard let memo else { return }
        try store.update(memo)
    }
}

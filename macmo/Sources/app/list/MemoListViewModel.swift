//
//  MemoListViewModel.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import Factory
import Combine

final class MemoListViewModel: ObservableObject {
    
    @Published var memos: [Memo] = []
    @Published var selectedMemoId: String?
    @Published var sortBy: MemoSort = .createdAt
    @Published var ascending: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        sortBy = memoRepository.get()
        ascending = memoRepository.getAscending()
        bind()
    }
    
    private func bind() {
        $sortBy
            .sink { sort in
                self.memoRepository.set(sort)
            }
            .store(in: &cancellables)
        
        $ascending
            .sink { ascending in
                self.memoRepository.setAscending(ascending)
            }
            .store(in: &cancellables)
    }
    
    @Injected(\.memoRepository) private var memoRepository
    @Injected(\.memoUseCase) private var memoUseCase
    
    @MainActor
    func fetchMemos(_ sort: MemoSort = .createdAt, ascending: Bool = false) throws {
        let memos = try memoRepository.findAll(cursorId: memos.last?.id, limit: 100, sortBy: sort, ascending: ascending)
        self.memos.append(contentsOf: memos)
    }
    
    @MainActor
    func refreshMemos(_ sort: MemoSort = .createdAt, ascending: Bool = false) throws {
        let memos = try memoRepository.findAll(cursorId: nil, limit: 100, sortBy: sort, ascending: ascending)
        self.memos = memos
        self.selectedMemoId = memos.first?.id
    }
    
    @MainActor
    func add(_ memo: Memo) async throws {
        try await memoUseCase.save(memo)
        self.memos.insert(memo, at: 0)
        selectedMemoId = memo.id
    }
    
    @MainActor
    func update(_ memo: Memo) async throws {
        try await memoUseCase.update(memo)
        if let index = self.memos.firstIndex(where: { $0.id == memo.id }) {
            self.memos[index] = memo
        }
    }
    
    @MainActor
    func delete(_ id: String) async throws {
        try await memoUseCase.delete(id)
        if let index = self.memos.firstIndex(where: { $0.id == id }) {
            self.memos.remove(at: index)
            self.selectedMemoId = self.memos.first?.id
        }
    }
}

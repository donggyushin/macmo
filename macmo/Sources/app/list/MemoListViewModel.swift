//
//  MemoListViewModel.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Combine
import Factory
import Foundation

final class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo] = []
    @Published var selectedMemoId: String?
    @Published var sortBy: MemoSort = .createdAt
    @Published var ascending: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        bind()
    }

    @Injected(\.memoRepository) private var memoRepository
    @Injected(\.userPreferenceRepository) private var userPreferenceRepository
    @Injected(\.memoUseCase) private var memoUseCase

    @MainActor func configInitialSetup() {
        sortBy = userPreferenceRepository.getMemoSort()
        ascending = memoRepository.getAscending()
    }

    @MainActor
    func fetchMemos() throws {
        let memos = try memoRepository.findAll(
            cursorId: memos.last?.id,
            limit: 100,
            sortBy: sortBy,
            ascending: ascending
        )
        self.memos.append(contentsOf: memos)
    }

    @MainActor
    func refreshMemos() throws {
        let memos = try memoRepository.findAll(cursorId: nil, limit: 100, sortBy: sortBy, ascending: ascending)
        self.memos = memos
        selectedMemoId = memos.first?.id
    }

    @MainActor
    func add(_ memo: Memo) async throws {
        try await memoUseCase.save(memo)
        memos.insert(memo, at: 0)
        selectedMemoId = memo.id
    }

    @MainActor
    func update(_ memo: Memo) async throws {
        try await memoUseCase.update(memo)
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos[index] = memo
        }
    }

    @MainActor
    func delete(_ id: String) async throws {
        try await memoUseCase.delete(id)
        if let index = memos.firstIndex(where: { $0.id == id }) {
            memos.remove(at: index)
            selectedMemoId = memos.first?.id
        }
    }

    private func bind() {
        $sortBy
            .sink { sort in
                self.userPreferenceRepository.setMemoSort(sort)
            }
            .store(in: &cancellables)

        $ascending
            .sink { ascending in
                self.memoRepository.setAscending(ascending)
            }
            .store(in: &cancellables)
    }
}

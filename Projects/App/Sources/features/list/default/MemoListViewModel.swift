//
//  MemoListViewModel.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Combine
import Factory
import Foundation
import MacmoDomain

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
        ascending = userPreferenceRepository.getAscending()
    }

    @MainActor
    func fetchMemos() throws {
        let memos = try memoRepository.findAll(
            cursorId: memos.last?.id,
            limit: 100,
            sortBy: sortBy,
            ascending: ascending
        )

        // Filter out duplicates before appending
        let existingIds = Set(self.memos.map { $0.id })
        let newMemos = memos.filter { !existingIds.contains($0.id) }
        self.memos.append(contentsOf: newMemos)
    }

    @MainActor
    func refreshMemos() throws {
        let memos = try memoRepository.findAll(cursorId: nil, limit: 100, sortBy: sortBy, ascending: ascending)

        // Remove duplicates by ID, keeping the most recently updated memo
        var uniqueMemos: [String: Memo] = [:]
        for memo in memos {
            if let existing = uniqueMemos[memo.id] {
                // Keep the memo with the most recent updatedAt
                if memo.updatedAt > existing.updatedAt {
                    uniqueMemos[memo.id] = memo
                }
            } else {
                uniqueMemos[memo.id] = memo
            }
        }

        // Convert back to array and sort according to sortBy and ascending
        let deduplicated = Array(uniqueMemos.values)
        self.memos = sortMemos(deduplicated, by: sortBy, ascending: ascending)
        selectedMemoId = self.memos.first?.id
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

    private func sortMemos(_ memos: [Memo], by sortBy: MemoSort, ascending: Bool) -> [Memo] {
        let sorted: [Memo]
        switch sortBy {
        case .createdAt:
            sorted = memos.sorted { ascending ? $0.createdAt < $1.createdAt : $0.createdAt > $1.createdAt }
        case .updatedAt:
            sorted = memos.sorted { ascending ? $0.updatedAt < $1.updatedAt : $0.updatedAt > $1.updatedAt }
        case .due:
            sorted = memos.sorted { memo1, memo2 in
                guard let due1 = memo1.due else { return false }
                guard let due2 = memo2.due else { return true }
                return ascending ? due1 < due2 : due1 > due2
            }
        }
        return sorted
    }

    private func bind() {
        $sortBy
            .dropFirst()
            .sink { sort in
                self.userPreferenceRepository.setMemoSort(sort)
            }
            .store(in: &cancellables)

        $ascending
            .dropFirst()
            .sink { ascending in
                self.userPreferenceRepository.setAscending(ascending)
            }
            .store(in: &cancellables)
    }
}

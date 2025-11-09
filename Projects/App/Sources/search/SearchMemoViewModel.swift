//
//  SearchMemoViewModel.swift
//  macmo
//
//  Created by 신동규 on 9/28/25.
//

import Combine
import Factory
import Foundation
import MacmoDomain

final class SearchMemoViewModel: ObservableObject {
    @Injected(\.memoRepository) private var memoRepository
    @Injected(\.userPreferenceRepository) private var userPreferenceRepository

    @Published var memos: [Memo] = []
    @Published var query = ""
    @Published var selectedMemoId: String?
    @Published var sortBy = MemoSort.updatedAt

    private var previousSearchQuery = ""

    private var cancellables = Set<AnyCancellable>()

    func onAppearMemoDetailView(_ id: String) {
        userPreferenceRepository.setSelectedMemoId(id)
    }

    @MainActor func configureInitialSetUp() {
        sortBy = userPreferenceRepository.getMemoSortCacheInSearch()
        query = userPreferenceRepository.getMemoSearchQuery()
        selectedMemoId = userPreferenceRepository.getSelectedMemoId()
        bind()
    }

    @MainActor func tapUrgentTag() {
        animateTyping(text: "Urgent")
    }

    @MainActor func tapUncompleted() {
        animateTyping(text: "Uncompleted")
    }

    @MainActor func delete(_ id: String) {
        selectedMemoId = nil
        userPreferenceRepository.setSelectedMemoId(nil)
        guard let index = memos.firstIndex(where: { $0.id == id }) else { return }
        memos.remove(at: index)
    }

    @MainActor func update(_ id: String) {
        guard let updatedMemo = try? memoRepository.findById(id) else { return }
        guard let index = memos.firstIndex(where: { $0.id == id }) else { return }
        memos[index] = updatedMemo
    }

    @MainActor
    func pagination() throws {
        let result = try memoRepository.search(query: query, cursorId: memos.last?.id, limit: 100, sortBy: sortBy)
        memos.append(contentsOf: result)
    }

    @MainActor private func animateTyping(text: String) {
        let currentQuery = query

        Task {
            // Animate deleting existing text
            for i in stride(from: currentQuery.count, through: 0, by: -1) {
                try? await Task.sleep(nanoseconds: 30_000_000) // 0.03 seconds per character
                query = String(currentQuery.prefix(i))
            }

            // Animate typing new text
            for (index, _) in text.enumerated() {
                try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds per character
                query = String(text.prefix(index + 1))
            }
        }
    }

    @MainActor private func search(_ query: String, _ sortBy: MemoSort) throws {
        let result = try memoRepository.search(query: query, cursorId: nil, limit: 100, sortBy: sortBy)
        memos = result
    }

    func setSortByValue(_ sortBy: MemoSort) {
        userPreferenceRepository.setMemoSortCacheInSearch(sortBy)
    }

    private func saveSearchQuery(_ query: String) {
        userPreferenceRepository.setMemoSearchQuery(query)
    }

    private func bind() {
        cancellables.removeAll()
        $query
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .combineLatest($sortBy)
            .sink { [weak self] query, sortBy in
                Task {
                    self?.saveSearchQuery(query)
                    try await self?.search(query, sortBy)
                }
            }
            .store(in: &cancellables)
    }
}

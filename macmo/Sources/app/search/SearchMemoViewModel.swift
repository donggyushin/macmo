//
//  SearchMemoViewModel.swift
//  macmo
//
//  Created by 신동규 on 9/28/25.
//

import Combine
import Factory
import Foundation

final class SearchMemoViewModel: ObservableObject {
    @Injected(\.memoRepository) private var memoRepository

    @Published var memos: [Memo] = []
    @Published var query = ""
    @Published var selectedMemoId: String?

    private var previousSearchQuery = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        bind()
    }

    private func bind() {
        $query
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                Task {
                    try await self?.search(query)
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func tapUrgentTag() {
        animateTyping(text: "Urgent")
    }

    @MainActor
    func tapUncompleted() {
        animateTyping(text: "Uncompleted")
    }

    @MainActor
    private func animateTyping(text: String) {
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

    @MainActor
    func delete(_ id: String) {
        selectedMemoId = nil
        guard let index = memos.firstIndex(where: { $0.id == id }) else { return }
        memos.remove(at: index)
    }

    @MainActor
    func update(_ id: String) {
        guard let updatedMemo = try? memoRepository.findById(id) else { return }
        guard let index = memos.firstIndex(where: { $0.id == id }) else { return }
        memos[index] = updatedMemo
    }

    @MainActor
    private func search(_ query: String) throws {
        let result = try memoRepository.search(query: query, cursorId: nil, limit: 100)
        memos = result
    }

    @MainActor
    func pagination() throws {
        let result = try memoRepository.search(query: query, cursorId: memos.last?.id, limit: 100)
        memos.append(contentsOf: result)
    }
}

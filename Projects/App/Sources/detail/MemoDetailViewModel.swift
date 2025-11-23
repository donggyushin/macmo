//
//  MemoDetailViewModel.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Combine
import Factory
import Foundation
import MacmoDomain

final class MemoDetailViewModel: ObservableObject {
    @Injected(\.memoRepository) private var memoRepository
    @Injected(\.userPreferenceRepository) private var userPreferenceRepository

    let memoListViewModel: MemoListViewModel

    @Published var memo: Memo
    @Published var isNewMemo = false
    @Published var isEditing = false

    // Editable properties
    @Published var title: String = ""
    @Published var contents: String = ""
    @Published var isDone: Bool = false
    @Published var dueDate: Date = .init() + 100
    @Published var hasDueDate: Bool = false
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var timer: Timer?

    init(id: String?) {
        self.memoListViewModel = Container.shared.memoListViewModel()
        let memoRepository = Container.shared.memoRepository()
        let userPreferenceRepository = Container.shared.userPreferenceRepository()
        // Perform synchronous database fetch - SwiftData is fast for local operations
        if let memo = try? memoRepository.findById(id ?? "") {
            self.memo = memo
            loadMemoData()
        } else {
            self.memo = userPreferenceRepository.getMemoDraft()
            self.isNewMemo = true
            self.isEditing = true
            loadMemoData()
        }
    }

    // Optimized initializer for existing memos to skip database lookup
    init(memo: Memo) {
        self.memoListViewModel = .init()
        self.memo = memo
        loadMemoData()
    }

    func startRepeatingTask() {
        // Schedule the function `updateCounting()` to run every 1 second, repeatedly
        stopTask()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMemoDrating()
        }
    }

    func stopTask() {
        timer?.invalidate() // Stops the timer from firing again
        timer = nil
    }

    private func loadMemoData() {
        title = memo.title
        contents = memo.contents ?? ""
        isDone = memo.done

        if let due = memo.due {
            dueDate = due
            hasDueDate = true
        } else {
            hasDueDate = false
        }
    }

    @MainActor
    func cancel() {
        isEditing = false
        loadMemoData()
    }

    @MainActor
    func startEditing() {
        isEditing = true
    }

    @MainActor
    func save() async throws {
        guard canSave else { return }

        let updatedMemo = Memo(
            id: memo.id,
            title: title,
            contents: contents.isEmpty ? nil : contents,
            due: hasDueDate ? dueDate : nil,
            done: isDone,
            createdAt: memo.createdAt,
            updatedAt: Date()
        )

        if isNewMemo {
            try await memoListViewModel.add(updatedMemo)
        } else {
            try await memoListViewModel.update(updatedMemo)
        }

        memo = updatedMemo
        isEditing = false
    }

    @MainActor
    func toggleComplete() async throws {
        let currentMemo = memo
        let updatedMemo = Memo(
            id: currentMemo.id,
            title: currentMemo.title,
            contents: currentMemo.contents,
            due: currentMemo.due,
            done: !currentMemo.done,
            createdAt: currentMemo.createdAt,
            updatedAt: Date()
        )

        try await memoListViewModel.update(updatedMemo)
        memo = updatedMemo
        isDone = updatedMemo.done // Keep UI in sync
    }

    @MainActor
    func delete() async throws {
        let currentMemo = memo
        try await memoListViewModel.delete(currentMemo.id)
    }

    @objc private func updateMemoDrating() {
        guard isNewMemo else { return }
        print("Function called every second...")
    }
}

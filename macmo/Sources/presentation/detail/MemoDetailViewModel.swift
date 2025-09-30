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
    @Published var isNewMemo = false
    @Published var isEditing = false

    // Editable properties
    @Published var title: String = ""
    @Published var contents: String = ""
    @Published var isDone: Bool = false
    @Published var dueDate: Date = Date() + 100
    @Published var hasDueDate: Bool = false

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(id: String?) {
        // Perform synchronous database fetch - SwiftData is fast for local operations
        if let id {
            memo = try? memoDAO.findById(id)
        }

        if memo == nil {
            memo = .init(title: "")
            Task { @MainActor in
                isNewMemo = true
                isEditing = true
            }
        }

        loadMemoData()
    }
    
    // Optimized initializer for existing memos to skip database lookup
    init(memo: Memo) {
        self.memo = memo
        loadMemoData()
    }

    private func loadMemoData() {
        guard let memo = memo else { return }

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
            id: memo?.id ?? UUID().uuidString,
            title: title,
            contents: contents.isEmpty ? nil : contents,
            due: hasDueDate ? dueDate : nil,
            done: isDone,
            createdAt: memo?.createdAt ?? Date(),
            updatedAt: Date()
        )

        if isNewMemo {
            try await store.add(updatedMemo)
        } else {
            try await store.update(updatedMemo)
        }

        memo = updatedMemo
        isEditing = false
    }
    
    @MainActor
    func toggleComplete() async throws {
        guard let currentMemo = memo else { return }

        let updatedMemo = Memo(
            id: currentMemo.id,
            title: currentMemo.title,
            contents: currentMemo.contents,
            due: currentMemo.due,
            done: !currentMemo.done,
            createdAt: currentMemo.createdAt,
            updatedAt: Date()
        )

        try await store.update(updatedMemo)
        memo = updatedMemo
        isDone = updatedMemo.done // Keep UI in sync
    }

    @MainActor
    func delete() async throws {
        guard let currentMemo = memo else { return }
        try await store.delete(currentMemo.id)
    }
}

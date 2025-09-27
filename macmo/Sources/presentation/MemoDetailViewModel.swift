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
        Task { @MainActor in
            if let id {
                memo = try? memoDAO.findById(id)
            }

            if memo == nil {
                memo = .init(title: "")
                isNewMemo = true
                isEditing = true
            }

            loadMemoData()
        }
    }

    @MainActor
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
    func startEditing() {
        isEditing = true
    }

    @MainActor
    func save() {
        guard canSave else { return }
        print(memo?.id)
        let updatedMemo = Memo(
            id: memo?.id ?? UUID().uuidString,
            title: title,
            contents: contents.isEmpty ? nil : contents,
            due: hasDueDate ? dueDate : nil,
            done: isDone,
            createdAt: memo?.createdAt ?? Date(),
            updatedAt: Date()
        )

        do {
            if isNewMemo {
                try store.add(updatedMemo)
            } else {
                try store.update(updatedMemo)
            }

            memo = updatedMemo
            isEditing = false
        } catch {
            print("Failed to save memo: \(error)")
        }
    }
}

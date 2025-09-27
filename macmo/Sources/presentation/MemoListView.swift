//
//  MemoListView.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import SwiftUI

struct MemoListView: View {
    @ObservedObject private var store = memoStore
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        NavigationSplitView {
            VStack {
                sortingPicker
                memoList
            }
            .navigationTitle("Memos")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        openWindow(id: "memo-detail")
                    }
                }
            }
            .onAppear {
                loadMemos()
            }
        } detail: {
            if let selectedMemoId = store.selectedMemoId {
                MemoDetailView(model: MemoDetailViewModel(id: selectedMemoId))
            }
        }
    }

    private var sortingPicker: some View {
        HStack {
            Picker("Sort by", selection: $store.sortBy) {
                Text("Created").tag(MemoSort.createdAt)
                Text("Updated").tag(MemoSort.updatedAt)
                Text("Due").tag(MemoSort.due)
            }
            .pickerStyle(SegmentedPickerStyle())

            Button(action: { store.ascending.toggle() }) {
                Image(systemName: store.ascending ? "arrow.up" : "arrow.down")
            }
        }
        .padding(.horizontal)
        .onChange(of: store.sortBy) { refreshMemos() }
        .onChange(of: store.ascending) { refreshMemos() }
    }

    private var memoList: some View {
        List(selection: $store.selectedMemoId) {
            ForEach(store.memos, id: \.id) { memo in
                MemoRowView(memo: memo)
                    .tag(memo.id)
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            do {
                                try store.delete(memo.id)
                            } catch {
                                print("Failed to delete memo: \(error)")
                            }
                        }
                    }
                    .onAppear {
                        if memo.id == store.memos.last?.id {
                            loadMoreMemos()
                        }
                    }
            }
            .onDelete(perform: deleteMemos)
        }
        .refreshable {
            refreshMemos()
        }
    }

    private func loadMemos() {
        do {
            try store.refreshMemos(store.sortBy, ascending: store.ascending)
        } catch {
            print("Failed to load memos: \(error)")
        }
    }

    private func refreshMemos() {
        do {
            try store.refreshMemos(store.sortBy, ascending: store.ascending)
        } catch {
            print("Failed to refresh memos: \(error)")
        }
    }

    private func loadMoreMemos() {
        do {
            try store.fetchMemos(store.sortBy, ascending: store.ascending)
        } catch {
            print("Failed to load more memos: \(error)")
        }
    }

    private func deleteMemos(offsets: IndexSet) {
        for index in offsets {
            let memo = store.memos[index]
            do {
                try store.delete(memo.id)
            } catch {
                print("Failed to delete memo: \(error)")
            }
        }
    }
}

struct MemoRowView: View {
    let memo: Memo

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(memo.title)
                    .font(.headline)
                    .strikethrough(memo.done)

                Spacer()

                if memo.done {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }

            if let contents = memo.contents, !contents.isEmpty {
                Text(contents)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            HStack {
                if let due = memo.due {
                    Text("Due: \(due, style: .date)")
                        .font(.caption2)
                        .foregroundColor(due < Date() ? .red : .blue)
                }

                Spacer()

                Text("Created: \(memo.createdAt, style: .date)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    MemoListView()
}


//
//  MemoListView.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import SwiftUI

struct MemoListView: View {
    @ObservedObject private var store = memoStore
    @State private var sortBy: MemoSort = .createdAt
    @State private var ascending: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                sortingPicker
                memoList
            }
            .navigationTitle("Memos")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        // TODO: Add new memo action
                    }
                }
            }
            .onAppear {
                loadMemos()
            }
        }
    }

    private var sortingPicker: some View {
        HStack {
            Picker("Sort by", selection: $sortBy) {
                Text("Created").tag(MemoSort.createdAt)
                Text("Updated").tag(MemoSort.updatedAt)
                Text("Due").tag(MemoSort.due)
            }
            .pickerStyle(SegmentedPickerStyle())

            Button(action: { ascending.toggle() }) {
                Image(systemName: ascending ? "arrow.up" : "arrow.down")
            }
        }
        .padding(.horizontal)
        .onChange(of: sortBy) { refreshMemos() }
        .onChange(of: ascending) { refreshMemos() }
    }

    private var memoList: some View {
        List {
            ForEach(store.memos, id: \.id) { memo in
                MemoRowView(memo: memo)
                    .onAppear {
                        if memo.id == store.memos.last?.id {
                            loadMoreMemos()
                        }
                    }
            }
        }
        .refreshable {
            refreshMemos()
        }
    }

    private func loadMemos() {
        do {
            try store.refreshMemos(sortBy, ascending: ascending)
        } catch {
            print("Failed to load memos: \(error)")
        }
    }

    private func refreshMemos() {
        do {
            try store.refreshMemos(sortBy, ascending: ascending)
        } catch {
            print("Failed to refresh memos: \(error)")
        }
    }

    private func loadMoreMemos() {
        do {
            try store.fetchMemos(sortBy, ascending: ascending)
        } catch {
            print("Failed to load more memos: \(error)")
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


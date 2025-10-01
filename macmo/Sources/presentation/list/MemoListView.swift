//
//  MemoListView.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import SwiftUI
import MarkdownUI
import Factory

struct MemoListView: View {
    @ObservedObject private var store = memoStore
    @Environment(\.openWindow) var openWindow

    var body: some View {
        NavigationSplitView {
            VStack {
                sortingPicker
                memoList
            }
            .navigationTitle("Memos")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        openWindow(id: "search-memo")
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }

                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        openWindow(id: "setting")
                    }) {
                        Image(systemName: "gear")
                    }
                }

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
        .task {
            if let result = try? await Container.shared.calendarService().requestAccess() {
                print(result)
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
                            Task {
                                try await store.delete(memo.id)
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
            Task {
                try await store.delete(memo.id)
            }
        }
    }
}

#Preview {
    MemoListView()
}


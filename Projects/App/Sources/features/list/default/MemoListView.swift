//
//  MemoListView.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Factory
import MarkdownUI
import SwiftUI
import MacmoDomain
import MacmoData

struct MemoListView: View {
    @ObservedObject private var model: MemoListViewModel = Container.shared.memoListViewModel()
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
                        openWindow(id: "calendar")
                    }) {
                        Image(systemName: "calendar")
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
                    Button {
                        openWindow(id: "memo-detail")
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                }

                ToolbarItem(placement: .secondaryAction) {
                    Button(action: {
                        try? model.refreshMemos()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .keyboardShortcut("r", modifiers: .command)
                }
            }
        } detail: {
            if let selectedMemoId = model.selectedMemoId {
                MemoDetailView(model: MemoDetailViewModel(id: selectedMemoId))
            }
        }
        .task {
            model.configInitialSetup()
            _ = try? await Container.shared.calendarService().requestAccess()
            loadMemos()
        }
    }

    private var sortingPicker: some View {
        HStack {
            SortingPicker(sortBy: $model.sortBy)

            Button(action: { model.ascending.toggle() }) {
                Image(systemName: model.ascending ? "arrow.up" : "arrow.down")
            }
        }
        .padding(.horizontal)
        .onChange(of: model.sortBy) { refreshMemos() }
        .onChange(of: model.ascending) { refreshMemos() }
    }

    private var memoList: some View {
        List(selection: $model.selectedMemoId) {
            ForEach(model.memos, id: \.id) { memo in
                MemoRowView(memo: memo)
                    .tag(memo.id)
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            Task {
                                try await model.delete(memo.id)
                            }
                        }
                    }
                    .onAppear {
                        if memo.id == model.memos.last?.id {
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
            try model.refreshMemos()
        } catch {
            print("Failed to load memos: \(error)")
        }
    }

    private func refreshMemos() {
        do {
            try model.refreshMemos()
        } catch {
            print("Failed to refresh memos: \(error)")
        }
    }

    private func loadMoreMemos() {
        do {
            try model.fetchMemos()
        } catch {
            print("Failed to load more memos: \(error)")
        }
    }

    private func deleteMemos(offsets: IndexSet) {
        for index in offsets {
            let memo = model.memos[index]
            Task {
                try await model.delete(memo.id)
            }
        }
    }
}

#Preview {
    MemoListView()
}

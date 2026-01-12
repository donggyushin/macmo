//
//  iOSMemoListView.swift
//  macmo
//
//  Created by 신동규 on 10/3/25.
//

import Factory
import SwiftUI
import MacmoDomain
import MacmoData

struct iOSMemoListView: View {
    @ObservedObject private var model: MemoListViewModel = Container.shared.memoListViewModel()
    @EnvironmentObject private var navigationManager: NavigationManager

    var body: some View {
        VStack {
            sortingPicker
            memoList
        }
        .navigationTitle("Memos")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    navigationManager.push(.search)
                }) {
                    Image(systemName: "magnifyingglass")
                }
            }

            ToolbarItem(placement: .navigation) {
                Button(action: {
                    navigationManager.push(.setting)
                }) {
                    Image(systemName: "gear")
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button {
                    navigationManager.push(.detail(nil, nil))
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
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
        List {
            ForEach(model.memos, id: \.id) { memo in
                MemoRowView(memo: memo)
                    .tag(memo.id)
                    .onAppear {
                        if memo.id == model.memos.last?.id {
                            loadMoreMemos()
                        }
                    }
                    .onTapGesture {
                        navigationManager.push(.detail(memo.id, nil))
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

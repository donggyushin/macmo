//
//  iOSMemoListView.swift
//  macmo
//
//  Created by 신동규 on 10/3/25.
//

import SwiftUI
import Factory

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
                    print("tap search")
                }) {
                    Image(systemName: "magnifyingglass")
                }
            }

            ToolbarItem(placement: .navigation) {
                Button(action: {
                    print("tap setting")
                }) {
                    Image(systemName: "gear")
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button("Add") {
                    navigationManager.push(.detail(nil))
                }
            }
        }
        .task {
            _ = try? await Container.shared.calendarService().requestAccess()
            loadMemos()
        }
    }
    
    private var sortingPicker: some View {
        HStack {
            Picker("Sort by", selection: $model.sortBy) {
                Text("Created").tag(MemoSort.createdAt)
                Text("Updated").tag(MemoSort.updatedAt)
                Text("Due").tag(MemoSort.due)
            }
            .pickerStyle(SegmentedPickerStyle())

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
                    .onAppear {
                        if memo.id == model.memos.last?.id {
                            loadMoreMemos()
                        }
                    }
                    .onTapGesture {
                        navigationManager.push(.detail(memo.id))
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
            try model.refreshMemos(model.sortBy, ascending: model.ascending)
        } catch {
            print("Failed to load memos: \(error)")
        }
    }

    private func refreshMemos() {
        do {
            try model.refreshMemos(model.sortBy, ascending: model.ascending)
        } catch {
            print("Failed to refresh memos: \(error)")
        }
    }

    private func loadMoreMemos() {
        do {
            try model.fetchMemos(model.sortBy, ascending: model.ascending)
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

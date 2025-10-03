//
//  SearchMemoView.swift
//  macmo
//
//  Created by 신동규 on 9/28/25.
//

import Foundation
import SwiftUI

struct SearchMemoView: View {

    @Environment(\.openWindow) private var openWindow
    @StateObject var model: SearchMemoViewModel
    @FocusState var focusSearchField

    var body: some View {
        NavigationSplitView {
            VStack {
                searchField
                searchResults
            }
            .navigationTitle("Search Memos")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Urgent") {
                        model.tapUrgentTag()
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("Uncompleted") {
                        model.tapUncompleted()
                    }
                }
            }
        } detail: {
            if let selectedMemoId = model.selectedMemoId {
                MemoDetailView(model: MemoDetailViewModel(id: selectedMemoId))
                    .onChangeAction {
                        model.update(selectedMemoId)
                    }
                    .onDeleteAction {
                        model.delete(selectedMemoId)
                    }
            } else {
                VStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("Search for memos")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Type urgent or uncompleted", text: $model.query)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($focusSearchField)
                .onAppear {
                    focusSearchField = true
                }
        }
        .padding(8)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(8)
        .padding(.horizontal)
    }

    private var searchResults: some View {
        List(selection: $model.selectedMemoId) {
            if model.query.isEmpty {
                VStack {
                    Image(systemName: "magnifyingglass.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("Enter search terms to find memos")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .listRowSeparator(.hidden)
            } else if model.memos.isEmpty {
                VStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No memos found")
                        .foregroundColor(.secondary)
                    Text("Try different search terms")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .listRowSeparator(.hidden)
            } else {
                ForEach(model.memos, id: \.id) { memo in
                    MemoRowView(memo: memo, query: model.query)
                        .tag(memo.id)
                        .onAppear {
                            if memo.id == model.memos.last?.id {
                                loadMoreResults()
                            }
                        }
                }
            }
        }
        .listStyle(PlainListStyle())
    }

    private func loadMoreResults() {
        do {
            try model.pagination()
        } catch {
            print("Failed to load more search results: \(error)")
        }
    }
}

#Preview {
    SearchMemoView(model: SearchMemoViewModel())
}

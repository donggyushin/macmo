//
//  iOSSearchMemoView.swift
//  macmo
//
//  Created by 신동규 on 10/3/25.
//

import SwiftUI

struct iOSSearchMemoView: View {
    @ObservedObject var model: SearchMemoViewModel
    @FocusState var focusSearchField
    @EnvironmentObject private var navigationManager: NavigationManager

    var body: some View {
        VStack {
            searchField
            SortingPicker(sortBy: $model.sortBy)
                .onChange(of: model.sortBy) { _, newValue in
                    model.setSortByValue(newValue)
                }
            searchResults
        }
        .navigationTitle("Search Memos")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Urgent") {
                    model.tapUrgentTag()
                    focusSearchField = false
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button("Uncompleted") {
                    model.tapUncompleted()
                    focusSearchField = false
                }
            }
        }
        .task {
            model.configureInitialSortBy()
        }
    }

    private var searchField: some View {
        SearchTextField(text: $model.query, focusState: $focusSearchField)
    }

    private var searchResults: some View {
        List {
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
                        .onTapGesture {
                            navigationManager.push(.detail(memo.id))
                        }
                }
            }
        }
        .listStyle(PlainListStyle())
        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(.hidden)
    }

    private func loadMoreResults() {
        do {
            try model.pagination()
        } catch {
            print("Failed to load more search results: \(error)")
        }
    }
}

private struct iOSSearchMemoViewPreview: View {
    @StateObject var model = SearchMemoViewModel()

    var body: some View {
        NavigationStack {
            iOSSearchMemoView(model: model)
                .environmentObject(NavigationManager())
        }
    }
}

#Preview {
    iOSSearchMemoViewPreview()
        .preferredColorScheme(.dark)
}

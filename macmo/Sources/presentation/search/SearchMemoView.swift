//
//  SearchMemoView.swift
//  macmo
//
//  Created by 신동규 on 9/28/25.
//

import Foundation
import SwiftUI

struct SearchMemoView: View {

    @StateObject var model: SearchMemoViewModel
    @Environment(\.openWindow) private var openWindow
    @FocusState var focusSearchField

    var body: some View {
        NavigationSplitView {
            VStack {
                searchField
                searchResults
            }
            .navigationTitle("Search Memos")
        } detail: {
            if let selectedMemoId = model.selectedMemoId {
                MemoDetailView(model: MemoDetailViewModel(id: selectedMemoId))
                    .onCompleteAction {
                        model.toggleComplete(selectedMemoId)
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

            TextField("Search memos...", text: $model.query)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($focusSearchField)
                .onAppear {
                    focusSearchField = true
                }
        }
        .padding(8)
        .background(Color(.controlBackgroundColor))
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
                    SearchMemoRowView(memo: memo, query: model.query)
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

struct SearchMemoRowView: View {
    let memo: Memo
    let query: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(highlightedText(memo.title, query: query))
                    .font(.headline)
                    .strikethrough(memo.done)

                Spacer()

                if memo.done {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }

            if let contents = memo.contents, !contents.isEmpty {
                Text(highlightedText(contents, query: query))
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

                Text("Updated: \(memo.updatedAt, style: .date)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    private func highlightedText(_ text: String, query: String) -> AttributedString {
        guard !query.isEmpty else {
            return AttributedString(text)
        }

        var attributed = AttributedString(text)
        let lowercaseText = text.lowercased()
        let lowercaseQuery = query.lowercased()

        var searchRange = lowercaseText.startIndex
        while searchRange < lowercaseText.endIndex,
              let range = lowercaseText.range(of: lowercaseQuery, range: searchRange..<lowercaseText.endIndex) {

            if let startIndex = AttributedString.Index(range.lowerBound, within: attributed),
               let endIndex = AttributedString.Index(range.upperBound, within: attributed) {
                let attributedRange = startIndex..<endIndex
                attributed[attributedRange].backgroundColor = .yellow.opacity(0.3)
                attributed[attributedRange].foregroundColor = .primary
            }

            searchRange = range.upperBound
        }

        return attributed
    }
}

#Preview {
    SearchMemoView(model: SearchMemoViewModel())
}

//
//  MemoRowView.swift
//  macmo
//
//  Created by 신동규 on 9/28/25.
//

import SwiftUI

struct MemoRowView: View {
    let memo: Memo
    let query: String?
    
    init(memo: Memo, query: String? = nil) {
        self.memo = memo
        self.query = query
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                
                if let query {
                    Text(highlightedText(memo.title, query: query))
                        .font(.headline)
                        .strikethrough(memo.done)
                } else {
                    Text(memo.title)
                        .font(.headline)
                        .strikethrough(memo.done)
                }
                
                Spacer()
                
                if memo.done {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if memo.isUrgent {
                    Text("URGENT")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .cornerRadius(4)
                }
            }

            if let contents = memo.contents, !contents.isEmpty {
                if let query {
                    Text(highlightedText(contents, query: query))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                } else {
                    Text(contents)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }

            HStack {
                if let due = memo.due {
                    Text("Due: \(due, style: .date)")
                        .font(.caption2)
                        .foregroundColor({
                            if memo.done {
                                return .green
                            } else {
                                return due < Date() ? .red : .blue
                            }
                        }())
                }

                Spacer()

                Text("Created: \(memo.createdAt, style: .date)")
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

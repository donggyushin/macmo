//
//  MemoRowView.swift
//  macmo
//
//  Created by 신동규 on 9/28/25.
//

import SwiftUI

struct MemoRowView: View {
    let memo: Memo

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(memo.title)
                    .font(.headline)
                    .strikethrough(memo.done)

                Spacer()

                if memo.isUrgent {
                    Text("URGENT")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .cornerRadius(4)
                }

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

import SwiftUI
import WidgetKit

struct MemoWidgetEntryView: View {
    var entry: MemoWidgetEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    var entry: MemoWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("dgmemo")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            if let firstMemo = entry.memos.first {
                Link(destination: URL(string: "macmo://memo/\(firstMemo.id)")!) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            if firstMemo.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                            if firstMemo.isUrgent {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(firstMemo.isOverDue ? .red : .orange)
                                    .font(.caption)
                            }
                            Text(firstMemo.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(2)
                                .foregroundStyle(firstMemo.isUrgent ? .red : .primary)
                        }

                        Text(firstMemo.content)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                }
            } else {
                Text("메모가 없습니다")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
    }
}

struct MediumWidgetView: View {
    var entry: MemoWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("dgmemo")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(entry.memos.count)개")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            if entry.memos.isEmpty {
                Spacer()
                Text("메모가 없습니다")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                ForEach(entry.memos.prefix(3)) { memo in
                    Link(destination: URL(string: "macmo://memo/\(memo.id)")!) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: memo.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(memo.isCompleted ? .green : .secondary)
                                .font(.caption)

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Text(memo.title)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .lineLimit(1)
                                        .foregroundStyle(memo.isUrgent ? .red : .primary)

                                    if memo.isUrgent {
                                        Image(systemName: "exclamationmark.circle.fill")
                                            .foregroundStyle(.red)
                                            .font(.caption2)
                                    }
                                }

                                Text(memo.content)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }

                            Spacer()
                        }
                    }
                }

                Spacer()
            }
        }
        .padding()
    }
}

#Preview(as: .systemSmall) {
    MemoWidget()
} timeline: {
    MemoWidgetEntry(
        date: Date(),
        memos: [
            MemoData(
                id: "sample",
                title: "샘플 메모",
                content: "위젯 미리보기",
                createdAt: Date(),
                isCompleted: false,
                due: Date()
            )
        ]
    )
}

#Preview(as: .systemMedium) {
    MemoWidget()
} timeline: {
    MemoWidgetEntry(
        date: Date(),
        memos: [
            MemoData(
                id: "memo1",
                title: "메모 1",
                content: "첫 번째 메모 내용",
                createdAt: Date(),
                isCompleted: false,
                due: Date()
            ),
            MemoData(
                id: "memo2",
                title: "메모 2",
                content: "두 번째 메모 내용",
                createdAt: Date(),
                isCompleted: true,
                due: Date()
            ),
            MemoData(
                id: "memo3",
                title: "메모 3",
                content: "세 번째 메모 내용",
                createdAt: Date(),
                isCompleted: false,
                due: Date()
            )
        ]
    )
}

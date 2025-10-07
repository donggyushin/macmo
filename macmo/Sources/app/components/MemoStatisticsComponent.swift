import SwiftUI

struct MemoStatisticsComponent: View {
    let statistics: MemoStatistics

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatisticCard(
                    title: "Total",
                    count: statistics.totalCount,
                    color: .blue
                )

                StatisticCard(
                    title: "Uncompleted",
                    count: statistics.uncompletedCount,
                    color: .orange
                )

                StatisticCard(
                    title: "Urgent",
                    count: statistics.urgentsCount,
                    color: .red
                )
            }

            SimpleBarChart(statistics: statistics)
        }
        .padding()
    }
}

private struct StatisticCard: View {
    let title: String
    let count: Int
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("\(count)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
        )
    }
}

private struct SimpleBarChart: View {
    let statistics: MemoStatistics

    private var completedCount: Int {
        statistics.totalCount - statistics.uncompletedCount
    }

    private var maxCount: Int {
        max(completedCount, statistics.uncompletedCount, statistics.urgentsCount, 1)
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Progress Overview")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .bottom, spacing: 20) {
                BarItem(
                    title: "Completed",
                    count: completedCount,
                    maxCount: maxCount,
                    color: .green
                )

                BarItem(
                    title: "Uncompleted",
                    count: statistics.uncompletedCount,
                    maxCount: maxCount,
                    color: .orange
                )

                BarItem(
                    title: "Urgent",
                    count: statistics.urgentsCount,
                    maxCount: maxCount,
                    color: .red
                )
            }
            .frame(height: 120)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

private struct BarItem: View {
    let title: String
    let count: Int
    let maxCount: Int
    let color: Color

    private var height: CGFloat {
        guard maxCount > 0 else { return 0 }
        return CGFloat(count) / CGFloat(maxCount) * 100
    }

    var body: some View {
        VStack(spacing: 8) {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 6)
                    .fill(color)
                    .frame(height: max(height, count > 0 ? 20 : 0))
            }

            Text("\(count)")
                .font(.caption.bold())
                .foregroundStyle(color)

            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MemoStatisticsComponent(
        statistics: MemoStatistics(
            totalCount: 42,
            uncompletedCount: 15,
            urgentsCount: 3
        )
    )
    .frame(width: 400)
}

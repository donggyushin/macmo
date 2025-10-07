import SwiftUI

struct MemoStatisticsComponent: View {
    let statistics: MemoStatistics

    var body: some View {
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

import SwiftUI

struct MemoStatisticsComponent: View {
    let statistics: MemoStatistics
    @State private var animationProgress: CGFloat = 0

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatisticCard(
                    title: "Total",
                    count: statistics.totalCount,
                    color: .blue,
                    animationProgress: animationProgress
                )

                StatisticCard(
                    title: "Uncompleted",
                    count: statistics.uncompletedCount,
                    color: .orange,
                    animationProgress: animationProgress
                )

                StatisticCard(
                    title: "Urgent",
                    count: statistics.urgentsCount,
                    color: .red,
                    animationProgress: animationProgress
                )
            }

            SimpleBarChart(statistics: statistics, animationProgress: animationProgress)
        }
        .padding()
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animationProgress = 1.0
            }
        }
    }
}

private struct StatisticCard: View {
    let title: String
    let count: Int
    let color: Color
    let animationProgress: CGFloat

    private var animatedCount: Int {
        Int(Double(count) * animationProgress)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("\(animatedCount)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(color)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1 * animationProgress))
        )
        .scaleEffect(animationProgress)
    }
}

private struct SimpleBarChart: View {
    let statistics: MemoStatistics
    let animationProgress: CGFloat

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
                    color: .green,
                    animationProgress: animationProgress
                )

                BarItem(
                    title: "Uncompleted",
                    count: statistics.uncompletedCount,
                    maxCount: maxCount,
                    color: .orange,
                    animationProgress: animationProgress
                )

                BarItem(
                    title: "Urgent",
                    count: statistics.urgentsCount,
                    maxCount: maxCount,
                    color: .red,
                    animationProgress: animationProgress
                )
            }
            .frame(height: 120)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.05))
        )
        .opacity(animationProgress)
    }
}

private struct BarItem: View {
    let title: String
    let count: Int
    let maxCount: Int
    let color: Color
    let animationProgress: CGFloat

    private var targetHeight: CGFloat {
        guard maxCount > 0 else { return 0 }
        return CGFloat(count) / CGFloat(maxCount) * 100
    }

    private var animatedHeight: CGFloat {
        max(targetHeight * animationProgress, count > 0 ? 20 : 0)
    }

    private var animatedCount: Int {
        Int(Double(count) * animationProgress)
    }

    var body: some View {
        VStack(spacing: 8) {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 6)
                    .fill(color)
                    .frame(height: animatedHeight)
            }

            Text("\(animatedCount)")
                .font(.caption.bold())
                .foregroundStyle(color)
                .contentTransition(.numericText())

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

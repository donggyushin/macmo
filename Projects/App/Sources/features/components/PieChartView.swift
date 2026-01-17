import SwiftUI
import MacmoDomain
import MacmoData

struct PieChartView: View {
    let statistics: MemoStatistics
    @State private var animationProgress: CGFloat = 0

    private var completedCount: Int {
        statistics.totalCount - statistics.uncompletedCount
    }

    private var chartData: [ChartSegment] {
        [
            ChartSegment(
                title: "Completed",
                count: completedCount,
                color: .green
            ),
            ChartSegment(
                title: "Uncompleted",
                count: statistics.uncompletedCount,
                color: .orange
            ),
            ChartSegment(
                title: "Urgent",
                count: statistics.urgentsCount,
                color: .red
            ),
        ].filter { $0.count > 0 }
    }

    private var total: Int {
        statistics.totalCount
    }

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Background circle
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 200, height: 200)

                // Pie segments
                ForEach(Array(chartData.enumerated()), id: \.offset) { index, segment in
                    PieSegmentShape(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        animationProgress: animationProgress
                    )
                    .fill(segment.color)
                }

                // Center white circle for donut effect
                #if os(iOS)
                    Circle()
                        .fill(Color(uiColor: .systemBackground))
                        .frame(width: 120, height: 120)
                #else
                    Circle()
                        .fill(Color(nsColor: .windowBackgroundColor))
                        .frame(width: 120, height: 120)
                #endif

                // Center text
                VStack(spacing: 4) {
                    Text("\(total)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 200, height: 200)

            // Legend
            VStack(alignment: .leading, spacing: 8) {
                ForEach(chartData, id: \.title) { segment in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(segment.color)
                            .frame(width: 12, height: 12)

                        Text(segment.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text("\(segment.count)")
                            .font(.caption.bold())
                            .foregroundStyle(segment.color)

                        Text("(\(percentage(for: segment))%)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animationProgress = 1.0
            }
        }
    }

    private func startAngle(for index: Int) -> Angle {
        let previousSegments = chartData.prefix(index)
        let previousSum = previousSegments.reduce(0) { $0 + $1.count }
        let ratio = Double(previousSum) / Double(total)
        return .degrees(ratio * 360 - 90) // -90 to start from top
    }

    private func endAngle(for index: Int) -> Angle {
        let segmentsUpToIndex = chartData.prefix(index + 1)
        let sum = segmentsUpToIndex.reduce(0) { $0 + $1.count }
        let ratio = Double(sum) / Double(total)
        return .degrees(ratio * 360 - 90)
    }

    private func percentage(for segment: ChartSegment) -> Int {
        guard total > 0 else { return 0 }
        return Int(round(Double(segment.count) / Double(total) * 100))
    }
}

private struct ChartSegment {
    let title: String
    let count: Int
    let color: Color
}

private struct PieSegmentShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    var animationProgress: CGFloat

    var animatableData: CGFloat {
        get { animationProgress }
        set { animationProgress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        let actualEndAngle = Angle(
            degrees: startAngle.degrees + (endAngle.degrees - startAngle.degrees) * Double(animationProgress)
        )

        var path = Path()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: actualEndAngle,
            clockwise: false
        )
        path.closeSubpath()

        return path
    }
}

#Preview {
    PieChartView(
        statistics: MemoStatistics(
            totalCount: 42,
            uncompletedCount: 15,
            urgentsCount: 3
        )
    )
    .frame(width: 400)
    .padding()
}

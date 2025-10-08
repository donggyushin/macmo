import WidgetKit
import SwiftUI

@main
struct MemoWidget: Widget {
    let kind: String = "MemoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MemoWidgetProvider()) { entry in
            MemoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("dgmemo")
        .description("최근 메모를 빠르게 확인하세요")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

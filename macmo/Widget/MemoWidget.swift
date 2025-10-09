import SwiftUI
import WidgetKit

@main
struct MemoWidget: Widget {
    let kind: String = "MemoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MemoWidgetProvider()) { entry in
            MemoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("dgmemo")
        .description("Check recent memos quickly")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

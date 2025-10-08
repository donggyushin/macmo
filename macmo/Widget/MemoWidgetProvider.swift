import SwiftUI
import WidgetKit

struct MemoWidgetEntry: TimelineEntry {
    let date: Date
    let memos: [MemoData]
}

struct MemoWidgetProvider: TimelineProvider {
    let memoRepository = ServiceLocator.shared.memoRepository
    func placeholder(in _: Context) -> MemoWidgetEntry {
        let memos = (try? memoRepository.get()) ?? []

        if !memos.isEmpty {
            return MemoWidgetEntry(
                date: Date(),
                memos: memos
            )
        } else {
            return MemoWidgetEntry(
                date: Date(),
                memos: [
                    MemoData(
                        id: "sample",
                        title: "샘플 메모",
                        content: "위젯에서 최근 메모를 확인할 수 있습니다",
                        createdAt: Date(),
                        isCompleted: false
                    ),
                ]
            )
        }
    }

    func getSnapshot(in context: Context, completion: @escaping (MemoWidgetEntry) -> Void) {
        let entry = placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<MemoWidgetEntry>) -> Void) {
        // TODO: MemoRepository를 통해 실제 메모 데이터 가져오기
        // 현재는 샘플 데이터 사용
        let currentDate = Date()
        let memos = (try? memoRepository.get()) ?? []

        let entry = MemoWidgetEntry(date: currentDate, memos: memos)

        // 15분마다 업데이트
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))

        completion(timeline)
    }
}

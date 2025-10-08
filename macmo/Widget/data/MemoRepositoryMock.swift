
import Foundation

public final class MemoRepositoryMock: MemoRepository {
    public func get() throws -> [MemoData] {
        let currentDate = Date()

        return [
            MemoData(
                id: "sample1",
                title: "샘플 메모 1",
                content: "첫 번째 메모 내용",
                createdAt: currentDate,
                isCompleted: false
            ),
            MemoData(
                id: "sample2",
                title: "샘플 메모 2",
                content: "두 번째 메모 내용",
                createdAt: currentDate.addingTimeInterval(-3600),
                isCompleted: true
            ),
        ]
    }

    public func getPlaceholder() throws -> [MemoData] {
        return [
            MemoData(
                id: "sample",
                title: "샘플 메모",
                content: "위젯에서 최근 메모를 확인할 수 있습니다",
                createdAt: Date(),
                isCompleted: false
            ),
        ]
    }
}

import Foundation
import MacmoDomain

public final class UserPreferenceRepositoryMock: UserPreferenceRepository {
    private var memoSortCache: MemoSort = .updatedAt
    private var ascendingCache: Bool = false
    private var statisticsEnum: StatisticsEnum = .chart
    private var memoSortCacheInSearch: MemoSort = .updatedAt
    private var memoSearchQuery = ""
    private var selectedMemoId = ""
    private var memoDraft: Memo = .init(
        id: UUID().uuidString,
        title: "",
        contents: nil,
        due: nil,
        done: false,
        eventIdentifier: nil,
        createdAt: Date(),
        updatedAt: Date(),
        images: []
    )

    public init() {}

    public func getMemoDraft() -> Memo {
        memoDraft
    }

    public func setMemoDraft(_ memo: Memo) {
        memoDraft = memo
    }

    public func getMemoSort() -> MemoSort {
        return memoSortCache
    }

    public func setMemoSort(_ sort: MemoSort) {
        memoSortCache = sort
    }

    public func getAscending() -> Bool {
        ascendingCache
    }

    public func setAscending(_ ascending: Bool) {
        ascendingCache = ascending
    }

    public func setStatistics(_ statisticsEnum: StatisticsEnum) {
        self.statisticsEnum = statisticsEnum
    }

    public func getStatistics() -> StatisticsEnum {
        statisticsEnum
    }

    public func getMemoSortCacheInSearch() -> MemoSort {
        memoSortCacheInSearch
    }

    public func setMemoSortCacheInSearch(_ sort: MemoSort) {
        memoSortCacheInSearch = sort
    }

    public func setMemoSearchQuery(_ query: String) {
        memoSearchQuery = query
    }

    public func getMemoSearchQuery() -> String {
        memoSearchQuery
    }

    public func getSelectedMemoId() -> String? {
        if !selectedMemoId.isEmpty {
            return selectedMemoId
        } else {
            return nil
        }
    }

    public func setSelectedMemoId(_ id: String?) {
        if let id {
            selectedMemoId = id
        } else {
            selectedMemoId = ""
        }
    }
}

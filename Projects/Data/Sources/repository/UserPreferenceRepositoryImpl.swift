import Foundation
import MacmoDomain

public final class UserPreferenceRepositoryImpl: UserPreferenceRepository {
    @UserDefault(key: "memo-sort", defaultValue: MemoSort.createdAt) var memoSortCache
    @UserDefault(key: "ascending", defaultValue: false) var ascendingCache
    @UserDefault(key: "statistics-enum", defaultValue: StatisticsEnum.chart) var statisticsEnum
    @UserDefault(key: "memo-sort-in-search", defaultValue: MemoSort.due) var memoSortCacheInSearch
    @UserDefault(key: "memo-search-query", defaultValue: "") var memoSearchQuery
    @UserDefault(key: "selected-memo-id", defaultValue: "") var selectedMemoId
    @UserDefault(
        key: "memo-draft",
        defaultValue: Memo(title: "")
    ) var memoDraft
    @UserDefault(key: "appTabEnum", defaultValue: AppTabEnum.calendar) var appTabEnum

    public init() {}

    public func getAppTabEnum() -> AppTabEnum {
        appTabEnum
    }

    public func setAppTabEnum(_ tab: AppTabEnum) {
        appTabEnum = tab
    }

    public func getMemoDraft() -> Memo {
        var memoDraft = memoDraft
        memoDraft.createdAt = .init()
        memoDraft.updatedAt = .init()
        return memoDraft
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

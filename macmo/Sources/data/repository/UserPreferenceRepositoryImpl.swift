public final class UserPreferenceRepositoryImpl: UserPreferenceRepository {
    @UserDefault(key: "memo-sort", defaultValue: MemoSort.createdAt) var memoSortCache
    @UserDefault(key: "ascending", defaultValue: false) var ascendingCache
    @UserDefault(key: "statistics-enum", defaultValue: StatisticsEnum.chart) var statisticsEnum
    @UserDefault(key: "memo-sort-in-search", defaultValue: MemoSort.due) var memoSortCacheInSearch

    public init() {}

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
}

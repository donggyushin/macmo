public final class UserPreferenceRepositoryMock: UserPreferenceRepository {
    private var memoSortCache: MemoSort = .updatedAt
    private var ascendingCache: Bool = false
    private var statisticsEnum: StatisticsEnum = .chart
    private var memoSortCacheInSearch: MemoSort = .updatedAt
    private var memoSearchQuery = ""

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

    public func setMemoSearchQuery(_ query: String) {
        memoSearchQuery = query
    }

    public func getMemoSearchQuery() -> String {
        memoSearchQuery
    }
}

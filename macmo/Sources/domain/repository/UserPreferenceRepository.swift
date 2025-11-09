public protocol UserPreferenceRepository {
    func getMemoSort() -> MemoSort
    func setMemoSort(_ sort: MemoSort)
    func getAscending() -> Bool
    func setAscending(_ ascending: Bool)
    func setStatistics(_ statisticsEnum: StatisticsEnum)
    func getStatistics() -> StatisticsEnum
    func getMemoSortCacheInSearch() -> MemoSort
    func setMemoSortCacheInSearch(_ sort: MemoSort)
    func setMemoSearchQuery(_ query: String)
    func getMemoSearchQuery() -> String
}

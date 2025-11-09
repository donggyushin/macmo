public protocol UserPreferenceRepository {
    func getMemoSort() -> MemoSort
    func setMemoSort(_ sort: MemoSort)
    func getAscending() -> Bool
    func setAscending(_ ascending: Bool)
    func getStatistics() -> StatisticsEnum
    func setStatistics(_ statisticsEnum: StatisticsEnum)
    func getMemoSortCacheInSearch() -> MemoSort
    func setMemoSortCacheInSearch(_ sort: MemoSort)
    func getMemoSearchQuery() -> String
    func setMemoSearchQuery(_ query: String)
    func getSelectedMemoId() -> String?
    func setSelectedMemoId(_ id: String?)
}

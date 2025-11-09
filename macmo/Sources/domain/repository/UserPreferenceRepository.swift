public protocol UserPreferenceRepository {
    func getMemoSort() -> MemoSort
    func setMemoSort(_ sort: MemoSort)
    func getAscending() -> Bool
    func setAscending(_ ascending: Bool)
    func setStatistics(_ statisticsEnum: StatisticsEnum)
    func getStatistics() -> StatisticsEnum
}

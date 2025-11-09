public protocol UserPreferenceRepository {
    func getMemoSort() -> MemoSort
    func setMemoSort(_ sort: MemoSort)
    func getAscending() -> Bool
    func setAscending(_ ascending: Bool)
}

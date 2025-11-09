public final class UserPreferenceRepositoryImpl: UserPreferenceRepository {
    @UserDefault(key: "memo-sort", defaultValue: MemoSort.createdAt) var memoSortCache
    @UserDefault(key: "ascending", defaultValue: false) var ascendingCache

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
}

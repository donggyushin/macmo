public final class UserPreferenceRepositoryMock: UserPreferenceRepository {
    private var memoSortCache: MemoSort = .updatedAt
    private var ascendingCache: Bool = false

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

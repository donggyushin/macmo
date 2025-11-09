public final class UserPreferenceRepositoryMock: UserPreferenceRepository {
    private var memoSortCache: MemoSort = .updatedAt

    public init() {}

    public func getMemoSort() -> MemoSort {
        return memoSortCache
    }

    public func setMemoSort(_ sort: MemoSort) {
        memoSortCache = sort
    }
}

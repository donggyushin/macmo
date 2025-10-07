

import Foundation

public struct MemoStatistics {
    public let totalCount: Int
    public let uncompletedCount: Int
    public let urgentsCount: Int

    public init(
        totalCount: Int,
        uncompletedCount: Int,
        urgentsCount: Int
    ) {
        self.totalCount = totalCount
        self.uncompletedCount = uncompletedCount
        self.urgentsCount = urgentsCount
    }
}

import Foundation

public struct ImageAttachment: Equatable {
    public let id: String
    public let imageData: Data
    public let order: Int
    public let createdAt: Date

    public init(
        id: String = UUID().uuidString,
        imageData: Data,
        order: Int,
        createdAt: Date
    ) {
        self.id = id
        self.imageData = imageData
        self.order = order
        self.createdAt = createdAt
    }
}

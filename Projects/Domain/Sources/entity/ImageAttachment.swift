import Foundation

public struct ImageAttachment {
    public let id: String
    public let imageData: Data
    public let order: Int
    public let createdAt: Date

    public init(
        id: String,
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

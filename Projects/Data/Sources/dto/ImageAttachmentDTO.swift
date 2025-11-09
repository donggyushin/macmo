import Foundation
import MacmoDomain

public struct ImageAttachmentDTO: Codable {
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

    public init(from domain: ImageAttachment) {
        self.id = domain.id
        self.imageData = domain.imageData
        self.order = domain.order
        self.createdAt = domain.createdAt
    }

    public var domain: ImageAttachment {
        return .init(id: id, imageData: imageData, order: order, createdAt: createdAt)
    }
}

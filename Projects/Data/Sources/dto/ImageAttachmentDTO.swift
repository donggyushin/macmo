import Foundation
import MacmoDomain
import SwiftData

@Model
public final class ImageAttachmentDTO {
    @Attribute(.unique) public var id: String

    // External Storage를 사용하여 큰 이미지 파일을 효율적으로 저장
    @Attribute(.externalStorage) public var imageData: Data
    public var order: Int
    public var createdAt: Date

    // MemoDTO와의 관계
    public var memo: MemoDTO?

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

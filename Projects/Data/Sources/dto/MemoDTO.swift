//
//  MemoDTO.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import MacmoDomain
import SwiftData

@Model
public class MemoDTO {
    public var id: String = ""
    public var title: String = ""
    public var contents: String?
    public var due: Date?
    public var done: Bool = false
    public var eventIdentifier: String?
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()
    // ✅ 이미지 관계 추가 - cascade delete로 메모 삭제 시 이미지도 자동 삭제
    // CloudKit requires all relationships to be optional
    @Relationship(deleteRule: .cascade, inverse: \ImageAttachmentDTO.memo)
    public var images: [ImageAttachmentDTO]?

    public init(
        id: String = "",
        title: String = "",
        contents: String? = nil,
        due: Date? = nil,
        done: Bool = false,
        eventIdentifier: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        images: [ImageAttachmentDTO]? = nil
    ) {
        self.id = id
        self.title = title
        self.contents = contents
        self.due = due
        self.done = done
        self.eventIdentifier = eventIdentifier
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.images = images
    }
}

public extension MemoDTO {
    func toDomain() -> Memo {
        return Memo(
            id: id,
            title: title,
            contents: contents,
            due: due,
            done: done,
            eventIdentifier: eventIdentifier,
            createdAt: createdAt,
            updatedAt: updatedAt,
            images: images?.map { $0.domain } ?? []
        )
    }

    static func fromDomain(_ memo: Memo) -> MemoDTO {
        return MemoDTO(
            id: memo.id,
            title: memo.title,
            contents: memo.contents,
            due: memo.due,
            done: memo.done,
            eventIdentifier: memo.eventIdentifier,
            createdAt: memo.createdAt,
            updatedAt: memo.updatedAt,
            images: memo.images.isEmpty ? nil : memo.images.map { .init(from: $0) }
        )
    }
}


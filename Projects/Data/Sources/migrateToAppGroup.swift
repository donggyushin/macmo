//
//  migrateToAppGroup.swift
//  MacmoData
//
//  Created by 신동규 on 1/17/26.
//

import Foundation
import MacmoDomain

public func migrateToAppGroup() throws {
    let fileManager = FileManager.default

    // 기존 위치
    guard let oldURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { throw AppError.notFound }
    guard let newURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.dev.tuist.macmo") else { throw AppError.notFound }

    let dbFileName = "default.store" // SwiftData 기본 파일명
    let oldDB = oldURL.appendingPathComponent(dbFileName)
    let newDB = newURL.appendingPathComponent(dbFileName)

    // 새 위치에 파일이 없고, 기존 파일이 있으면 복사
    if !fileManager.fileExists(atPath: newDB.path),
       fileManager.fileExists(atPath: oldDB.path)
    {
        try fileManager.copyItem(at: oldDB, to: newDB)
    }
}


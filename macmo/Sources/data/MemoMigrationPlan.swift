//
//  MemoMigrationPlan.swift
//  macmo
//
//  Created by Claude on 9/30/25.
//

import Foundation
import SwiftData

enum MemoMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [MemoSchemaV1.self, MemoSchemaV2.self]
    }

    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }

    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: MemoSchemaV1.self,
        toVersion: MemoSchemaV2.self
    )
}
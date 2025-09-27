//
//  Dependencies.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import Factory
import SwiftData

extension Container {
    var modelContainer: Factory<ModelContainer> {
        self {
            do {
                let container = try ModelContainer(
                    for: MemoDTO.self,
                    configurations: ModelConfiguration(
                        cloudKitContainerIdentifier: "iCloud.dev.tuist.macmo"
                    )
                )
                return container
            } catch {
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
        .singleton
    }

    var modelContext: Factory<ModelContext> {
        self {
            let container = self.modelContainer()
            return ModelContext(container)
        }
    }

    var memoDAO: Factory<MemoDAOProtocol> {
        self {
            MemoDAO(modelContext: self.modelContext())
        }
        .onPreview {
            MockMemoDAO.withSampleData()
        }
        .singleton
    }
}

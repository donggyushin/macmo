//
//  Dependencies.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Factory
import Foundation
import SwiftData

// MARK: - Register Data layer instances

extension Container {
    var modelContainer: Factory<ModelContainer> {
        self {
            do {
                let configuration: ModelConfiguration

                if let appGroupURL = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.dev.tuist.macmo")?
                    .appendingPathComponent("default.store")
                {
                    configuration = ModelConfiguration(
                        url: appGroupURL,
                        cloudKitDatabase: .automatic
                    )
                } else {
                    configuration = ModelConfiguration(
                        cloudKitDatabase: .automatic
                    )
                }

                let container = try ModelContainer(
                    for: MemoDTO.self,
                    configurations: configuration
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

    var memoDAO: Factory<MemoDAO> {
        self {
            MemoDAOImpl(modelContext: self.modelContext())
        }
        .onPreview {
            MemoDAOMock.withSampleData()
        }
        .onTest {
            MemoDAOMock.withSampleData()
        }
        .singleton
    }

    var memoRepository: Factory<MemoRepository> {
        self {
            MemoRepositoryImpl(memoDAO: self.memoDAO())
        }
        .singleton
    }

    var calendarService: Factory<CalendarServiceProtocol> {
        self {
            CalendarService()
        }
        .onPreview {
            MockCalendarService()
        }
        .onTest {
            MockCalendarService()
        }
        .singleton
    }
}

// MARK: - Register Domain layer instances

extension Container {
    var memoUseCase: Factory<MemoUseCase> {
        self {
            MemoUseCase(memoRepository: self.memoRepository(), calendarService: self.calendarService())
        }
        .singleton
    }
}

// MARK: - Register App instances

extension Container {
    var memoListViewModel: Factory<MemoListViewModel> {
        self {
            MemoListViewModel()
        }
        .singleton
    }
}

//
//  Dependencies.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import Factory
import SwiftData

// MARK: - Register Data layer instances
extension Container {
    var modelContainer: Factory<ModelContainer> {
        self {
            do {
                let configuration = ModelConfiguration(
                    cloudKitDatabase: .automatic
                )
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

    var memoDAO: Factory<MemoDAOProtocol> {
        self {
            MemoDAO(modelContext: self.modelContext())
        }
        .onPreview {
            MockMemoDAO.withSampleData()
        }
        .singleton
    }
    
    var memoRepository: Factory<MemoRepositoryProtocol> {
        self {
            MemoRepository(memoDAO: self.memoDAO())
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

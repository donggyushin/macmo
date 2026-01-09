//
//  Dependencies.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Factory
import Foundation
import MacmoData
import MacmoDomain
import SwiftData

// MARK: - Register Data layer instances

extension Container {
    private var modelContainer: Factory<ModelContainer> {
        self {
            do {
                let configuration: ModelConfiguration

                if let appGroupURL = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.dev.tuist.macmo")?
                    .appendingPathComponent("default.store") {
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
                    for: MemoDTO.self, ImageAttachmentDTO.self,
                    configurations: configuration
                )

                return container
            } catch {
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
        .singleton
    }

    private var modelContext: Factory<ModelContext> {
        self {
            let container = self.modelContainer()
            return ModelContext(container)
        }
    }

    private var calendarDAO: Factory<CalendarDAO> {
        self {
            CalendarDAOImpl(modelContext: self.modelContext())
        }
        .onPreview {
            CalendarDAOMock()
        }
        .onTest {
            CalendarDAOMock()
        }
    }

    private var memoDAO: Factory<MemoDAO> {
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

    var calendarRepository: Factory<CalendarRepository> {
        self {
            CalendarRepositoryImpl(dao: self.calendarDAO())
        }
        .singleton
    }

    var userPreferenceRepository: Factory<UserPreferenceRepository> {
        self {
            UserPreferenceRepositoryImpl()
        }
        .onPreview {
            UserPreferenceRepositoryMock()
        }
        .onTest {
            UserPreferenceRepositoryMock()
        }
        .singleton
    }

    var calendarService: Factory<CalendarService> {
        self {
            CalendarServiceImpl()
        }
        .onPreview {
            CalendarServiceMock()
        }
        .onTest {
            CalendarServiceMock()
        }
        .singleton
    }

    var navigationService: Factory<NavigationService> {
        self {
            NavigationServiceImpl()
        }
        .singleton
    }

    var pushNotificationService: Factory<PushNotificationService> {
        self {
            PushNotificationServiceImpl()
        }
        .onPreview {
            PushNotificationServiceMock()
        }
        .onTest {
            PushNotificationServiceMock()
        }
        .singleton
    }
}

// MARK: - Register Domain layer instances

extension Container {
    var memoUseCase: Factory<MemoUseCase> {
        self {
            MemoUseCase(
                memoRepository: self.memoRepository(),
                calendarService: self.calendarService(),
                pushNotificationService: self.pushNotificationService()
            )
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

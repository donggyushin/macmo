//
//  SettingViewModel.swift
//  macmo
//
//  Created by 신동규 on 10/1/25.
//

import Combine
import Factory
import Foundation

final class SettingViewModel: ObservableObject {
    @Published var isCalendarSyncEnabled = true
    @Published var memoStatistics: MemoStatistics = .init(totalCount: 0, uncompletedCount: 0, urgentsCount: 0)

    @Injected(\.calendarService) var calendarService
    @Injected(\.memoRepository) var memoRepository

    private var cancellables = Set<AnyCancellable>()

    init() {
        isCalendarSyncEnabled = calendarService.isCalendarSyncEnabled
        bind()
    }

    @MainActor
    func fetchMemoStatistics() {
        memoStatistics = memoRepository.getMemoStatics()
    }

    @MainActor
    func configIsCalendarSyncEnabled() async throws {
        let requestAccess = try await calendarService.requestAccess()

        guard requestAccess else {
            isCalendarSyncEnabled = false
            return
        }

        isCalendarSyncEnabled = calendarService.isCalendarSyncEnabled
    }

    private func bind() {
        cancellables.removeAll()

        $isCalendarSyncEnabled
            .removeDuplicates()
            .sink { [weak self] isCalendarSyncEnabled in
                if isCalendarSyncEnabled != self?.calendarService.isCalendarSyncEnabled {
                    self?.calendarService.isCalendarSyncEnabled = isCalendarSyncEnabled
                }
            }
            .store(in: &cancellables)
    }
}

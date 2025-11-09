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
    @Published var selectedStatistics = StatisticsEnum.chart

    @Injected(\.calendarService) var calendarService
    @Injected(\.memoRepository) var memoRepository
    @Injected(\.userPreferenceRepository) var userPreferenceRepository

    private var cancellables = Set<AnyCancellable>()

    init() {
        self.isCalendarSyncEnabled = calendarService.isCalendarSyncEnabled
        bind()
    }

    @MainActor
    func tapChart() {
        switch selectedStatistics {
        case .bar:
            selectedStatistics = .chart
        case .chart:
            selectedStatistics = .bar
        }
    }

    @MainActor
    func fetchSelectedStatistics() {
        selectedStatistics = userPreferenceRepository.getStatistics()
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

        $selectedStatistics
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] statistics in
                self?.userPreferenceRepository.setStatistics(statistics)
            }
            .store(in: &cancellables)

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

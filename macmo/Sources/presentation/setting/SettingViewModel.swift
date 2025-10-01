//
//  SettingViewModel.swift
//  macmo
//
//  Created by 신동규 on 10/1/25.
//

import Foundation
import Combine
import Factory

final class SettingViewModel: ObservableObject {
    
    @Published var isCalendarSyncEnabled = true
    
    @Injected(\.calendarService) var calendarService
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        isCalendarSyncEnabled = calendarService.isCalendarSyncEnabled
        bind()
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

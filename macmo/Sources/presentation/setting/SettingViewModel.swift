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
    
    @Injected(\.calendarService) private var calendarService
    
    init() {
        isCalendarSyncEnabled = calendarService.isCalendarSyncEnabled
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
}

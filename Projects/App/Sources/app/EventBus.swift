//
//  EventBus.swift
//  macmo
//
//  Created by 신동규 on 2/1/26.
//

import Combine

final class EventBus {
    static let shared = EventBus()
    
    let detailWindowDismissed = PassthroughSubject<Void, Never>()
    
    private init() {}
}

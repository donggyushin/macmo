//
//  Coordinator.swift
//  macmo
//
//  Created by 신동규 on 10/1/25.
//

import Foundation
import SwiftUI

public let coordinator = Coordinator.shared

public final class Coordinator {
    
    public static let shared = Coordinator()
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    private init() {}
    
    func openNewMemo() {
        openWindow(id: "memo-detail")
    }
    
    func openSearch() {
        openWindow(id: "search-memo")
    }
    
    func dismissNewMemo() {
        dismissWindow(id: "memo-detail")
    }
}

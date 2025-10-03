//
//  NavigationManager.swift
//  macmo
//
//  Created by 신동규 on 10/3/25.
//

import Foundation
import Combine

final class NavigationManager: ObservableObject {
    @Published var paths: [Navigation] = []
    
    @MainActor
    func push(_ path: Navigation) {
        paths.append(path)
    }
    
    @MainActor
    func pop() {
        guard !paths.isEmpty else { return }
        paths.removeLast()
    }
}

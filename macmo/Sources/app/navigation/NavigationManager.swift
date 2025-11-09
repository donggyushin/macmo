//
//  NavigationManager.swift
//  macmo
//
//  Created by 신동규 on 10/3/25.
//

import Combine
import Factory
import Foundation

final class NavigationManager: ObservableObject {
    @Published var paths: [Navigation] = []
    @Injected(\.memoRepository) private var memoRepository

    init() {
        bind()
    }

    @MainActor
    func push(_ path: Navigation) {
        paths.append(path)
    }

    @MainActor
    func pop() {
        guard !paths.isEmpty else { return }
        paths.removeLast()
    }

    private func bind() {}
}

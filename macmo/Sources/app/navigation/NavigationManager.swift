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
    @Injected(\.navigationService) private var navigationService
    private var cancellables = Set<AnyCancellable>()

    @MainActor
    func push(_ path: Navigation) {
        paths.append(path)
    }

    @MainActor
    func pop() {
        guard !paths.isEmpty else { return }
        paths.removeLast()
    }

    @MainActor func configIntitialSetup() {
        if paths.isEmpty {
            paths = navigationService.getNavigationForCache().map { .init($0) }
        }

        bind()
    }

    private func bind() {
        cancellables.removeAll()
        $paths
            .removeDuplicates()
            .sink { paths in
                self.navigationService.setNavigationForCache(paths.map { $0.domain })
            }
            .store(in: &cancellables)
    }
}

//
//  SearchMemoViewModel.swift
//  macmo
//
//  Created by 신동규 on 9/28/25.
//

import Foundation
import Combine
import Factory

final class SearchMemoViewModel: ObservableObject {
    
    @Injected(\.memoDAO) private var memoDAO
    
    @Published var memos: [Memo] = []
    @Published var query = ""
    private var previousSearchQuery = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    private func bind() {
        $query
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                Task {
                    try await self?.search(query)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func search(_ query: String) throws {
        let result = try memoDAO.search(query: query, cursorId: nil, limit: 100)
        self.memos = result
    }
    
    @MainActor
    func pagination() throws {
        let result = try memoDAO.search(query: query, cursorId: memos.last?.id, limit: 100)
        self.memos.append(contentsOf: result)
    }
}

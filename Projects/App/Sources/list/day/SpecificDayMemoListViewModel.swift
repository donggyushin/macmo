//
//  SpecificDayMemoListViewModel.swift
//  macmo
//
//  Created by ratel on 1/12/26.
//

import Combine
import Factory
import Foundation
import MacmoDomain

final class SpecificDayMemoListViewModel: ObservableObject {
    @Injected(\.memoRepository) private var memoRepository
    @Published var memos: [Memo] = []

    let date: Date
    init(date: Date) {
        self.date = date
    }

    @MainActor func fetchMemos() throws {
        memos = try memoRepository.findByDate(date)
    }
}

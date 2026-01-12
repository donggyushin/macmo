//
//  CalendarDAOImpl.swift
//  MacmoData
//
//  Created by ratel on 1/9/26.
//

import Foundation
import MacmoDomain
import SwiftData

public final class CalendarDAOImpl: CalendarDAO {
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func find(year: Int, month: Int) throws -> [CalendarDay] {
        // 1. 해당 월의 시작일과 마지막일 계산
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        guard let startDate = Calendar.current.date(from: components) else {
            return []
        }

        // 다음 달의 시작일 (현재 달의 범위를 초과하지 않도록)
        guard let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) else {
            return []
        }

        // 2. due가 nil이 아닌 모든 메모를 가져옴
        // SwiftData Predicate의 optional 처리 제약으로 인해 Predicate 없이 fetch
        let descriptor = FetchDescriptor<MemoDTO>(
            sortBy: [SortDescriptor(\.due, order: .forward)]
        )

        let allDtos = try modelContext.fetch(descriptor)

        // 3. Swift 코드로 필터링 및 변환
        let calendarDays = allDtos.compactMap { dto -> CalendarDay? in
            guard let due = dto.due else { return nil }

            // 해당 월의 범위에 포함되는지 확인
            guard due >= startDate && due < endDate else { return nil }

            let components = Calendar.current.dateComponents([.year, .month, .day], from: due)
            guard let day = components.day else { return nil }

            return CalendarDay(
                year: year,
                month: month,
                day: day,
                memo: dto.toDomain()
            )
        }

        return calendarDays
    }
}

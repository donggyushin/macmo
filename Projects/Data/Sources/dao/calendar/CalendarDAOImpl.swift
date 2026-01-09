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

        // 2. due 날짜가 해당 월에 포함되는 메모들을 찾는 Predicate
        let predicate = #Predicate<MemoDTO> { memo in
            memo.due != nil && memo.due! >= startDate && memo.due! < endDate
        }

        // 3. FetchDescriptor 생성 및 쿼리 실행
        let descriptor = FetchDescriptor<MemoDTO>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.due, order: .forward)]
        )

        let dtos = try modelContext.fetch(descriptor)

        // 4. DTO를 CalendarDay로 변환
        let calendarDays = dtos.compactMap { dto -> CalendarDay? in
            guard let due = dto.due else { return nil }
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

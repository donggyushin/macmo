//
//  CalendarDAOMock.swift
//  MacmoData
//
//  Created by ratel on 1/9/26.
//

import Foundation
import MacmoDomain

public final class CalendarDAOMock: CalendarDAO {
    private var sampleMemos: [Memo]

    public init(sampleMemos: [Memo] = []) {
        self.sampleMemos = sampleMemos
    }

    public static func withSampleData() -> CalendarDAOMock {
        let now = Date()
        let calendar = Calendar.current

        // 현재 월의 다양한 날짜에 메모 생성
        var memos: [Memo] = []

        // 이번 달 5일에 메모
        if let date5 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 5, to: now) {
            memos.append(Memo(
                title: "팀 미팅",
                contents: "분기별 성과 리뷰",
                due: date5,
                done: false
            ))
        }

        // 이번 달 10일에 메모
        if let date10 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 10, to: now) {
            memos.append(Memo(
                title: "프로젝트 마감",
                contents: "최종 검토 및 제출",
                due: date10,
                done: true
            ))
        }

        // 이번 달 15일에 메모
        if let date15 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 15, to: now) {
            memos.append(Memo(
                title: "생일 파티",
                contents: "선물 준비하기",
                due: date15,
                done: false
            ))
        }

        // 이번 달 20일에 메모
        if let date20 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 20, to: now) {
            memos.append(Memo(
                title: "병원 예약",
                contents: "건강검진",
                due: date20,
                done: false
            ))
        }

        // 이번 달 25일에 메모
        if let date25 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 25, to: now) {
            memos.append(Memo(
                title: "월말 보고서",
                contents: "실적 정리 및 분석",
                due: date25,
                done: false
            ))
        }

        // 다음 달 3일에 메모
        if let nextMonth3 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + calendar.range(of: .day, in: .month, for: now)!.count + 3, to: now) {
            memos.append(Memo(
                title: "새 프로젝트 시작",
                contents: "킥오프 미팅",
                due: nextMonth3,
                done: false
            ))
        }

        return CalendarDAOMock(sampleMemos: memos)
    }

    public func find(year: Int, month: Int) throws -> [CalendarDay] {
        let calendar = Calendar.current

        // 해당 년월의 시작일과 종료일 계산
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        guard let startDate = calendar.date(from: components),
              let endDate = calendar.date(byAdding: .month, value: 1, to: startDate) else {
            return []
        }

        // sampleMemos에서 해당 년월에 해당하는 메모 필터링
        let calendarDays = sampleMemos.compactMap { memo -> CalendarDay? in
            guard let due = memo.due,
                  due >= startDate && due < endDate else {
                return nil
            }

            let components = calendar.dateComponents([.day], from: due)
            guard let day = components.day else {
                return nil
            }

            return CalendarDay(
                year: year,
                month: month,
                day: day,
                memo: memo
            )
        }

        // 날짜 순으로 정렬
        return calendarDays.sorted { $0.day < $1.day }
    }
}

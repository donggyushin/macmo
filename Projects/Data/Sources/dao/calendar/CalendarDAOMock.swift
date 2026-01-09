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

        let sampleTitles = [
            "팀 미팅", "프로젝트 마감", "생일 파티", "병원 예약", "월말 보고서",
            "운동 수업", "친구 약속", "책 읽기", "장보기", "청소하기",
            "회의 준비", "발표 자료 작성", "코드 리뷰", "디자인 검토"
        ]

        let sampleContents = [
            "분기별 성과 리뷰", "최종 검토 및 제출", "선물 준비하기", "건강검진",
            "실적 정리 및 분석", "요가 클래스", "카페에서 만나기", "자기계발서",
            "장바구니 체크", "집 정리", "안건 정리", "슬라이드 완성", "PR 리뷰",
            "UI/UX 피드백"
        ]

        // 이번 달 5일에 랜덤 개수(1~3개) 메모
        if let date5 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 5, to: now) {
            let count = Int.random(in: 1...3)
            for i in 0..<count {
                memos.append(Memo(
                    title: sampleTitles[i % sampleTitles.count],
                    contents: sampleContents[i % sampleContents.count],
                    due: date5,
                    done: Bool.random()
                ))
            }
        }

        // 이번 달 10일에 랜덤 개수(2~4개) 메모
        if let date10 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 10, to: now) {
            let count = Int.random(in: 2...4)
            for i in 0..<count {
                memos.append(Memo(
                    title: sampleTitles[(i + 3) % sampleTitles.count],
                    contents: sampleContents[(i + 3) % sampleContents.count],
                    due: date10,
                    done: Bool.random()
                ))
            }
        }

        // 이번 달 15일에 랜덤 개수(1~2개) 메모
        if let date15 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 15, to: now) {
            let count = Int.random(in: 1...2)
            for i in 0..<count {
                memos.append(Memo(
                    title: sampleTitles[(i + 6) % sampleTitles.count],
                    contents: sampleContents[(i + 6) % sampleContents.count],
                    due: date15,
                    done: Bool.random()
                ))
            }
        }

        // 이번 달 20일에 랜덤 개수(3~5개) 메모
        if let date20 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 20, to: now) {
            let count = Int.random(in: 3...5)
            for i in 0..<count {
                memos.append(Memo(
                    title: sampleTitles[(i + 8) % sampleTitles.count],
                    contents: sampleContents[(i + 8) % sampleContents.count],
                    due: date20,
                    done: Bool.random()
                ))
            }
        }

        // 이번 달 25일에 랜덤 개수(1개) 메모
        if let date25 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + 25, to: now) {
            memos.append(Memo(
                title: "월말 보고서",
                contents: "실적 정리 및 분석",
                due: date25,
                done: false
            ))
        }

        // 다음 달 3일에 랜덤 개수(4~6개) 메모
        if let nextMonth3 = calendar.date(byAdding: .day, value: -calendar.component(.day, from: now) + calendar.range(of: .day, in: .month, for: now)!.count + 3, to: now) {
            let count = Int.random(in: 4...6)
            for i in 0..<count {
                memos.append(Memo(
                    title: sampleTitles[(i + 11) % sampleTitles.count],
                    contents: sampleContents[(i + 11) % sampleContents.count],
                    due: nextMonth3,
                    done: Bool.random()
                ))
            }
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

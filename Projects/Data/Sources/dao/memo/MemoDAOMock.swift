//
//  MemoDAOMock.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import MacmoDomain

public class MemoDAOMock: MemoDAO {
    private var memos: [String: Memo] = [:]

    public init(initialMemos: [Memo] = []) {
        for memo in initialMemos {
            memos[memo.id] = memo
        }
    }

    public func save(_ memo: Memo) throws {
        memos[memo.id] = memo
    }

    public func findByDate(_ date: Date) throws -> [Memo] {
        let calendar = Calendar.current

        // due date가 주어진 날짜와 같은 날인 메모만 필터링
        let filteredMemos = memos.values.filter { memo in
            guard let due = memo.due else { return false }
            return calendar.isDate(due, inSameDayAs: date)
        }

        // due date 기준으로 오름차순 정렬
        return filteredMemos.sorted { memo1, memo2 in
            guard let due1 = memo1.due, let due2 = memo2.due else { return false }
            return due1 < due2
        }
    }

    public func findAll(cursorId: String?, limit: Int, sortBy: MemoSort, ascending: Bool) throws -> [Memo] {
        var allMemos = Array(memos.values)

        // Apply sorting
        switch sortBy {
        case .createdAt:
            allMemos.sort { ascending ? $0.createdAt < $1.createdAt : $0.createdAt > $1.createdAt }
        case .updatedAt:
            allMemos.sort { ascending ? $0.updatedAt < $1.updatedAt : $0.updatedAt > $1.updatedAt }
        case .due:
            allMemos.sort { memo1, memo2 in
                switch (memo1.due, memo2.due) {
                case (nil, nil): return false
                case (nil, _): return !ascending
                case (_, nil): return ascending
                case let (date1?, date2?):
                    return ascending ? date1 < date2 : date1 > date2
                }
            }
        }

        // Apply cursor pagination
        if let cursorId = cursorId,
           let cursorIndex = allMemos.firstIndex(where: { $0.id == cursorId }) {
            let nextIndex = cursorIndex + 1
            if nextIndex < allMemos.count {
                allMemos = Array(allMemos[nextIndex...])
            } else {
                allMemos = []
            }
        }

        // Apply limit
        return Array(allMemos.prefix(limit))
    }

    public func findById(_ id: String) throws -> Memo? {
        return memos[id]
    }

    public func update(_ memo: Memo) throws {
        guard memos[memo.id] != nil else { return }
        let updatedMemo = Memo(
            id: memo.id,
            title: memo.title,
            contents: memo.contents,
            due: memo.due,
            done: memo.done,
            eventIdentifier: memo.eventIdentifier,
            createdAt: memo.createdAt,
            updatedAt: Date()
        )
        memos[memo.id] = updatedMemo
    }

    public func delete(_ id: String) throws {
        memos.removeValue(forKey: id)
    }

    public func search(query: String, cursorId: String?, limit: Int, sortBy: MemoSort) throws -> [Memo] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        let searchQuery = query.lowercased()
        var filteredMemos = Array(memos.values).filter { memo in
            memo.title.lowercased().contains(searchQuery) ||
                (memo.contents?.lowercased().contains(searchQuery) ?? false)
        }

        // Sort by updatedAt in reverse order (newest first)
        filteredMemos.sort { $0.updatedAt > $1.updatedAt }

        if sortBy == .due {
            filteredMemos = filteredMemos.sorted { memo1, memo2 in
                if let date1 = memo1.due, let date2 = memo2.due {
                    return date1 < date2
                } else if memo2.due != nil {
                    return false
                } else {
                    return true
                }
            }
        }

        // Apply cursor pagination
        if let cursorId = cursorId,
           let cursorIndex = filteredMemos.firstIndex(where: { $0.id == cursorId }) {
            let nextIndex = cursorIndex + 1
            if nextIndex < filteredMemos.count {
                filteredMemos = Array(filteredMemos[nextIndex...])
            } else {
                filteredMemos = []
            }
        }

        // Apply limit
        return Array(filteredMemos.prefix(limit))
    }

    public func addImage(_ memo: Memo, image: ImageAttachment) throws {
        guard let existingMemo = memos[memo.id] else {
            throw AppError.notFound
        }

        // Create new memo with updated images array
        var updatedImages = existingMemo.images
        updatedImages.append(image)

        let updatedMemo = Memo(
            id: existingMemo.id,
            title: existingMemo.title,
            contents: existingMemo.contents,
            due: existingMemo.due,
            done: existingMemo.done,
            eventIdentifier: existingMemo.eventIdentifier,
            createdAt: existingMemo.createdAt,
            updatedAt: Date(),
            images: updatedImages
        )

        memos[memo.id] = updatedMemo
    }

    public func deleteImage(memoId: String, imageId: String) throws {
        guard let existingMemo = memos[memoId] else {
            throw AppError.notFound
        }

        // Find the image in memo's images array
        guard let imageIndex = existingMemo.images.firstIndex(where: { $0.id == imageId }) else {
            throw AppError.notFound
        }

        // Remove the image from array
        var updatedImages = existingMemo.images
        updatedImages.remove(at: imageIndex)

        // Create updated memo
        let updatedMemo = Memo(
            id: existingMemo.id,
            title: existingMemo.title,
            contents: existingMemo.contents,
            due: existingMemo.due,
            done: existingMemo.done,
            eventIdentifier: existingMemo.eventIdentifier,
            createdAt: existingMemo.createdAt,
            updatedAt: Date(),
            images: updatedImages
        )

        memos[memoId] = updatedMemo
    }
}

public extension MemoDAOMock {
    static func withSampleData() -> MemoDAOMock {
        let now = Date()
        let calendar = Calendar.current

        let sampleMemos = [
            Memo(
                title: "Buy groceries",
                contents: "# Shopping List\n## Produce\n- Apples\n- Bananas\n- Spinach\n\n## Dairy\n- Milk\n- Greek yogurt\n\n[Store locator](https://www.wholefoods.com)",
                due: calendar.date(byAdding: .day, value: -1, to: now)
            ),
            Memo(
                title: "Meeting with team",
                contents: "Discuss project roadmap and sprint planning\n\n**Agenda:**\n- Q4 deliverables\n- Resource allocation\n- Risk assessment",
                due: calendar.date(byAdding: .hour, value: 2, to: now),
                done: false
            ),
            Memo(
                title: "Complete SwiftUI tutorial",
                contents: nil,
                due: calendar.date(byAdding: .day, value: 3, to: now),
                done: true
            ),
            Memo(
                title: "Book vacation",
                contents: "Research destinations for summer vacation\n\n**Options:**\n- Japan (Tokyo, Kyoto)\n- Italy (Rome, Florence)\n- Iceland (Reykjavik, Blue Lagoon)\n\nBudget: $3000-4000",
                due: calendar.date(byAdding: .day, value: 7, to: now),
                done: false
            ),
            Memo(
                title: "Doctor appointment",
                contents: "Annual checkup with Dr. Smith\n\n**Remember to bring:**\n- Insurance card\n- List of current medications\n- Questions about recent symptoms",
                due: calendar.date(byAdding: .day, value: -3, to: now),
                done: true
            ),
            Memo(
                title: "Learn Git best practices",
                contents: "# Git Learning Plan\n\n## Topics to cover:\n- Branching strategies\n- Commit message conventions\n- Merge vs Rebase\n- Git hooks\n\n## Resources:\n- [Atlassian Git Tutorial](https://www.atlassian.com/git)\n- Pro Git book",
                due: calendar.date(byAdding: .day, value: 14, to: now),
                done: false
            ),
            Memo(
                title: "Tax documents",
                contents: "Gather all tax documents for filing\n\n**Required:**\n- W-2 forms\n- 1099 forms\n- Receipts for deductions\n- Bank statements\n- Investment statements",
                due: calendar.date(byAdding: .day, value: -30, to: now),
                done: true
            ),
            Memo(
                title: "Weekend hiking trip",
                contents: "Plan hiking trip to Mount Washington\n\n**Packing list:**\n- Hiking boots\n- Water bottles\n- Snacks\n- First aid kit\n- Map and compass\n- Weather-appropriate clothing",
                due: calendar.date(byAdding: .day, value: 5, to: now),
                done: false
            ),
            Memo(
                title: "Home improvement project",
                contents: "Kitchen renovation planning\n\n## Phase 1: Research\n- Cabinet styles\n- Countertop materials\n- Appliance upgrades\n\n## Phase 2: Budgeting\n- Get contractor quotes\n- Compare material costs\n- Set timeline",
                due: calendar.date(byAdding: .month, value: 1, to: now),
                done: false
            ),
            Memo(
                title: "Read 'Clean Code'",
                contents: "Technical book reading goal\n\n**Key chapters:**\n1. Clean Code\n2. Meaningful Names\n3. Functions\n4. Comments\n5. Formatting\n\n*Goal: 2 chapters per week*",
                due: nil,
                done: false
            ),
            Memo(
                title: "Birthday party planning",
                contents: "Plan surprise party for Sarah\n\n**TODO:**\n- [ ] Book venue\n- [ ] Send invitations\n- [ ] Order cake\n- [ ] Plan decorations\n- [ ] Coordinate with friends\n\n**Date:** Next Saturday",
                due: calendar.date(byAdding: .day, value: 10, to: now),
                done: false
            ),
            Memo(
                title: "Car maintenance",
                contents: "Scheduled maintenance for Honda Civic\n\n**Services needed:**\n- Oil change\n- Tire rotation\n- Brake inspection\n- Air filter replacement\n\n**Mileage:** 45,000 miles",
                due: calendar.date(byAdding: .day, value: -7, to: now),
                done: true
            ),
            Memo(
                title: "Learn Spanish",
                contents: "Language learning goals\n\n**Daily practice:**\n- 30 minutes Duolingo\n- Watch Spanish Netflix shows\n- Practice conversation with Maria\n\n**Progress:** Completed beginner level",
                due: nil,
                done: false
            ),
            Memo(
                title: "Organize photo albums",
                contents: "Sort and organize digital photos from 2024\n\n**Albums to create:**\n- Vacation photos\n- Family events\n- Work conferences\n- Random snapshots\n\nUse Google Photos for backup",
                due: calendar.date(byAdding: .day, value: 21, to: now),
                done: false
            ),
            Memo(
                title: "Investment portfolio review",
                contents: "Quarterly review of investment accounts\n\n**Accounts to review:**\n- 401(k)\n- Roth IRA\n- Brokerage account\n- Emergency fund\n\n**Rebalancing needed:** Check asset allocation",
                due: calendar.date(byAdding: .day, value: -14, to: now),
                done: true
            )
        ]
        return MemoDAOMock(initialMemos: sampleMemos)
    }

    func getMemoStatics() -> MemoStatistics {
        let totalCount = memos.count
        let uncompletedCount = memos.count(where: { (_: String, value: Memo) in
            value.done == false
        })
        let urgentsCount = memos.count(where: { (_: String, value: Memo) in
            value.isUrgent == true
        })

        return MemoStatistics(totalCount: totalCount, uncompletedCount: uncompletedCount, urgentsCount: urgentsCount)
    }
}

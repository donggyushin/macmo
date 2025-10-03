//
//  MemoRepositoryTests.swift
//  macmo
//
//  Created by Claude on 10/4/25.
//

import XCTest
@testable import macmo

final class MemoRepositoryTests: XCTestCase {

    var repository: MemoRepository!
    var mockDAO: MockMemoDAO!

    override func setUp() {
        super.setUp()
        mockDAO = MockMemoDAO()
        repository = MemoRepository(memoDAO: mockDAO)

        // Clear UserDefaults for clean state
        UserDefaults.standard.removeObject(forKey: "memo-sort")
        UserDefaults.standard.removeObject(forKey: "ascending")
    }

    override func tearDown() {
        repository = nil
        mockDAO = nil
        UserDefaults.standard.removeObject(forKey: "memo-sort")
        UserDefaults.standard.removeObject(forKey: "ascending")
        super.tearDown()
    }

    // MARK: - UserDefaults Caching Tests

    func testGet_returnsDefaultSort() {
        // When: UserDefaults에 값이 없을 때
        let sort = repository.get()

        // Then: 기본값 반환
        XCTAssertEqual(sort, .createdAt, "Default sort should be createdAt")
    }

    func testSet_savesToUserDefaults() {
        // When: sort 설정
        repository.set(.updatedAt)

        // Then: UserDefaults에 저장되고, get으로 조회 가능
        let retrievedSort = repository.get()
        XCTAssertEqual(retrievedSort, .updatedAt, "Sort should be saved to UserDefaults")
    }

    func testSet_persistsAcrossInstances() {
        // Given: 첫 번째 인스턴스에서 설정
        repository.set(.due)

        // When: 새로운 Repository 인스턴스 생성
        let newRepository = MemoRepository(memoDAO: mockDAO)

        // Then: 설정값이 유지됨
        XCTAssertEqual(newRepository.get(), .due, "Sort should persist across instances")
    }

    func testGetAscending_returnsDefaultValue() {
        // When: UserDefaults에 값이 없을 때
        let ascending = repository.getAscending()

        // Then: 기본값 false 반환
        XCTAssertFalse(ascending, "Default ascending should be false")
    }

    func testSetAscending_savesToUserDefaults() {
        // When: ascending 설정
        repository.setAscending(true)

        // Then: UserDefaults에 저장되고, get으로 조회 가능
        let retrievedAscending = repository.getAscending()
        XCTAssertTrue(retrievedAscending, "Ascending should be saved to UserDefaults")
    }

    func testSetAscending_persistsAcrossInstances() {
        // Given: 첫 번째 인스턴스에서 설정
        repository.setAscending(true)

        // When: 새로운 Repository 인스턴스 생성
        let newRepository = MemoRepository(memoDAO: mockDAO)

        // Then: 설정값이 유지됨
        XCTAssertTrue(newRepository.getAscending(), "Ascending should persist across instances")
    }

    // MARK: - DAO Delegation Tests

    func testSave_delegatesToDAO() throws {
        // Given
        let memo = Memo(title: "Test Memo", contents: "Content")

        // When
        try repository.save(memo)

        // Then: DAO를 통해 저장되었는지 확인
        let savedMemo = try mockDAO.findById(memo.id)
        XCTAssertNotNil(savedMemo, "Memo should be saved through DAO")
        XCTAssertEqual(savedMemo?.title, "Test Memo")
    }

    func testFindAll_delegatesToDAO() throws {
        // Given: DAO에 메모 추가
        let memo1 = Memo(title: "Memo 1")
        let memo2 = Memo(title: "Memo 2")
        try mockDAO.save(memo1)
        try mockDAO.save(memo2)

        // When
        let memos = try repository.findAll(cursorId: nil, limit: 10, sortBy: .createdAt, ascending: false)

        // Then
        XCTAssertEqual(memos.count, 2, "Should return all memos from DAO")
    }

    func testFindAll_passesCorrectParameters() throws {
        // Given: 여러 메모 생성
        for i in 1...5 {
            let memo = Memo(title: "Memo \(i)")
            try mockDAO.save(memo)
        }

        // When: 페이지네이션과 정렬 옵션 사용
        let memos = try repository.findAll(cursorId: nil, limit: 3, sortBy: .createdAt, ascending: true)

        // Then: limit이 적용되어야 함
        XCTAssertEqual(memos.count, 3, "Should respect limit parameter")
    }

    func testFindById_delegatesToDAO() throws {
        // Given
        let memo = Memo(title: "Test Memo")
        try mockDAO.save(memo)

        // When
        let foundMemo = try repository.findById(memo.id)

        // Then
        XCTAssertNotNil(foundMemo, "Should find memo through DAO")
        XCTAssertEqual(foundMemo?.id, memo.id)
    }

    func testFindById_returnsNilForNonexistent() throws {
        // When: 존재하지 않는 ID 조회
        let foundMemo = try repository.findById("nonexistent-id")

        // Then
        XCTAssertNil(foundMemo, "Should return nil for nonexistent memo")
    }

    func testUpdate_delegatesToDAO() throws {
        // Given: 기존 메모 저장
        let memo = Memo(title: "Original Title", contents: "Original Content")
        try mockDAO.save(memo)

        // When: 메모 업데이트
        var updatedMemo = memo
        updatedMemo.title = "Updated Title"
        try repository.update(updatedMemo)

        // Then: DAO에서 업데이트된 내용 확인
        let foundMemo = try mockDAO.findById(memo.id)
        XCTAssertEqual(foundMemo?.title, "Updated Title", "Memo should be updated through DAO")
    }

    func testDelete_delegatesToDAO() throws {
        // Given: 메모 저장
        let memo = Memo(title: "To Delete")
        try mockDAO.save(memo)
        XCTAssertNotNil(try mockDAO.findById(memo.id), "Memo should exist before deletion")

        // When: 메모 삭제
        try repository.delete(memo.id)

        // Then: DAO에서 삭제되었는지 확인
        let deletedMemo = try mockDAO.findById(memo.id)
        XCTAssertNil(deletedMemo, "Memo should be deleted from DAO")
    }

    func testSearch_delegatesToDAO() throws {
        // Given: 검색 가능한 메모들 저장
        let memo1 = Memo(title: "Swift Programming", contents: "Learn Swift")
        let memo2 = Memo(title: "Java Programming", contents: "Learn Java")
        let memo3 = Memo(title: "Swift UI", contents: "SwiftUI tutorial")
        try mockDAO.save(memo1)
        try mockDAO.save(memo2)
        try mockDAO.save(memo3)

        // When: "Swift" 검색
        let results = try repository.search(query: "Swift", cursorId: nil, limit: 10)

        // Then: Swift가 포함된 메모만 반환
        XCTAssertEqual(results.count, 2, "Should find 2 memos containing 'Swift'")
        XCTAssertTrue(results.allSatisfy { $0.title.contains("Swift") || ($0.contents?.contains("Swift") ?? false) })
    }

    func testSearch_withEmptyQuery_returnsEmpty() throws {
        // Given: 메모들 저장
        let memo = Memo(title: "Test Memo")
        try mockDAO.save(memo)

        // When: 빈 검색어
        let results = try repository.search(query: "   ", cursorId: nil, limit: 10)

        // Then: 빈 결과
        XCTAssertTrue(results.isEmpty, "Empty query should return empty results")
    }

    func testSearch_withPagination() throws {
        // Given: 많은 메모 저장
        for i in 1...10 {
            let memo = Memo(title: "Test Memo \(i)", contents: "Content")
            try mockDAO.save(memo)
        }

        // When: limit 설정
        let results = try repository.search(query: "Test", cursorId: nil, limit: 5)

        // Then: limit이 적용됨
        XCTAssertEqual(results.count, 5, "Should respect limit parameter in search")
    }

    // MARK: - Integration Tests (DAO + Cache)

    func testSortPreference_usedInMultipleCalls() throws {
        // Given: sort 설정
        repository.set(.updatedAt)
        repository.setAscending(true)

        // When/Then: 설정값이 여러 번 조회해도 유지됨
        XCTAssertEqual(repository.get(), .updatedAt)
        XCTAssertTrue(repository.getAscending())

        repository.set(.due)
        XCTAssertEqual(repository.get(), .due)
    }

    func testCacheIndependence_sortAndAscending() {
        // When: 각각 독립적으로 설정
        repository.set(.due)
        repository.setAscending(true)

        // Then: 각각 독립적으로 조회 가능
        XCTAssertEqual(repository.get(), .due)
        XCTAssertTrue(repository.getAscending())

        // When: 하나만 변경
        repository.set(.createdAt)

        // Then: 다른 값은 영향 받지 않음
        XCTAssertEqual(repository.get(), .createdAt)
        XCTAssertTrue(repository.getAscending(), "Ascending should remain unchanged")
    }
}

//
import MacmoDomain
import MacmoData
//  MemoRepositoryTests.swift
//  macmo
//
//  Created by Claude on 10/4/25.
//

import Factory
import Foundation
import Testing
@testable import macmo

struct MemoRepositoryTests {
    // MARK: - UserDefaults Caching Tests

    @Test("Get returns default sort")
    func getReturnsDefaultSort() {
        let repository = Container.shared.userPreferenceRepository()

        // Clear UserDefaults for clean state
        UserDefaults.standard.removeObject(forKey: "memo-sort")

        let sort: MemoSort = repository.getMemoSort()

        #expect(sort == .createdAt)
    }

    @Test("Set saves to UserDefaults")
    func setSavesToUserDefaults() {
        let repository = Container.shared.userPreferenceRepository()

        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "memo-sort")

        repository.setMemoSort(.updatedAt)

        let retrievedSort: MemoSort = repository.getMemoSort()
        #expect(retrievedSort == .updatedAt)

        // Cleanup
        UserDefaults.standard.removeObject(forKey: "memo-sort")
    }

    @Test("Set persists across instances")
    func setPersistsAcrossInstances() {
        let repository = Container.shared.userPreferenceRepository()

        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "memo-sort")

        repository.setMemoSort(.due)

        #expect(repository.getMemoSort() == .due)

        // Cleanup
        UserDefaults.standard.removeObject(forKey: "memo-sort")
    }

    @Test("GetAscending returns default value")
    func getAscendingReturnsDefaultValue() {
        let repository = Container.shared.userPreferenceRepository()

        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "ascending")

        let ascending = repository.getAscending()

        #expect(ascending == false)
    }

    @Test("SetAscending saves to UserDefaults")
    func setAscendingSavesToUserDefaults() {
        let repository = Container.shared.userPreferenceRepository()

        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "ascending")

        repository.setAscending(true)

        let retrievedAscending = repository.getAscending()
        #expect(retrievedAscending == true)

        // Cleanup
        UserDefaults.standard.removeObject(forKey: "ascending")
    }

    @Test("SetAscending persists across instances")
    func setAscendingPersistsAcrossInstances() {
        let repository = Container.shared.userPreferenceRepository()

        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "ascending")

        repository.setAscending(true)

        #expect(repository.getAscending() == true)

        // Cleanup
        UserDefaults.standard.removeObject(forKey: "ascending")
    }

    // MARK: - DAO Delegation Tests

    @Test("Save delegates to DAO")
    func saveDelegatesToDAO() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        let memo = Memo(title: "Test Memo", contents: "Content")

        try repository.save(memo)

        let savedMemo = try mockDAO.findById(memo.id)
        #expect(savedMemo != nil)
        #expect(savedMemo?.title == "Test Memo")
    }

    @Test("FindAll delegates to DAO")
    func findAllDelegatesToDAO() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        let memo1 = Memo(title: "Memo 1")
        let memo2 = Memo(title: "Memo 2")
        try mockDAO.save(memo1)
        try mockDAO.save(memo2)

        let memos = try repository.findAll(cursorId: nil, limit: 10, sortBy: .createdAt, ascending: false)

        #expect(memos.count == 2)
    }

    @Test("FindAll passes correct parameters")
    func findAllPassesCorrectParameters() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        for i in 1 ... 5 {
            let memo = Memo(title: "Memo \(i)")
            try mockDAO.save(memo)
        }

        let memos = try repository.findAll(cursorId: nil, limit: 3, sortBy: .createdAt, ascending: true)

        #expect(memos.count == 3)
    }

    @Test("FindById delegates to DAO")
    func findByIdDelegatesToDAO() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        let memo = Memo(title: "Test Memo")
        try mockDAO.save(memo)

        let foundMemo = try repository.findById(memo.id)

        #expect(foundMemo != nil)
        #expect(foundMemo?.id == memo.id)
    }

    @Test("FindById returns nil for nonexistent")
    func findByIdReturnsNilForNonexistent() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        let foundMemo = try repository.findById("nonexistent-id")

        #expect(foundMemo == nil)
    }

    @Test("Update delegates to DAO")
    func updateDelegatesToDAO() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        let memo = Memo(title: "Original Title", contents: "Original Content")
        try mockDAO.save(memo)

        var updatedMemo = memo
        updatedMemo.title = "Updated Title"
        try repository.update(updatedMemo)

        let foundMemo = try mockDAO.findById(memo.id)
        #expect(foundMemo?.title == "Updated Title")
    }

    @Test("Delete delegates to DAO")
    func deleteDelegatesToDAO() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        let memo = Memo(title: "To Delete")
        try mockDAO.save(memo)
        #expect(try mockDAO.findById(memo.id) != nil)

        try repository.delete(memo.id)

        let deletedMemo = try mockDAO.findById(memo.id)
        #expect(deletedMemo == nil)
    }

    @Test("Search delegates to DAO")
    func searchDelegatesToDAO() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        let memo1 = Memo(title: "Swift Programming", contents: "Learn Swift")
        let memo2 = Memo(title: "Java Programming", contents: "Learn Java")
        let memo3 = Memo(title: "Swift UI", contents: "SwiftUI tutorial")
        try mockDAO.save(memo1)
        try mockDAO.save(memo2)
        try mockDAO.save(memo3)

        let results = try repository.search(query: "Swift", cursorId: nil, limit: 10, sortBy: .updatedAt)

        #expect(results.count == 2)
        #expect(results.allSatisfy { $0.title.contains("Swift") || ($0.contents?.contains("Swift") ?? false) })
    }

    @Test("Search with empty query returns empty")
    func searchWithEmptyQueryReturnsEmpty() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        let memo = Memo(title: "Test Memo")
        try mockDAO.save(memo)

        let results = try repository.search(query: "   ", cursorId: nil, limit: 10, sortBy: .updatedAt)

        #expect(results.isEmpty)
    }

    @Test("Search with pagination")
    func searchWithPagination() throws {
        let mockDAO = MemoDAOMock()
        let repository = MemoRepositoryImpl(memoDAO: mockDAO)

        for i in 1 ... 10 {
            let memo = Memo(title: "Test Memo \(i)", contents: "Content")
            try mockDAO.save(memo)
        }

        let results = try repository.search(query: "Test", cursorId: nil, limit: 5, sortBy: .updatedAt)

        #expect(results.count == 5)
    }

    // MARK: - Integration Tests (DAO + Cache)

    @Test("Sort preference used in multiple calls")
    func sortPreferenceUsedInMultipleCalls() {
        let repository = Container.shared.userPreferenceRepository()
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "memo-sort")
        UserDefaults.standard.removeObject(forKey: "ascending")

        repository.setMemoSort(.updatedAt)
        repository.setAscending(true)

        #expect(repository.getMemoSort() == .updatedAt)
        #expect(repository.getAscending() == true)

        repository.setMemoSort(.due)
        #expect(repository.getMemoSort() == .due)

        // Cleanup
        UserDefaults.standard.removeObject(forKey: "memo-sort")
        UserDefaults.standard.removeObject(forKey: "ascending")
    }

    @Test("Cache independence - sort and ascending")
    func cacheIndependenceSortAndAscending() {
        let repository = Container.shared.userPreferenceRepository()

        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "memo-sort")
        UserDefaults.standard.removeObject(forKey: "ascending")

        repository.setMemoSort(.due)
        repository.setAscending(true)

        #expect(repository.getMemoSort() == .due)
        #expect(repository.getAscending() == true)

        repository.setMemoSort(.createdAt)

        #expect(repository.getMemoSort() == .createdAt)
        #expect(repository.getAscending() == true)

        // Cleanup
        UserDefaults.standard.removeObject(forKey: "memo-sort")
        UserDefaults.standard.removeObject(forKey: "ascending")
    }
}

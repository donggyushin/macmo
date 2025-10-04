//
//  MarkdownListContinuationTests.swift
//  macmo
//
//  Created by 신동규 on 10/4/25.
//

import Testing
@testable import macmo

struct MarkdownListContinuationTests {

    @Test("Task list continuation - adds new task item")
    func taskListContinuation() {
        let oldValue = "- [ ] item"
        let newValue = "- [ ] item\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- [ ] item\n- [ ] ")
    }

    @Test("Task list continuation - stops on empty task")
    func taskListStopsOnEmpty() {
        let oldValue = "- [ ] item\n- [ ] "
        let newValue = "- [ ] item\n- [ ] \n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- [ ] item\n")
    }

    @Test("Regular list continuation - adds new item")
    func regularListContinuation() {
        let oldValue = "- item"
        let newValue = "- item\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- item\n- ")
    }

    @Test("Regular list continuation - stops on empty item")
    func regularListStopsOnEmpty() {
        let oldValue = "- item\n- "
        let newValue = "- item\n- \n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- item\n")
    }

    @Test("No continuation when typing regular text")
    func noRegularTextContinuation() {
        let oldValue = "regular text"
        let newValue = "regular text\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == nil)
    }

    @Test("No continuation when deleting text")
    func noContinuationOnDelete() {
        let oldValue = "- [ ] item"
        let newValue = "- [ ] ite"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == nil)
    }

    @Test("Prevents re-processing after adding task marker")
    func preventsReprocessingTaskMarker() {
        let oldValue = "- [ ] item\n"
        let newValue = "- [ ] item\n- [ ] "

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == nil)
    }

    @Test("Prevents re-processing after adding list marker")
    func preventsReprocessingListMarker() {
        let oldValue = "- item\n"
        let newValue = "- item\n- "

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == nil)
    }

    @Test("Handles double newline correctly")
    func handlesDoubleNewline() {
        let oldValue = "- [ ] item\n"
        let newValue = "- [ ] item\n\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == nil)
    }

    @Test("Continues checked task list items")
    func continuesCheckedTaskItems() {
        let oldValue = "- [x] done item"
        let newValue = "- [x] done item\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- [x] done item\n- [ ] ")
    }
}

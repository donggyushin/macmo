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

    @Test("Continues indented regular list items")
    func continuesIndentedRegularList() {
        let oldValue = "- some text\n  - nested item"
        let newValue = "- some text\n  - nested item\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- some text\n  - nested item\n  - ")
    }

    @Test("Continues indented task list items")
    func continuesIndentedTaskList() {
        let oldValue = "- [ ] some text\n  - [ ] nested task"
        let newValue = "- [ ] some text\n  - [ ] nested task\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- [ ] some text\n  - [ ] nested task\n  - [ ] ")
    }

    @Test("Stops indented task list on empty item")
    func stopsIndentedTaskListOnEmpty() {
        let oldValue = "- [ ] some text\n  - [ ] "
        let newValue = "- [ ] some text\n  - [ ] \n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- [ ] some text\n")
    }

    @Test("Stops indented regular list on empty item")
    func stopsIndentedRegularListOnEmpty() {
        let oldValue = "- some text\n  - "
        let newValue = "- some text\n  - \n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- some text\n")
    }

    @Test("Continues deeply indented list items")
    func continuesDeeplyIndentedList() {
        let oldValue = "- level 1\n  - level 2\n    - level 3"
        let newValue = "- level 1\n  - level 2\n    - level 3\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- level 1\n  - level 2\n    - level 3\n    - ")
    }

    @Test("Preserves tab indentation")
    func preservesTabIndentation() {
        let oldValue = "- level 1\n\t- nested with tab"
        let newValue = "- level 1\n\t- nested with tab\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "- level 1\n\t- nested with tab\n\t- ")
    }
}

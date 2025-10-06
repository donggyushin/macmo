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

    @Test("Numbered list continuation - adds next number")
    func numberedListContinuation() {
        let oldValue = "1. first item"
        let newValue = "1. first item\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "1. first item\n2. ")
    }

    @Test("Numbered list continuation - continues from any number")
    func numberedListContinuesFromAnyNumber() {
        let oldValue = "5. fifth item"
        let newValue = "5. fifth item\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "5. fifth item\n6. ")
    }

    @Test("Numbered list continuation - stops on empty item")
    func numberedListStopsOnEmpty() {
        let oldValue = "1. first item\n2. "
        let newValue = "1. first item\n2. \n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "1. first item\n")
    }

    @Test("Numbered list continuation - handles double digit numbers")
    func numberedListHandlesDoubleDigits() {
        let oldValue = "99. item ninety-nine"
        let newValue = "99. item ninety-nine\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "99. item ninety-nine\n100. ")
    }

    @Test("Numbered list continuation - preserves indentation")
    func numberedListPreservesIndentation() {
        let oldValue = "1. first level\n  1. nested item"
        let newValue = "1. first level\n  1. nested item\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "1. first level\n  1. nested item\n  2. ")
    }

    @Test("Numbered list continuation - stops indented empty item")
    func numberedListStopsIndentedEmpty() {
        let oldValue = "1. first level\n  1. nested\n  2. "
        let newValue = "1. first level\n  1. nested\n  2. \n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == "1. first level\n  1. nested\n")
    }

    @Test("Numbered list - ignores non-numbered patterns")
    func numberedListIgnoresNonNumberedPatterns() {
        let oldValue = "a. not a number"
        let newValue = "a. not a number\n"

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == nil)
    }

    @Test("Numbered list - prevents reprocessing after adding marker")
    func numberedListPreventsReprocessing() {
        let oldValue = "1. first item\n"
        let newValue = "1. first item\n2. "

        let result = MarkdownListContinuation.process(oldValue: oldValue, newValue: newValue)

        #expect(result == nil)
    }
}

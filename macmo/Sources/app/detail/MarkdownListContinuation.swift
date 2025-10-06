//
//  MarkdownListContinuation.swift
//  macmo
//
//  Created by 신동규 on 10/4/25.
//

import Foundation

/// Handles automatic markdown list continuation when user presses return
enum MarkdownListContinuation {

    /// Process markdown list continuation
    /// - Parameters:
    ///   - oldValue: Previous text value
    ///   - newValue: New text value after user input
    /// - Returns: Modified text with continuation marker, or nil if no modification needed
    static func process(oldValue: String, newValue: String) -> String? {
        // Only trigger if text length increased
        guard newValue.count > oldValue.count else {
            return nil
        }

        // Check if we just added a continuation marker ourselves (to prevent re-processing)
        let diff = String(newValue.dropFirst(oldValue.count))
        if diff.hasPrefix("- [ ] ") || diff.hasPrefix("- [x] ") || diff.hasPrefix("- ") {
            return nil
        }
        // Check if we just added a numbered list marker
        if diff.first?.isNumber == true && diff.contains(". ") {
            return nil
        }

        // Only trigger if a newline was just added
        guard oldValue.count > 0,
              diff.first == "\n" else {
            return nil
        }

        // Only process single newlines that we haven't already handled
        if newValue.hasSuffix("\n") && !newValue.hasSuffix("\n\n") {
            let lines = newValue.components(separatedBy: "\n")
            guard lines.count >= 2 else { return nil }

            let previousLine = lines[lines.count - 2]
            let currentLine = lines[lines.count - 1]

            // Skip if current line already has list marker (already processed)
            guard currentLine.isEmpty else { return nil }

            // Extract indentation (leading spaces or tabs)
            let indentation = extractIndentation(from: previousLine)

            // Get trimmed line without indentation
            let trimmedPrevious = previousLine.trimmingCharacters(in: .whitespacesAndNewlines)

            // Check for numbered list items (1. , 2. , etc.)
            if let numberedResult = processNumberedList(trimmedPrevious: trimmedPrevious, newValue: newValue, indentation: indentation, lines: lines) {
                return numberedResult
            }
            // Check for task list items (- [ ] or - [x])
            else if trimmedPrevious.hasPrefix("- [") && trimmedPrevious.contains("]") {
                if trimmedPrevious == "- [ ]" || trimmedPrevious == "- [x]" {
                    // Empty task item, stop the list
                    let linesWithoutEmpty = lines.dropLast(2) + [""]
                    return linesWithoutEmpty.joined(separator: "\n")
                } else {
                    // Continue with new unchecked task, preserving indentation
                    return newValue + indentation + "- [ ] "
                }
            }
            // Check for regular list items
            else if trimmedPrevious == "-" {
                // Empty list item, stop the list
                let linesWithoutEmpty = lines.dropLast(2) + [""]
                return linesWithoutEmpty.joined(separator: "\n")
            } else if trimmedPrevious.hasPrefix("- ") && !trimmedPrevious.isEmpty {
                // Continue with regular list item, preserving indentation
                return newValue + indentation + "- "
            }
        }

        return nil
    }

    /// Process numbered list continuation
    /// - Parameters:
    ///   - trimmedPrevious: The trimmed previous line
    ///   - newValue: The new text value
    ///   - indentation: The indentation to preserve
    ///   - lines: All lines in the text
    /// - Returns: Modified text with numbered continuation, or nil if not a numbered list
    private static func processNumberedList(trimmedPrevious: String, newValue: String, indentation: String, lines: [String]) -> String? {
        // Check if line matches numbered list pattern (e.g., "1. ", "23. ")
        guard let dotIndex = trimmedPrevious.firstIndex(of: "."),
              dotIndex != trimmedPrevious.startIndex else {
            return nil
        }

        let numberPart = trimmedPrevious[..<dotIndex]

        // Verify all characters before dot are digits
        guard numberPart.allSatisfy({ $0.isNumber }) else {
            return nil
        }

        // Check if there's a space after the dot
        let afterDotIndex = trimmedPrevious.index(after: dotIndex)
        guard afterDotIndex < trimmedPrevious.endIndex,
              trimmedPrevious[afterDotIndex] == " " else {
            return nil
        }

        // Check if this is an empty numbered item (just "1. ")
        let contentAfterMarker = trimmedPrevious[trimmedPrevious.index(after: afterDotIndex)...].trimmingCharacters(in: .whitespaces)
        if contentAfterMarker.isEmpty {
            // Empty numbered item, stop the list
            let linesWithoutEmpty = lines.dropLast(2) + [""]
            return linesWithoutEmpty.joined(separator: "\n")
        }

        // Continue with next number
        if let currentNumber = Int(numberPart) {
            let nextNumber = currentNumber + 1
            return newValue + indentation + "\(nextNumber). "
        }

        return nil
    }

    /// Extracts leading whitespace (indentation) from a line
    /// - Parameter line: The line to extract indentation from
    /// - Returns: The leading whitespace string (spaces or tabs)
    private static func extractIndentation(from line: String) -> String {
        var indentation = ""
        for char in line {
            if char == " " || char == "\t" {
                indentation.append(char)
            } else {
                break
            }
        }
        return indentation
    }
}

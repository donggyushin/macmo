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

            // Check for task list items (- [ ] or - [x])
            if trimmedPrevious.hasPrefix("- [") && trimmedPrevious.contains("]") {
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

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
        if diff == "- [ ] " || diff == "- [x] " || diff == "- " {
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

            // Check for task list items (- [ ] or - [x])
            if previousLine.hasPrefix("- [") && previousLine.contains("]") {
                let trimmed = previousLine.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed == "- [ ]" || trimmed == "- [x]" {
                    // Empty task item, stop the list
                    let linesWithoutEmpty = lines.dropLast(2) + [""]
                    return linesWithoutEmpty.joined(separator: "\n")
                } else {
                    // Continue with new unchecked task
                    return newValue + "- [ ] "
                }
            }
            // Check for regular list items
            else if previousLine.trimmingCharacters(in: .whitespacesAndNewlines) == "-" {
                // Empty list item, stop the list
                let linesWithoutEmpty = lines.dropLast(2) + [""]
                return linesWithoutEmpty.joined(separator: "\n")
            } else if previousLine.hasPrefix("- ") && !previousLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                // Continue with regular list item
                return newValue + "- "
            }
        }

        return nil
    }
}

//
//  MemoDetailView.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import SwiftUI

struct MemoDetailView: View {
    @ObservedObject var model: MemoDetailViewModel
    @Environment(\.dismissWindow) private var dismissWindow
    @FocusState private var focusedField: FocusField?
    @State private var previousContents: String = ""

    enum FocusField {
        case title
        case contents
    }

    init(model: MemoDetailViewModel) {
        _model = .init(initialValue: model)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                titleSection
                contentsSection
                dueDateSection
                completionSection

                if !model.isNewMemo {
                    metadataSection
                }
            }
            .padding()
        }
        .navigationTitle(model.isNewMemo ? "New Memo" : "Memo")
        .toolbar {
            
            if model.isEditing {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        model.isEditing = false
                    }
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                if model.isEditing {
                    Button("Save") {
                        model.save()
                        if model.isNewMemo {
                            dismissWindow(id: "memo-detail")
                        }
                    }
                    .disabled(!model.canSave)
                } else {
                    Button("Edit") {
                        model.startEditing()
                    }
                }
            }
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.headline)

            if model.isEditing {
                TextField("Enter memo title", text: $model.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .title)
                    .onSubmit {
                        focusedField = .contents
                    }
                    .onAppear {
                        focusedField = .title
                    }
                
            } else {
                Text(model.title)
                    .font(.title2)
                    .strikethrough(model.isDone)
            }
        }
    }

    private var contentsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contents")
                .font(.headline)

            if model.isEditing {
                TextEditor(text: $model.contents)
                    .padding(8)
                    .frame(minHeight: 120)
                    .scrollContentBackground(.hidden)
                    .focused($focusedField, equals: .contents)
                    .onReceive(model.$contents) { newValue in
                        handleMarkdownListContinuation(newValue)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            } else {
                if model.contents.isEmpty {
                    Text("No contents")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    Text(model.contents)
                        .font(.body)
                }
            }
        }
    }

    private var dueDateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Due Date")
                .font(.headline)

            if model.isEditing {
                Toggle("Set due date", isOn: $model.hasDueDate)

                if model.hasDueDate {
                    DatePicker("Due date", selection: $model.dueDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                }
            } else {
                
                HStack {
                    Text(model.dueDate, style: .date)
                    Text(model.dueDate, style: .time)

                    Spacer()

                    if model.dueDate < Date() {
                        Text("Overdue")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
            }
        }
    }

    private var completionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status")
                .font(.headline)

            if model.isEditing {
                Toggle("Completed", isOn: $model.isDone)
            } else {
                Button {
                    model.toggleComplete()
                } label: {
                    HStack {
                        Image(systemName: model.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(model.isDone ? .green : .gray)

                        Text(model.isDone ? "Completed" : "Not completed")
                            .foregroundColor(model.isDone ? .green : .primary)
                    }
                }
            }
        }
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Metadata")
                .font(.headline)

            VStack(alignment: .leading, spacing: 4) {
                if let createdAt = model.memo?.createdAt {
                    HStack {
                        Text("Created:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(createdAt, style: .date)
                        Text(createdAt, style: .time)
                    }
                }

                if let updatedAt = model.memo?.updatedAt {
                    HStack {
                        Text("Updated:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(updatedAt, style: .date)
                        Text(updatedAt, style: .time)
                    }
                }

                if let id = model.memo?.id {
                    HStack {
                        Text("ID:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(id)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .font(.caption)
        }
    }

    private func handleMarkdownListContinuation(_ newValue: String) {
        // Only trigger if text length increased (not decreased/deleted)
        guard newValue.count > previousContents.count else {
            previousContents = newValue
            return
        }

        if newValue.hasSuffix("\n") && !newValue.hasSuffix("\n\n") {
            let lines = newValue.components(separatedBy: "\n")
            if lines.count >= 2 {
                let previousLine = lines[lines.count - 2]

                // If previous line is just "- " (empty list item), don't continue the list
                if previousLine.trimmingCharacters(in: .whitespacesAndNewlines) == "-" {
                    // Remove the empty "- " and add extra newline
                    let linesWithoutEmpty = lines.dropLast(2) + [lines[lines.count - 1]]
                    model.contents = linesWithoutEmpty.joined(separator: "\n")
                } else if previousLine.hasPrefix("- ") && !previousLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    model.contents = newValue + "- "
                }
            }
        }

        previousContents = newValue
    }
}


import Factory
private struct MemoDetailViewPreview: View {
    
    @State var memo: Memo?
    
    var body: some View {
        ZStack {
            MemoDetailView(model: .init(id: memo?.id))
        }
        .task {
            let dao = Container.shared.memoDAO()
            memo = try? dao.findAll(cursorId: nil, limit: 1, sortBy: .createdAt, ascending: true).first
        }
    }
}
#Preview {
    MemoDetailViewPreview()
}

//
//  SearchTextField.swift
//  macmo
//
//  Created by Claude Code on 10/3/25.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var text: String
    var focusState: FocusState<Bool>.Binding
    var placeholder: String = "Type urgent or uncompleted"

    private var preventAutoFocus: Bool = false
    func setPreventAutoFocus(_ value: Bool) -> Self {
        var copy = self
        copy.preventAutoFocus = value
        return copy
    }

    init(text: Binding<String>, focusState: FocusState<Bool>.Binding) {
        _text = text
        self.focusState = focusState
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .focused(focusState)
                .onAppear {
                    if !preventAutoFocus {
                        focusState.wrappedValue = true
                    }
                }
        }
        .padding(8)
        .background(backgroundColor)
        .cornerRadius(8)
        .padding(.horizontal)
    }

    private var backgroundColor: Color {
        #if os(iOS)
        Color(uiColor: .secondarySystemBackground)
        #else
        Color(.controlBackgroundColor)
        #endif
    }
}

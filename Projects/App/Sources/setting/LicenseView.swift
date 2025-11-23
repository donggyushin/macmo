//
//  LicenseView.swift
//  macmo
//
//  Created by 신동규 on 10/1/25.
//

import SwiftUI
import MacmoDomain
import MacmoData

struct LicenseView: View {

    var body: some View {
        Form {
            Section {
                libraryRow(
                    name: "Factory",
                    author: "Michael Long",
                    url: "https://github.com/hmlongco/Factory",
                    description: "A Swift Dependency Injection library"
                )

                libraryRow(
                    name: "MarkdownUI",
                    author: "Guille Gonzalez",
                    url: "https://github.com/gonzalezreal/swift-markdown-ui",
                    description: "Display and customize Markdown text in SwiftUI"
                )
            } header: {
                Text("Open Source Libraries")
            } footer: {
                Text("This app uses the following open source libraries")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Licenses")
    }

    private func libraryRow(name: String, author: String, url: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(name)
                    .font(.headline)
                Spacer()
                Link("GitHub", destination: URL(string: url)!)
                    .font(.caption)
            }
            Text("by \(author)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LicenseView()
        .frame(minWidth: 500, minHeight: 300)
}

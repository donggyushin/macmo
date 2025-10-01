//
//  DeveloperView.swift
//  macmo
//
//  Created by 신동규 on 10/1/25.
//

import SwiftUI

struct DeveloperView: View {

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Name")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("Donggyu Shin")
                }

                HStack {
                    Text("Role")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("iOS Developer")
                }

                HStack {
                    Text("GitHub")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Link("donggyushin", destination: URL(string: "https://github.com/donggyushin")!)
                }

                HStack {
                    Text("Contact")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Link("donggyu9410@gmail.com", destination: URL(string: "mailto:donggyu9410@gmail.com")!)
                }
            } header: {
                Text("Developer Information")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Developer")
    }
}

#Preview {
    DeveloperView()
        .frame(minWidth: 500, minHeight: 300)
}

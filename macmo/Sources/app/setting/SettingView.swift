//
//  SettingView.swift
//  macmo
//
//  Created by 신동규 on 10/1/25.
//

import SwiftUI

struct SettingView: View {
    @StateObject var model: SettingViewModel
    @State var isCalendarAccessDeniedDialogOpen = false

    var body: some View {
        Form {
            Section {
                Toggle("Sync with Calendar", isOn: $model.isCalendarSyncEnabled)
                    .onChange(of: model.isCalendarSyncEnabled) { _, newValue in
                        if newValue {
                            Task { @MainActor in
                                let requestAccess = try await model.calendarService.requestAccess()
                                if requestAccess == false && newValue {
                                    isCalendarAccessDeniedDialogOpen = true
                                }
                            }
                        }
                    }
            } header: {
                Text("Calendar Integration")
            } footer: {
                Text("Automatically create calendar events for memos with due dates")
            }

            Section {
                #if os(iOS)
                    Button(action: {
                        // Replace real appstore url
                        if let url = URL(string: "https://apps.apple.com/kr/app/macmo/id6753157832") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text("Download macOS App")
                            Spacer()
                            Image(systemName: "arrow.up.forward.app")
                                .foregroundColor(.secondary)
                        }
                    }
                #else
                    Button {
                        // Replace real appstore url
                        if let url = URL(string: "https://apps.apple.com/kr/app/macmo/id6753157832") {
                            NSWorkspace.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Text("Download iOS App")
                            Spacer()
                            Image(systemName: "arrow.up.forward.app")
                                .foregroundColor(.secondary)
                        }
                    }
                #endif
                NavigationLink("Developer") {
                    DeveloperView()
                }

                NavigationLink("Open Source Licenses") {
                    LicenseView()
                }
            } header: {
                Text("About")
            }
            if model.memoStatistics.isEmpty == false {
                switch model.selectedStatistics {
                case .bar:
                    BarChartView(statistics: model.memoStatistics)
                        .onTapGesture {
                            model.tapChart()
                        }
                case .chart:
                    PieChartView(statistics: model.memoStatistics)
                        .onTapGesture {
                            model.tapChart()
                        }
                }
            }
        }
        .onAppear {
            model.fetchSelectedStatistics()
            model.fetchMemoStatistics()
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
        .task {
            try? await model.configIsCalendarSyncEnabled()
        }
        .alert("Calendar Access Required", isPresented: $isCalendarAccessDeniedDialogOpen) {
            Button("Open System Settings") {
                #if os(macOS)
                    if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars") {
                        NSWorkspace.shared.open(url)
                    }
                #else
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                #endif
            }
            Button("Cancel", role: .cancel) {
                model.isCalendarSyncEnabled = false
            }
        } message: {
            Text("This app needs permission to access your calendar. Please authorize calendar access in System Settings to use the sync feature.")
        }
    }
}

#Preview {
    NavigationStack {
        SettingView(model: .init())
    }
    .frame(minWidth: 500, minHeight: 300)
    .preferredColorScheme(.dark)
}

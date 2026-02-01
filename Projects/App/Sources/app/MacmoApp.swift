import MacmoData
import MacmoDomain
import SwiftUI
import UserNotifications
import WidgetKit

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@main
struct MacmoApp: App {
    @StateObject var navigationManager = NavigationManager()
    @State private var appReady = false
    @Environment(\.openWindow) private var openWindow

    private let notificationDelegate = NotificationDelegate()

    init() {
        try? migrateToAppGroup()
        setupNotificationDelegate()
    }

    private func setupNotificationDelegate() {
        UNUserNotificationCenter.current().delegate = notificationDelegate

        notificationDelegate.onNotificationTapped = { urlScheme in
            // URL scheme을 URL로 변환하여 열기
            guard let url = URL(string: urlScheme) else { return }

            // MacOS에서는 NSWorkspace, iOS에서는 UIApplication 사용
            #if os(iOS)
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            #elseif os(macOS)
            NSWorkspace.shared.open(url)
            #endif
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
                .onOpenURL { url in
                    Task { @MainActor in
                        if appReady == false {
                            try await Task.sleep(for: .seconds(1))
                        }
                        iOSURLSchemeManager.execute(url, navigationManager)
                    }
                }
                .task {
                    WidgetCenter.shared.reloadAllTimelines()
                    try? await Task.sleep(for: .seconds(3))
                    appReady = true
                }
            // .task {
            //     navigationManager.configIntitialSetup()
            // }
        }
        .commands {
            CommandMenu("Memo") {
                Button("New") {
                    openWindow(id: "memo-detail")
                }
                .keyboardShortcut("n", modifiers: .command)

                Button("Finder") {
                    openWindow(id: "search-memo")
                }
                .keyboardShortcut("f", modifiers: .command)

                Button("Calendar") {
                    openWindow(id: "calendar")
                }
                .keyboardShortcut("k", modifiers: .command)

                Button("Setting") {
                    openWindow(id: "setting")
                }
                .keyboardShortcut("s", modifiers: .command)
            }
        }

        WindowGroup("New Memo", id: "memo-detail") {
            MemoDetailView(model: MemoDetailViewModel(id: nil))
                .environmentObject(navigationManager)
        }
        .defaultSize(width: 600, height: 700)

        WindowGroup("Memo Detail", id: "memo-detail-with-id", for: String.self) { $memoId in
            if let memoId {
                MemoDetailView(model: MemoDetailViewModel(id: memoId))
                    .environmentObject(navigationManager)
            }
        }
        .defaultSize(width: 600, height: 700)

        WindowGroup("Search Memos", id: "search-memo") {
            SearchMemoView(model: SearchMemoViewModel())
                .environmentObject(navigationManager)
        }
        .defaultSize(width: 600, height: 700)

        WindowGroup("Setting", id: "setting") {
            NavigationStack {
                SettingView(model: .init())
                    .environmentObject(navigationManager)
            }
        }
        .defaultSize(width: 600, height: 700)

        WindowGroup("Calendar", id: "calendar") {
            MacMonthCalendarListView(model: .init(date: Date()))
                .environmentObject(navigationManager)
        }
        .defaultSize(width: 1000, height: 900)
    }
}

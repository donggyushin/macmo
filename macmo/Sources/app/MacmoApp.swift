import SwiftUI

@main
struct MacmoApp: App {
    @StateObject var navigationManager = NavigationManager()
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
        }
        .commands {
            CommandMenu("Memo") {
                Button("New") {
                    openWindow(id: "memo-detail")
                }
                .keyboardShortcut("n", modifiers: .command)

                Button("Search") {
                    openWindow(id: "search-memo")
                }
                .keyboardShortcut("f", modifiers: .command)

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
    }
}

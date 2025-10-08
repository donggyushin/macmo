import SwiftUI

@main
struct MacmoApp: App {
    
    @StateObject var navigationManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
        }
        
        WindowGroup("New Memo", id: "memo-detail") {
            MemoDetailView(model: MemoDetailViewModel(id: nil))
                .environmentObject(navigationManager)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 500, height: 600)

        WindowGroup("Search Memos", id: "search-memo") {
            SearchMemoView(model: SearchMemoViewModel())
                .environmentObject(navigationManager)
        }
        .windowResizability(.contentSize)
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

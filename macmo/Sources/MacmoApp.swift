import SwiftUI

@main
struct MacmoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        WindowGroup("New Memo", id: "memo-detail") {
            MemoDetailView(model: MemoDetailViewModel(id: nil))
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 500, height: 600)

        WindowGroup("Search Memos", id: "search-memo") {
            SearchMemoView(model: SearchMemoViewModel())
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 600, height: 700)
    }
}

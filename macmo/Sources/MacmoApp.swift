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
    }
}

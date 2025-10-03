import SwiftUI

public struct ContentView: View {
    public init() {}
    
    @EnvironmentObject private var navigationManager: NavigationManager
    
    public var body: some View {
        #if os(macOS)
        MemoListView()
        #else
        NavigationStack(path: $navigationManager.paths) {
            iOSMemoListView()
                .navigationDestination(for: Navigation.self) { navigation in
                    switch navigation {
                    case .detail(let id):
                        MemoDetailView(model: .init(id: id))
                    }
                }
        }
        #endif
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

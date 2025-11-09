import SwiftUI
import MacmoDomain
import MacmoData

public struct ContentView: View {
    public init() {}
    
    @EnvironmentObject private var navigationManager: NavigationManager
    // note: Fancy detail point! Search query exists
    @StateObject var searchModelViewModel = SearchMemoViewModel()
    
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
                    case .setting:
                        SettingView(model: .init())
                    case .search:
                        iOSSearchMemoView(model: searchModelViewModel)
                    }
                }
                .scrollIndicators(.hidden)
        }
        #endif
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

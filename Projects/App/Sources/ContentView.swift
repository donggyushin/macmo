import MacmoData
import MacmoDomain
import SwiftUI

public struct ContentView: View {
    public init() {}

    @EnvironmentObject private var navigationManager: NavigationManager
    // note: Fancy detail point! Search query exists
    @StateObject var searchModelViewModel = SearchMemoViewModel()
    @Namespace var namespace

    public var body: some View {
        #if os(macOS)
        MemoListView()
        #else
        NavigationStack(path: $navigationManager.paths) {
            YearCalendarVerticalListView(model: .init())
                .navigationDestination(for: Navigation.self) { navigation in
                    switch navigation {
                    case .list:
                        iOSMemoListView()
                    case let .detail(id):
                        MemoDetailView(model: .init(id: id))
                    case .setting:
                        SettingView(model: .init())
                    case .search:
                        iOSSearchMemoView(model: searchModelViewModel)
                    case let .calendarVerticalList(date):
                        CalendarVerticalListView(model: .init(date: date))
                            .navigationTransition(.zoom(sourceID: date, in: namespace))
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

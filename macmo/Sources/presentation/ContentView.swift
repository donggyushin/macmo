import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        #if os(macOS)
        MemoListView()
        #else
        iOSMemoListView()
        #endif
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

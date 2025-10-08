import Foundation

final class iOSURLSchemeManager {
    private init() {}

    /// TEST NEEDED
    /// macmo://setting
    /// macmo://search
    /// macmo://memo/{id}
    @MainActor
    static func execute(_ url: URL, _ navigationManager: NavigationManager) {
        if url.absoluteString == "macmo://setting" {
            navigationManager.push(.setting)
        } else if url.absoluteString == "macmo://search" {
            navigationManager.push(.search)
        } else {
            if url.host() == "memo" {
                let memoId = url.path.isEmpty ? nil : url.path
                navigationManager.push(.detail(memoId))
            }
        }
    }
}

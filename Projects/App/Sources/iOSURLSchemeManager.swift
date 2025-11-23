import Foundation
import MacmoDomain

final class iOSURLSchemeManager {
    private init() {}

    /// TEST NEEDED
    /// macmo://setting
    /// macmo://search
    /// macmo://memo/7379ACF6-D4CB-4AEB-A43A-62D72D035CF8
    @MainActor
    static func execute(_ url: URL, _ navigationManager: NavigationManager) {
        if url.absoluteString == "macmo://setting" {
            navigationManager.push(.setting)
        } else if url.absoluteString == "macmo://search" {
            navigationManager.push(.search)
        } else {
            if url.host() == "memo" {
                let pathString = url.path
                let memoId = pathString.isEmpty ? nil : String(pathString.dropFirst())
                navigationManager.push(.detail(memoId))
            }
        }
    }
}

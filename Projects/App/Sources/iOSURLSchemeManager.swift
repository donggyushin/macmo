import Foundation
import MacmoDomain

final class iOSURLSchemeManager {
    private init() {}

    /// Handles URL scheme navigation
    /// - Supported URLs:
    ///   - macmo://setting
    ///   - macmo://search
    ///   - macmo://memo/7379ACF6-D4CB-4AEB-A43A-62D72D035CF8
    @MainActor
    static func execute(_ url: URL, _ navigationManager: NavigationManager) {
        guard let host = url.host() else { return }

        switch host {
        case "setting":
            navigationManager.push(.setting)

        case "search":
            navigationManager.push(.search)

        case "memo":
            let memoId = extractMemoId(from: url)
            navigationManager.push(.detail(memoId, nil))

        default:
            break
        }
    }

    private static func extractMemoId(from url: URL) -> String? {
        let pathString = url.path
        guard !pathString.isEmpty else { return nil }

        // Remove leading slash
        let memoId = String(pathString.dropFirst())
        return memoId.isEmpty ? nil : memoId
    }
}

import Foundation
import MacmoDomain

public final class NavigationServiceImpl: NavigationService {
    @UserDefault(key: "navigations", defaultValue: []) var navigations: [NavigationDomain]

    public init() {}

    public func setNavigationForCache(_ navigations: [NavigationDomain]) {
        self.navigations = navigations
    }

    public func getNavigationForCache() -> [NavigationDomain] {
        navigations
    }
}

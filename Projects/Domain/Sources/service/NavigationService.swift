public protocol NavigationService {
    func setNavigationForCache(_ navigations: [NavigationDomain])
    func getNavigationForCache() -> [NavigationDomain]
}

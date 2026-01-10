import Foundation

public enum NavigationDomain: Codable {
    case list
    case detail(String?)
    case setting
    case search
    case calendarVerticalList(Date?)
}

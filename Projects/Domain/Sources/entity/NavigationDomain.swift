import Foundation

public enum NavigationDomain: Codable {
    case list
    case detail(String?, Date?)
    case setting
    case search
    case calendarVerticalList(Date?)
}

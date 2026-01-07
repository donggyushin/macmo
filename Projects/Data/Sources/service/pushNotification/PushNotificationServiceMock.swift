//
//  PushNotificationServiceMock.swift
//  MacmoData
//
//  Created by ratel on 1/7/26.
//

import Foundation
import MacmoDomain

public final class PushNotificationServiceMock: PushNotificationService {
    public init() {}
    /// Request notification permission from user
    public func requestAuthorization() async throws -> Bool { true }
    /// Schedule a local notification
    /// - Parameters:
    ///   - identifier: Unique identifier for the notification
    ///   - title: Notification title
    ///   - body: Notification body text
    ///   - subtitle: Optional subtitle
    ///   - dueDate: Date when notification should trigger
    /// - Returns: The notification identifier if successful
    public func scheduleNotification(
        identifier _: String,
        title _: String,
        body _: String,
        subtitle _: String?,
        dueDate _: Date
    ) async throws -> String? { nil }

    /// Remove a scheduled notification
    /// - Parameter identifier: The notification identifier to remove
    public func removeNotification(identifier _: String) async throws {}
    /// Remove all pending notifications
    public func removeAllNotifications() async throws {}
    /// Get all pending notification identifiers
    public func getPendingNotificationIdentifiers() async -> [String] { [] }
}

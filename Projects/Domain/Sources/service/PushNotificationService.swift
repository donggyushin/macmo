//
//  PushNotificationService.swift
//  MacmoDomain
//
//  Created by ratel on 1/7/26.
//

import Foundation

public protocol PushNotificationService {
    /// Request notification permission from user
    func requestAuthorization() async throws -> Bool
    /// Schedule a local notification
    /// - Parameters:
    ///   - identifier: Unique identifier for the notification
    ///   - title: Notification title
    ///   - body: Notification body text
    ///   - subtitle: Optional subtitle
    ///   - dueDate: Date when notification should trigger
    /// - Returns: The notification identifier if successful
    func scheduleNotification(
        identifier: String,
        title: String,
        body: String,
        subtitle: String?,
        dueDate: Date
    ) async throws -> String?

    /// Remove a scheduled notification
    /// - Parameter identifier: The notification identifier to remove
    func removeNotification(identifier: String) async throws
    /// Remove all pending notifications
    func removeAllNotifications() async throws
    /// Get all pending notification identifiers
    func getPendingNotificationIdentifiers() async -> [String]
}

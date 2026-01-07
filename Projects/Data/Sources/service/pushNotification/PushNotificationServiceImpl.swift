//
//  PushNotificationServiceImpl.swift
//  MacmoData
//
//  Created by ratel on 1/7/26.
//

import Foundation
import UserNotifications

public final class PushNotificationServiceImpl: PushNotificationService {
    private let notificationCenter = UNUserNotificationCenter.current()

    public init() {}

    /// Request notification permission from user
    public func requestAuthorization() async throws -> Bool {
        let settings = await notificationCenter.notificationSettings()

        if settings.authorizationStatus == .notDetermined {
            return try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        }

        return settings.authorizationStatus == .authorized
    }

    /// Schedule a local notification
    /// - Parameters:
    ///   - identifier: Unique identifier for the notification
    ///   - title: Notification title
    ///   - body: Notification body text
    ///   - subtitle: Optional subtitle
    ///   - dueDate: Date when notification should trigger
    /// - Returns: The notification identifier if successful
    public func scheduleNotification(
        identifier: String,
        title: String,
        body: String,
        subtitle: String? = nil,
        dueDate: Date
    ) async throws -> String? {
        // Don't schedule for past dates
        guard dueDate > Date() else {
            return nil
        }

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        if let subtitle = subtitle {
            content.subtitle = subtitle
        }

        // Create trigger
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        // Create request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Schedule notification
        try await notificationCenter.add(request)

        return identifier
    }

    /// Remove a scheduled notification
    /// - Parameter identifier: The notification identifier to remove
    public func removeNotification(identifier: String) async throws {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    /// Remove all pending notifications
    public func removeAllNotifications() async throws {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    /// Get all pending notification identifiers
    public func getPendingNotificationIdentifiers() async -> [String] {
        let requests = await notificationCenter.pendingNotificationRequests()
        return requests.map { $0.identifier }
    }
}

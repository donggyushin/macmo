import Foundation
import UserNotifications

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    var onNotificationTapped: ((String) -> Void)?

    // 알림을 탭했을 때 호출됨
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // userInfo에서 urlScheme 가져오기
        let userInfo = response.notification.request.content.userInfo

        if let urlScheme = userInfo["urlScheme"] as? String {
            onNotificationTapped?(urlScheme)
        }

        completionHandler()
    }

    // 앱이 포그라운드에 있을 때 알림을 받으면 호출됨 (선택사항)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 앱이 실행 중일 때도 알림을 표시하려면 아래 옵션 사용
        completionHandler([.banner, .sound, .badge])
    }
}

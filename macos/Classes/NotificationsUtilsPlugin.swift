import Cocoa
import UserNotifications
import FlutterMacOS

public class NotificationsUtilsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    NotificationsUtilsSetup.setUp(binaryMessenger: registrar.messenger, api: NotificationsUtilsImpl())
  }
}

public class NotificationsUtilsImpl: NotificationsUtils {
    private let notificationCenter: UNUserNotificationCenter
    
    init () {
        notificationCenter = UNUserNotificationCenter.current()
    }
    
    func getDeliveredNotifications(completion: @escaping (Result<[DeliveredNotification], Error>) -> Void) {
        notificationCenter.getDeliveredNotifications(completionHandler: { result in
            let notifications = result.map({notification in
                return DeliveredNotification(
                    id: NotificationId(iosId: "\(notification.request.identifier)"),
                    title: notification.request.content.title,
                    body: notification.request.content.body,
                    subtitle: notification.request.content.subtitle,
                    threadIdentifier: notification.request.content.threadIdentifier,
                    payload: notification.request.content.userInfo
                )
            })
            completion(Result.success(notifications))
        })
    }
    
    func removeDeliveredNotifications(ids: [NotificationId]) throws {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ids.map {it in it.iosId!})
    }
}


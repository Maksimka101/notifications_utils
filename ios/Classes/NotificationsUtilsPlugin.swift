import Flutter
import UIKit

public class NotificationsUtilsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    NotificationsUtilsSetup.setUp(binaryMessenger: registrar.messenger(), api: NotificationsUtilsImpl())
  }

}

public class NotificationsUtilsImpl: NotificationsUtils {
    private let notificationCenter: UNUserNotificationCenter
    
    init () {
        notificationCenter = UNUserNotificationCenter.current()
    }
    
    func getDeliveredNotifications(completion: @escaping (Result<[DeliveredNotification], Error>) -> Void) {
        notificationCenter.getDeliveredNotifications(completionHandler: { result in
            var notifications : [DeliveredNotification] = []
            for notification in result {
                notifications.append(DeliveredNotification(id: NotificationId(iosId: "\(notification.request.identifier)"),
                                                           body: notification.request.content.body,
                                                           title: notification.request.content.title,
                                                           subtitle: notification.request.content.subtitle,
                                                           threadIdentifier: notification.request.content.threadIdentifier,
                                                           payload: notification.request.content.userInfo
                                                          ))
            }
            completion(Result.success(notifications))
        })
    }
    
    func removeDeliveredNotifications(ids: [NotificationId]) throws {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ids.map {it in it.iosId!})
    }
    
    
}

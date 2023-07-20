// Autogenerated from Pigeon (v10.1.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Generated class from Pigeon that represents data sent in messages.
struct NotificationId {
  var androidId: Int64? = nil
  var iosId: String? = nil

  static func fromList(_ list: [Any?]) -> NotificationId? {
    let androidId: Int64? = list[0] is NSNull ? nil : (list[0] is Int64? ? list[0] as! Int64? : Int64(list[0] as! Int32))
    let iosId: String? = nilOrValue(list[1])

    return NotificationId(
      androidId: androidId,
      iosId: iosId
    )
  }
  func toList() -> [Any?] {
    return [
      androidId,
      iosId,
    ]
  }
}

/// Notification payload class.
///
/// `UNNotificationContent` on iOS.
///
/// Generated class from Pigeon that represents data sent in messages.
struct DeliveredNotification {
  var id: NotificationId
  var title: String
  var body: String
  var subtitle: String
  var threadIdentifier: String
  /// Notification payload.
  ///
  /// Usually a map of strings to some primitive types.
  var payload: [AnyHashable: Any?]

  static func fromList(_ list: [Any?]) -> DeliveredNotification? {
    let id = NotificationId.fromList(list[0] as! [Any?])!
    let title = list[1] as! String
    let body = list[2] as! String
    let subtitle = list[3] as! String
    let threadIdentifier = list[4] as! String
    let payload = list[5] as! [AnyHashable: Any?]

    return DeliveredNotification(
      id: id,
      title: title,
      body: body,
      subtitle: subtitle,
      threadIdentifier: threadIdentifier,
      payload: payload
    )
  }
  func toList() -> [Any?] {
    return [
      id.toList(),
      title,
      body,
      subtitle,
      threadIdentifier,
      payload,
    ]
  }
}

private class NotificationsUtilsCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return DeliveredNotification.fromList(self.readValue() as! [Any?])
      case 129:
        return NotificationId.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class NotificationsUtilsCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? DeliveredNotification {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? NotificationId {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class NotificationsUtilsCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return NotificationsUtilsCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return NotificationsUtilsCodecWriter(data: data)
  }
}

class NotificationsUtilsCodec: FlutterStandardMessageCodec {
  static let shared = NotificationsUtilsCodec(readerWriter: NotificationsUtilsCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol NotificationsUtils {
  /// Returns a list of notifications that are shown in the notification center.
  func getDeliveredNotifications(completion: @escaping (Result<[DeliveredNotification], Error>) -> Void)
  /// Removes the specified notifications from the notification center.
  func removeDeliveredNotifications(ids: [NotificationId]) throws
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class NotificationsUtilsSetup {
  /// The codec used by NotificationsUtils.
  static var codec: FlutterStandardMessageCodec { NotificationsUtilsCodec.shared }
  /// Sets up an instance of `NotificationsUtils` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: NotificationsUtils?) {
    /// Returns a list of notifications that are shown in the notification center.
    let getDeliveredNotificationsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.NotificationsUtils.getDeliveredNotifications", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getDeliveredNotificationsChannel.setMessageHandler { _, reply in
        api.getDeliveredNotifications() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getDeliveredNotificationsChannel.setMessageHandler(nil)
    }
    /// Removes the specified notifications from the notification center.
    let removeDeliveredNotificationsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.NotificationsUtils.removeDeliveredNotifications", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      removeDeliveredNotificationsChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let idsArg = args[0] as! [NotificationId]
        do {
          try api.removeDeliveredNotifications(ids: idsArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      removeDeliveredNotificationsChannel.setMessageHandler(nil)
    }
  }
}

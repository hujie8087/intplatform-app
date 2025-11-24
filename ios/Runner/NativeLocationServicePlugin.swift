import Flutter
import UIKit

@objc public class NativeLocationServicePlugin: NSObject, FlutterPlugin {

    private let service = NativeLocationService()

    @objc public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "native_location_service",
            binaryMessenger: registrar.messenger()
        )

        let instance = NativeLocationServicePlugin()
        instance.service.setMethodChannel(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    @objc public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {

        case "isLocationAvailable":
            result(service.isLocationAvailable())

        case "requestLocationPermission":
            service.requestLocationPermission(result: result)

        case "getLocation":
            service.getLocation(result)

        case "startRealTimeLocation":
            // Flutter 传入的是 Map: {'interval': interval}
            if let args = call.arguments as? [String: Any],
               let interval = args["interval"] as? Double {
                service.startRealTimeLocation(interval: interval, result: result)
            } else if let interval = call.arguments as? Double {
                // 兼容直接传入 Double 的情况
                service.startRealTimeLocation(interval: interval, result: result)
            } else {
                result(FlutterError(code: "BAD_ARGS", message: "Invalid interval argument", details: nil))
            }

        case "stopRealTimeLocation":
            service.stopRealTimeLocation(result: result)

        case "isRealTimeTracking":
            result(service.isRealTimeTracking())

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

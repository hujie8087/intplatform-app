import UIKit
import Flutter
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate {

    var locationService: NativeLocationService?   // ← 必须定义成成员变量
    var methodChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        GeneratedPluginRegistrant.register(with: self)

        // Flutter 根视图
        let controller = window?.rootViewController as! FlutterViewController

        // 初始化 MethodChannel
        methodChannel = FlutterMethodChannel(
            name: "native_location_service",
            binaryMessenger: controller.binaryMessenger
        )

        // 初始化定位服务
        locationService = NativeLocationService()
        locationService?.setMethodChannel(channel: methodChannel!)

        // 注册方法回调
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            self?.handleMethodCall(call: call, result: result)
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {

        guard let service = locationService else {
            result(FlutterError(code: "NO_SERVICE", message: "NativeLocationService not initialized", details: nil))
            return
        }

        switch call.method {
        case "isLocationAvailable":
            result(service.isLocationAvailable())

        case "getLocation":
            service.getLocation(result)

        case "startRealTimeLocation":
            let interval = (call.arguments as? Int) ?? 2000
            service.startRealTimeLocation(interval: Double(interval), result: result)

        case "stopRealTimeLocation":
            service.stopRealTimeLocation(result: result)

        case "isRealTimeTracking":
            result(service.isRealTimeTracking())

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

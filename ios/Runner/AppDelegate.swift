import UIKit
import Flutter
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var locationService: LocationService?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 初始化定位服务
    locationService = LocationService()
    
    // 注册 Method Channel
    if let controller = window?.rootViewController as? FlutterViewController {
        let channel = FlutterMethodChannel(
            name: "native_location_service",
            binaryMessenger: controller.binaryMessenger
        )
        
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            self?.handleMethodCall(call: call, result: result)
        }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let locationService = locationService else {
            result(FlutterError(code: "UNAVAILABLE", message: "Location service not available", details: nil))
            return
        }
        
        switch call.method {
        case "isLocationAvailable":
            let isAvailable = locationService.isLocationAvailable()
            result(isAvailable)
            
        case "requestLocationPermission":
            locationService.requestLocationPermission { granted in
                result(granted)
            }
            
        case "getLocation":
            // 先检查权限
            let status = locationService.getAuthorizationStatus()
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationService.getCurrentLocation { locationData in
                    result(locationData)
                }
            } else {
                result(nil)
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

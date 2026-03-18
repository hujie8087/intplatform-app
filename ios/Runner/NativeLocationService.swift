import Foundation
import CoreLocation
import Flutter

class NativeLocationService: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var getLocationCallback: FlutterResult?
    private var permissionCallback: FlutterResult?
    private var methodChannel: FlutterMethodChannel?

    private var isTracking = false
    private var trackingInterval: TimeInterval = 2.0
    private var timer: Timer?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func setMethodChannel(channel: FlutterMethodChannel) {
        self.methodChannel = channel
    }

    // MARK: 检查定位是否可用（与安卓一致）
    func isLocationAvailable() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    // -------------------------------------------------------
    // MARK: 单次定位 getLocation（与安卓一致逻辑）
    // -------------------------------------------------------
    func getLocation(_ result: @escaping FlutterResult) {
        self.getLocationCallback = result

        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }

        if status == .denied || status == .restricted {
            result(FlutterError(code: "NO_PERMISSION", message: "Location permission denied", details: nil))
            getLocationCallback = nil
            return
        }

        // 尝试获取缓存位置
        if let location = locationManager.location {
            result(locationToMap(location))
            getLocationCallback = nil
            return
        }

        // 请求新位置
        locationManager.requestLocation()

        // 设置 30 秒超时（与安卓一致）
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            guard let self = self else { return }
            if let callback = self.getLocationCallback {
                callback(FlutterError(code: "TIMEOUT", message: "Location request timeout", details: nil))
                self.getLocationCallback = nil
            }
        }
    }

    // MARK: 定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let callback = getLocationCallback, let location = locations.first {
            callback(locationToMap(location))
            getLocationCallback = nil
        }

        if isTracking, let location = locations.last {
            methodChannel?.invokeMethod("onRealTimeLocationUpdate", arguments: locationToMap(location))
        }
    }

    // MARK: 定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let callback = getLocationCallback {
            callback(FlutterError(code: "LOCATION_ERROR", message: error.localizedDescription, details: nil))
            getLocationCallback = nil
        }
    }

    // MARK: 授权变更（用于 getLocation 和 requestLocationPermission）
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 处理 getLocation 的权限回调
        if let callback = getLocationCallback {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                // 尝试获取缓存位置
                if let location = manager.location {
                    callback(locationToMap(location))
                    getLocationCallback = nil
                } else {
                    manager.requestLocation()
                }
            } else if status == .denied || status == .restricted {
                callback(FlutterError(code: "NO_PERMISSION", message: "Location permission denied", details: nil))
                getLocationCallback = nil
            }
        }

        // 处理 requestLocationPermission 的权限回调
        if let callback = permissionCallback {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                callback(true)
                permissionCallback = nil
            } else if status == .denied || status == .restricted {
                callback(false)
                permissionCallback = nil
            }
            // notDetermined 状态继续等待用户选择
        }

        // iOS 兼容：发送定位状态变化回调（模拟 Android 的 onStatusChanged）
        if isTracking {
            let statusString: String
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                statusString = "enabled"
            case .denied, .restricted:
                statusString = "disabled"
            case .notDetermined:
                statusString = "not_determined"
            @unknown default:
                statusString = "unknown"
            }
            methodChannel?.invokeMethod("onLocationStatusChanged", arguments: [
                "provider": "ios",
                "status": statusString
            ])
        }
    }

    // -------------------------------------------------------
    // MARK: 实时定位 startRealTimeLocation（1 秒监听 + 定时器）
    // -------------------------------------------------------
    func startRealTimeLocation(interval: Double, result: @escaping FlutterResult) {
        if isTracking {
            result(false)
            return
        }

        // 检查权限
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted {
            result(FlutterError(code: "NO_PERMISSION", message: "Location permission denied", details: nil))
            return
        }

        if status == .notDetermined {
            result(FlutterError(code: "NO_PERMISSION", message: "Location permission not granted. Please request permission first.", details: nil))
            return
        }

        isTracking = true
        trackingInterval = interval / 1000.0   // 安卓传入毫秒，所以需转换

        locationManager.startUpdatingLocation()

        // iOS 兼容：发送定位提供者启用回调（模拟 Android 的 onProviderEnabled）
        if CLLocationManager.locationServicesEnabled() {
            methodChannel?.invokeMethod("onLocationProviderEnabled", arguments: "ios")
        }

        // 确保 Timer 在主线程运行
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timer = Timer.scheduledTimer(withTimeInterval: self.trackingInterval, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if let location = self.locationManager.location {
                    self.methodChannel?.invokeMethod("onRealTimeLocationUpdate", arguments: self.locationToMap(location))
                }
            }
            // 将 Timer 添加到 RunLoop 以确保在主线程运行
            RunLoop.current.add(self.timer!, forMode: .common)
        }

        result(true)
    }

    // -------------------------------------------------------
    // MARK: 停止实时定位 stopRealTimeLocation
    // -------------------------------------------------------
    func stopRealTimeLocation(result: @escaping FlutterResult) {
        guard isTracking else {
            result(false)
            return
        }

        isTracking = false
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()

        // iOS 兼容：发送定位提供者禁用回调（模拟 Android 的 onProviderDisabled）
        methodChannel?.invokeMethod("onLocationProviderDisabled", arguments: "ios")

        methodChannel?.invokeMethod("onRealTimeLocationStopped", arguments: nil)

        result(true)
    }

    func isRealTimeTracking() -> Bool {
        return isTracking
    }

    func requestLocationPermission(result: @escaping FlutterResult) {
        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined {
            self.permissionCallback = result
            locationManager.requestWhenInUseAuthorization()
            return
        }

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            result(true)
            return
        }

        result(false)
    }

    // MARK: 工具方法：位置转 map（与安卓字段对应）
    private func locationToMap(_ loc: CLLocation) -> [String: Any] {
        return [
            "latitude": loc.coordinate.latitude,
            "longitude": loc.coordinate.longitude,
            "accuracy": loc.horizontalAccuracy,
            "altitude": loc.altitude,
            "speed": loc.speed,
            "heading": loc.course,
            "timestamp": Int64(loc.timestamp.timeIntervalSince1970 * 1000),
            "provider": "ios"
        ]
    }
}

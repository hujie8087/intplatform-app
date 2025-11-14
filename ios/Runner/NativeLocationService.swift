import Foundation
import CoreLocation
import Flutter

class NativeLocationService: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var resultCallback: FlutterResult?
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
        self.resultCallback = result

        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }

        if status == .denied || status == .restricted {
            result(FlutterError(code: "NO_PERMISSION", message: "Location permission denied", details: nil))
            return
        }

        // 尝试获取缓存位置
        if let location = locationManager.location {
            result(locationToMap(location))
            return
        }

        // 请求新位置
        locationManager.requestLocation()

        // 设置 30 秒超时（与安卓一致）
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            guard let self = self else { return }
            if self.resultCallback != nil {
                self.resultCallback?(nil)
                self.resultCallback = nil
            }
        }
    }

    // MARK: 定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let callback = resultCallback, let location = locations.first {
            callback(locationToMap(location))
            resultCallback = nil
        }

        if isTracking, let location = locations.last {
            methodChannel?.invokeMethod("onRealTimeLocationUpdate", arguments: locationToMap(location))
        }
    }

    // MARK: 定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let callback = resultCallback {
            callback(FlutterError(code: "LOCATION_ERROR", message: error.localizedDescription, details: nil))
            resultCallback = nil
        }
    }

    // MARK: 授权变更（用于 getLocation）
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if resultCallback == nil { return }

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
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

        isTracking = true
        trackingInterval = interval / 1000.0   // 安卓传入毫秒，所以需转换

        locationManager.startUpdatingLocation()

        timer = Timer.scheduledTimer(withTimeInterval: trackingInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let location = self.locationManager.location {
                self.methodChannel?.invokeMethod("onRealTimeLocationUpdate", arguments: self.locationToMap(location))
            }
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

        methodChannel?.invokeMethod("onRealTimeLocationStopped", arguments: nil)

        result(true)
    }

    func isRealTimeTracking() -> Bool {
        return isTracking
    }

    func requestLocationPermission(result: @escaping FlutterResult) {
        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined {
            self.resultCallback = result
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

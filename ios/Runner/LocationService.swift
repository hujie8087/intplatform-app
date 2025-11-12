import Foundation
import CoreLocation
import Flutter

public class LocationService: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var locationCompletion: (( [String: Any]?) -> Void)?
    private var permissionCompletion: ((Bool) -> Void)?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // 检查定位服务是否可用
    func isLocationAvailable() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    // 检查定位权限状态
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager?.authorizationStatus ?? .notDetermined
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    // 请求定位权限
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        let status = getAuthorizationStatus()
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            permissionCompletion = completion
            locationManager?.requestWhenInUseAuthorization()
        @unknown default:
            completion(false)
        }
    }
    
    // 获取当前位置
    func getCurrentLocation(completion: @escaping ([String: Any]?) -> Void) {
        let status = getAuthorizationStatus()
        
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            completion(nil)
            return
        }
        
        locationCompletion = completion
        locationManager?.requestLocation()
    }
    
    // CLLocationManagerDelegate 方法
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            locationCompletion?(nil)
            locationCompletion = nil
            return
        }
        
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "accuracy": location.horizontalAccuracy,
            "altitude": location.altitude,
            "speed": location.speed < 0 ? 0 : location.speed,
            "heading": location.course < 0 ? 0 : location.course
        ]
        
        locationCompletion?(locationData)
        locationCompletion = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位错误: \(error.localizedDescription)")
        locationCompletion?(nil)
        locationCompletion = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            permissionCompletion?(true)
        case .denied, .restricted:
            permissionCompletion?(false)
        case .notDetermined:
            break
        @unknown default:
            permissionCompletion?(false)
        }
        permissionCompletion = nil
    }
}
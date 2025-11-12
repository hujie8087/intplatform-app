package com.iwip.intplatform

import android.content.Context
import android.location.*
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import java.util.*
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

class NativeLocationService(private val context: Context) {
    private var locationManager: LocationManager? = null
    private var locationListener: LocationListener? = null
    private var methodChannel: MethodChannel? = null
    private var isTracking = false
    private var trackingInterval = 2000L // 默认2秒
    private var locationUpdateHandler: Handler? = null
    private var locationUpdateRunnable: Runnable? = null
    
    init {
        locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    }
    
    fun setMethodChannel(channel: MethodChannel) {
        methodChannel = channel
    }
    
    // 检查定位服务是否可用
    fun isLocationAvailable(): Boolean {
        return locationManager?.let { lm ->
            lm.isProviderEnabled(LocationManager.GPS_PROVIDER) || 
            lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
        } ?: false
    }
    
    // 获取位置信息
    suspend fun getLocation(): Map<String, Any>? = suspendCoroutine { continuation ->
        locationManager?.let { lm ->
            val providers = lm.getProviders(true)
            var bestLocation: Location? = null
            
            // 尝试从所有可用的提供者获取位置
            for (provider in providers) {
                try {
                    val location = lm.getLastKnownLocation(provider)
                    if (location != null && (bestLocation == null || 
                        location.accuracy > bestLocation!!.accuracy)) {
                        bestLocation = location
                    }
                } catch (e: SecurityException) {
                    // 权限不足
                    continuation.resume(null)
                    return@suspendCoroutine
                } catch (e: Exception) {
                    // 其他异常
                }
            }
            
            if (bestLocation != null) {
                val locationData = mapOf<String, Any>(
                    "latitude" to bestLocation.latitude.toDouble(),
                    "longitude" to bestLocation.longitude.toDouble(),
                    "accuracy" to bestLocation.accuracy.toDouble(),
                    "altitude" to (bestLocation.altitude ?: 0.0).toDouble(),
                    "speed" to (bestLocation.speed ?: 0.0f).toDouble(),
                    "heading" to (bestLocation.bearing ?: 0.0f).toDouble()
                )
                continuation.resume(locationData)
            } else {
                // 如果没有缓存位置，请求新位置
                requestNewLocation(continuation)
            }
        } ?: run {
            continuation.resume(null)
        }
    }
    
    private fun requestNewLocation(continuation: kotlin.coroutines.Continuation<Map<String, Any>?>) {
        locationListener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                val locationData = mapOf<String, Any>(
                    "latitude" to location.latitude.toDouble(),
                    "longitude" to location.longitude.toDouble(),
                    "accuracy" to location.accuracy.toDouble(),
                    "altitude" to (location.altitude ?: 0.0).toDouble(),
                    "speed" to (location.speed ?: 0.0f).toDouble(),
                    "heading" to (location.bearing ?: 0.0f).toDouble()
                )
                locationManager?.removeUpdates(this)
                continuation.resume(locationData)
            }
            
            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
            override fun onProviderEnabled(provider: String) {}
            override fun onProviderDisabled(provider: String) {}
        }
        
        try {
            locationManager?.requestSingleUpdate(
                LocationManager.GPS_PROVIDER, 
                locationListener as LocationListener, 
                null
            )
            
            // 设置超时
            Timer().schedule(object : TimerTask() {
                override fun run() {
                    locationManager?.removeUpdates(locationListener!!)
                    continuation.resume(null)
                }
            }, 30000) // 30秒超时
            
        } catch (e: SecurityException) {
            continuation.resume(null)
        } catch (e: Exception) {
            continuation.resume(null)
        }
    }
    
    // 开始实时定位
    fun startRealTimeLocation(interval: Long = 2000L): Boolean {
        if (isTracking) {
            return false
        }
        
        trackingInterval = interval
        isTracking = true
        
        // 初始化Handler
        locationUpdateHandler = Handler(Looper.getMainLooper())
        
        // 创建定时任务
        locationUpdateRunnable = object : Runnable {
            override fun run() {
                if (isTracking) {
                    // 强制请求位置更新
                    requestLocationUpdate()
                    // 继续下一次定时任务
                    locationUpdateHandler?.postDelayed(this, trackingInterval)
                }
            }
        }
        
        locationListener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                if (isTracking) {
                    val locationData = mapOf<String, Any>(
                        "latitude" to location.latitude.toDouble(),
                        "longitude" to location.longitude.toDouble(),
                        "accuracy" to location.accuracy.toDouble(),
                        "altitude" to (location.altitude ?: 0.0).toDouble(),
                        "speed" to (location.speed ?: 0.0f).toDouble(),
                        "heading" to (location.bearing ?: 0.0f).toDouble(),
                        "timestamp" to System.currentTimeMillis(),
                        "provider" to (location.provider ?: "unknown")
                    )
                    
                    // 发送到Flutter
                    methodChannel?.invokeMethod("onRealTimeLocationUpdate", locationData)
                    Log.d("RealTimeLocation", "位置更新: ${location.latitude}, ${location.longitude}")
                }
            }
            
            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {
                val statusText = when (status) {
                    LocationProvider.AVAILABLE -> "AVAILABLE"
                    LocationProvider.OUT_OF_SERVICE -> "OUT_OF_SERVICE"
                    LocationProvider.TEMPORARILY_UNAVAILABLE -> "TEMPORARILY_UNAVAILABLE"
                    else -> "UNKNOWN"
                }
                
                val statusData = mapOf<String, Any>(
                    "provider" to (provider ?: "unknown"),
                    "status" to statusText
                )
                methodChannel?.invokeMethod("onLocationStatusChanged", statusData)
            }
            
            override fun onProviderEnabled(provider: String) {
                methodChannel?.invokeMethod("onLocationProviderEnabled", provider)
            }
            
            override fun onProviderDisabled(provider: String) {
                methodChannel?.invokeMethod("onLocationProviderDisabled", provider)
            }
        }
        
        try {
            // 请求位置更新，使用最小时间间隔和最小距离
            locationManager?.requestLocationUpdates(
                LocationManager.GPS_PROVIDER,
                1000L, // 1秒最小间隔
                0.0f, // 最小距离0米，任何移动都触发
                locationListener as LocationListener,
                null
            )
            
            // 同时请求网络定位作为备用
            locationManager?.requestLocationUpdates(
                LocationManager.NETWORK_PROVIDER,
                1000L, // 1秒最小间隔
                0.0f, // 最小距离0米
                locationListener as LocationListener,
                null
            )
            
            // 启动定时任务
            locationUpdateHandler?.post(locationUpdateRunnable!!)
            
            Log.d("RealTimeLocation", "开始实时定位，间隔: ${interval}ms")
            return true
            
        } catch (e: SecurityException) {
            Log.e("RealTimeLocation", "安全异常: ${e.message}")
            isTracking = false
            return false
        } catch (e: Exception) {
            Log.e("RealTimeLocation", "开始实时定位失败: ${e.message}")
            isTracking = false
            return false
        }
    }
    
    // 强制请求位置更新
    private fun requestLocationUpdate() {
        try {
            // 尝试从GPS获取位置
            val gpsLocation = locationManager?.getLastKnownLocation(LocationManager.GPS_PROVIDER)
            if (gpsLocation != null) {
                val locationData = mapOf<String, Any>(
                    "latitude" to gpsLocation.latitude.toDouble(),
                    "longitude" to gpsLocation.longitude.toDouble(),
                    "accuracy" to gpsLocation.accuracy.toDouble(),
                    "altitude" to (gpsLocation.altitude ?: 0.0).toDouble(),
                    "speed" to (gpsLocation.speed ?: 0.0f).toDouble(),
                    "heading" to (gpsLocation.bearing ?: 0.0f).toDouble(),
                    "timestamp" to System.currentTimeMillis(),
                    "provider" to (gpsLocation.provider ?: "gps")
                )
                methodChannel?.invokeMethod("onRealTimeLocationUpdate", locationData)
                Log.d("RealTimeLocation", "定时位置更新: ${gpsLocation.latitude}, ${gpsLocation.longitude}")
                return
            }
            
            // 如果GPS没有位置，尝试网络定位
            val networkLocation = locationManager?.getLastKnownLocation(LocationManager.NETWORK_PROVIDER)
            if (networkLocation != null) {
                val locationData = mapOf<String, Any>(
                    "latitude" to networkLocation.latitude.toDouble(),
                    "longitude" to networkLocation.longitude.toDouble(),
                    "accuracy" to networkLocation.accuracy.toDouble(),
                    "altitude" to (networkLocation.altitude ?: 0.0).toDouble(),
                    "speed" to (networkLocation.speed ?: 0.0f).toDouble(),
                    "heading" to (networkLocation.bearing ?: 0.0f).toDouble(),
                    "timestamp" to System.currentTimeMillis(),
                    "provider" to (networkLocation.provider ?: "network")
                )
                methodChannel?.invokeMethod("onRealTimeLocationUpdate", locationData)
                Log.d("RealTimeLocation", "定时位置更新(网络): ${networkLocation.latitude}, ${networkLocation.longitude}")
            }
        } catch (e: SecurityException) {
            Log.e("RealTimeLocation", "请求位置更新权限异常: ${e.message}")
        } catch (e: Exception) {
            Log.e("RealTimeLocation", "请求位置更新异常: ${e.message}")
        }
    }
    
    // 停止实时定位
    fun stopRealTimeLocation(): Boolean {
        if (!isTracking) {
            return false
        }
        
        isTracking = false
        
        // 停止定时任务
        locationUpdateRunnable?.let { runnable ->
            locationUpdateHandler?.removeCallbacks(runnable)
        }
        locationUpdateRunnable = null
        locationUpdateHandler = null
        
        // 移除位置监听器
        locationListener?.let { listener ->
            locationManager?.removeUpdates(listener)
        }
        locationListener = null
        
        methodChannel?.invokeMethod("onRealTimeLocationStopped", null)
        Log.d("RealTimeLocation", "停止实时定位")
        return true
    }
    
    // 检查是否正在跟踪
    fun isRealTimeTracking(): Boolean {
        return isTracking
    }
}
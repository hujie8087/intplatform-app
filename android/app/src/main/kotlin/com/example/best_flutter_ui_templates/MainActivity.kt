package com.iwip.intplatform

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.location.LocationManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.location.Location
import android.location.LocationListener
import android.Manifest
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.core.app.ActivityCompat
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.Timer
import java.util.TimerTask
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.iwip.intplatform"
    private val LOCATION_CHANNEL = "native_location_service"
    private lateinit var methodChannel: MethodChannel
    private lateinit var locationChannel: MethodChannel
    private var scanReceiver: BroadcastReceiver? = null
    private var locationManager: LocationManager? = null
    private var locationListener: LocationListener? = null
    private var realTimeLocationListener: LocationListener? = null
    private var isRealTimeTracking = false
    private var realTimeUpdateInterval: Long = 100000 // 默认10秒更新间隔
    private lateinit var nativeLocationService: NativeLocationService
// 权限请求码
    private val LOCATION_PERMISSION_REQUEST_CODE = 1001

    // 定位提供者状态常量
    companion object {
        private const val PROVIDER_STATUS_OUT_OF_SERVICE = 0
        private const val PROVIDER_STATUS_TEMPORARILY_UNAVAILABLE = 1
        private const val PROVIDER_STATUS_AVAILABLE = 2
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 初始化主通道
        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)

        // 初始化定位通道
        locationChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, LOCATION_CHANNEL)

        // 初始化原生定位服务
        nativeLocationService = NativeLocationService(this)
        nativeLocationService.setMethodChannel(locationChannel)

        // 设置主通道处理器
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "installApk" -> {
                    val apkPath = call.argument<String>("apkPath")
                    if (apkPath != null) {
                        installApk(apkPath)
                        result.success("OK")
                    } else {
                        result.error("INVALID_ARGUMENT", "APK path is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // 设置定位通道处理器
        locationChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isLocationAvailable" -> {
                    result.success(nativeLocationService.isLocationAvailable())
                }
                "requestLocationPermission" -> {
                    // 添加权限请求处理
                    requestLocationPermission(result)
                }
                "getLocation" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        val location = nativeLocationService.getLocation()
                        result.success(location)
                    }
                }
                "startRealTimeLocation" -> {
                    // 开始实时定位
                    val interval = try {
                        when (val intervalArg = call.argument<Any>("interval")) {
                            is Int -> intervalArg.toLong()
                            is Long -> intervalArg
                            is Number -> intervalArg.toLong()
                            else -> 2000L
                        }
                    } catch (e: Exception) {
                        2000L
                    }
                    val success = nativeLocationService.startRealTimeLocation(interval)
                    result.success(success)
                }
                "stopRealTimeLocation" -> {
                    // 停止实时定位
                    val success = nativeLocationService.stopRealTimeLocation()
                    result.success(success)
                }
                "isRealTimeTracking" -> {
                    // 检查是否正在实时定位
                    result.success(nativeLocationService.isRealTimeTracking())
                }
                else -> result.notImplemented()
            }
        }

        // 初始化位置管理器
        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

        // 扫描广播接收器
        scanReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val scanData = intent?.getStringExtra("data")
                scanData?.let {
                    methodChannel.invokeMethod("onScanResult", it)
                }
            }
        }

        val filter = IntentFilter().apply { addAction("16888") }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(scanReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(scanReceiver, filter)
        }
    }

    private fun installApk(apkPath: String) {
        val apkFile = File(apkPath)
        if (!apkFile.exists()) return

        val apkUri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            FileProvider.getUriForFile(this, "${packageName}.fileprovider", apkFile)
        } else {
            Uri.fromFile(apkFile)
        }

        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(apkUri, "application/vnd.android.package-archive")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        startActivity(intent)
    }

    // 检查定位服务是否可用
    private fun isLocationAvailable(): Boolean {
        return locationManager?.let { lm ->
            lm.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
            lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
        } ?: false
    }

    // 获取位置信息 - 修正类型转换问题
    private suspend fun getLocation(): Map<String, Any>? = suspendCoroutine { continuation ->
        // 检查权限
        val hasPermission = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        if (!hasPermission) {
            continuation.resume(null)
            return@suspendCoroutine
        }

        locationManager?.let { lm ->
            val providers = lm.getProviders(true)
            var bestLocation: Location? = null

            // 尝试从所有可用的提供者获取最后已知位置
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
                    // 其他异常，继续尝试下一个提供者
                }
            }

            if (bestLocation != null) {
                val locationData = HashMap<String, Any>().apply {
                    put("latitude", bestLocation.latitude.toDouble())
                    put("longitude", bestLocation.longitude.toDouble())
                    put("accuracy", bestLocation.accuracy.toDouble())
                    put("altitude", (bestLocation.altitude ?: 0.0).toDouble())
                    put("speed", (bestLocation.speed ?: 0.0f).toDouble())
                    put("heading", (bestLocation.bearing ?: 0.0f).toDouble())
                }
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
                val locationData = HashMap<String, Any>().apply {
                    put("latitude", location.latitude.toDouble())
                    put("longitude", location.longitude.toDouble())
                    put("accuracy", location.accuracy.toDouble())
                    put("altitude", (location.altitude ?: 0.0).toDouble())
                    put("speed", (location.speed ?: 0.0f).toDouble())
                    put("heading", (location.bearing ?: 0.0f).toDouble())
                }
                locationManager?.removeUpdates(this)
                continuation.resume(locationData)
            }

            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {
                // 处理状态变化
                val statusText = when (status) {
                    PROVIDER_STATUS_OUT_OF_SERVICE -> "OUT_OF_SERVICE"
                    PROVIDER_STATUS_TEMPORARILY_UNAVAILABLE -> "TEMPORARILY_UNAVAILABLE"
                    PROVIDER_STATUS_AVAILABLE -> "AVAILABLE"
                    else -> "UNKNOWN"
                }
                Log.d("Location", "状态改变: $provider -> $statusText")
            }

            override fun onProviderEnabled(provider: String) {
                Log.d("Location", "提供者启用: $provider")
            }

            override fun onProviderDisabled(provider: String) {
                Log.d("Location", "提供者禁用: $provider")
            }
        }

        try {
            // 优先使用 GPS 提供者
            locationManager?.requestSingleUpdate(
                LocationManager.GPS_PROVIDER,
                locationListener as LocationListener,
                null
            )

            // 设置超时（30秒）
            Timer().schedule(object : TimerTask() {
                override fun run() {
                    locationListener?.let { listener ->
                        locationManager?.removeUpdates(listener)
                    }
                    continuation.resume(null)
                }
            }, 30000)

        } catch (e: SecurityException) {
            continuation.resume(null)
        } catch (e: Exception) {
            // 如果 GPS 失败，尝试网络提供者
            try {
                locationManager?.requestSingleUpdate(
                    LocationManager.NETWORK_PROVIDER,
                    locationListener as LocationListener,
                    null
                )

                Timer().schedule(object : TimerTask() {
                    override fun run() {
                        locationListener?.let { listener ->
                            locationManager?.removeUpdates(listener)
                        }
                        continuation.resume(null)
                    }
                }, 30000)

            } catch (e2: Exception) {
                continuation.resume(null)
            }
        }
    }
    // ========== 实时定位功能 ==========

    // 开始实时定位
    private fun startRealTimeLocation(interval: Long): Boolean {
        // 检查权限
        val hasPermission = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        if (!hasPermission) {
            Log.e("RealTimeLocation", "没有定位权限")
            return false
        }

        if (isRealTimeTracking) {
            // 如果已经在跟踪，先停止
            stopRealTimeLocation()
        }

        realTimeUpdateInterval = interval
        isRealTimeTracking = true

        realTimeLocationListener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                // 将位置信息发送到 Flutter
                val locationData = HashMap<String, Any>().apply {
                    put("latitude", location.latitude.toDouble())
                    put("longitude", location.longitude.toDouble())
                    put("accuracy", location.accuracy.toDouble())
                    put("altitude", (location.altitude ?: 0.0).toDouble())
                    put("speed", (location.speed ?: 0.0f).toDouble())
                    put("heading", (location.bearing ?: 0.0f).toDouble())
                    put("timestamp", System.currentTimeMillis())
                    put("provider", location.provider ?: "unknown")
                }

                // 发送实时位置更新到 Flutter
                CoroutineScope(Dispatchers.Main).launch {
                    locationChannel.invokeMethod("onRealTimeLocationUpdate", locationData)
                }
                Log.d("RealTimeLocation", "位置更新: ${location.latitude}, ${location.longitude}")
            }

            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {
                val statusText = when (status) {
                    PROVIDER_STATUS_OUT_OF_SERVICE -> "OUT_OF_SERVICE"
                    PROVIDER_STATUS_TEMPORARILY_UNAVAILABLE -> "TEMPORARILY_UNAVAILABLE"
                    PROVIDER_STATUS_AVAILABLE -> "AVAILABLE"
                    else -> "UNKNOWN"
                }
                Log.d("RealTimeLocation", "状态改变: $provider -> $statusText")

                // 发送状态变化到 Flutter
                val statusData = HashMap<String, Any>().apply {
                    put("provider", provider ?: "unknown")
                    put("status", statusText)
                }
                CoroutineScope(Dispatchers.Main).launch {
                    locationChannel.invokeMethod("onLocationStatusChanged", statusData)
                }
            }

            override fun onProviderEnabled(provider: String) {
                Log.d("RealTimeLocation", "提供者启用: $provider")
                CoroutineScope(Dispatchers.Main).launch {
                    locationChannel.invokeMethod("onLocationProviderEnabled", provider)
                }
            }

            override fun onProviderDisabled(provider: String) {
                Log.d("RealTimeLocation", "提供者禁用: $provider")
                CoroutineScope(Dispatchers.Main).launch {
                    locationChannel.invokeMethod("onLocationProviderDisabled", provider)
                }
            }
        }

        try {
            // 请求位置更新
            locationManager?.requestLocationUpdates(
                LocationManager.GPS_PROVIDER,
                realTimeUpdateInterval,
                1f, // 最小距离变化（米）
                realTimeLocationListener as LocationListener
            )

            // 同时监听网络定位
            locationManager?.requestLocationUpdates(
                LocationManager.NETWORK_PROVIDER,
                realTimeUpdateInterval,
                10f, // 网络定位可以设置更大的距离变化
                realTimeLocationListener as LocationListener
            )

            Log.d("RealTimeLocation", "开始实时定位，间隔: ${interval}ms")
            return true

        } catch (e: SecurityException) {
            Log.e("RealTimeLocation", "安全异常: ${e.message}")
            isRealTimeTracking = false
            return false
        } catch (e: Exception) {
            Log.e("RealTimeLocation", "开始实时定位失败: ${e.message}")
            isRealTimeTracking = false
            return false
        }
    }

    // 停止实时定位
    private fun stopRealTimeLocation() {
        realTimeLocationListener?.let { listener ->
            locationManager?.removeUpdates(listener)
            realTimeLocationListener = null
        }
        isRealTimeTracking = false
        Log.d("RealTimeLocation", "停止实时定位")

        // 通知 Flutter 实时定位已停止
        CoroutineScope(Dispatchers.Main).launch {
            locationChannel.invokeMethod("onRealTimeLocationStopped", null)
        }
    }

    // 检查是否有定位权限
    private fun hasLocationPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
    }

    override fun onDestroy() {
        super.onDestroy()
        // 取消注册扫描接收器
        scanReceiver?.let { unregisterReceiver(it) }

        // 移除位置监听器
        locationListener?.let { listener ->
            locationManager?.removeUpdates(listener)
        }
         // 停止实时定位
        stopRealTimeLocation()
    }
    // 添加权限请求方法
    private fun requestLocationPermission(result: MethodChannel.Result) {
        val permissions = arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION
        )

        // 检查是否已有权限
        val hasFineLocation = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        val hasCoarseLocation = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        if (hasFineLocation && hasCoarseLocation) {
            // 已经有权限
            result.success(true)
            return
        }

        // 请求权限
        ActivityCompat.requestPermissions(this, permissions, LOCATION_PERMISSION_REQUEST_CODE)

        // 注意：这里不能立即返回结果，需要在 onRequestPermissionsResult 中处理
        // 暂时返回 true，实际权限状态在 getLocation 中会再次检查
        result.success(true)
    }

    // 处理权限请求结果
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            // 可以在这里处理权限请求结果，或者发送到 Flutter
            val granted = grantResults.isNotEmpty() &&
                        grantResults[0] == PackageManager.PERMISSION_GRANTED

            // 可以通过 MethodChannel 将结果发送到 Flutter
            locationChannel.invokeMethod("onPermissionResult", granted)
        }
    }
}
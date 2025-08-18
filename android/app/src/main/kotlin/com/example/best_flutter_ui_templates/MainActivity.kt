package com.iwip.intplatform

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Build
import android.os.Bundle
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.iwip.intplatform"
    private lateinit var methodChannel: MethodChannel
    private var scanReceiver: BroadcastReceiver? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)

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

        scanReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val scanData = intent?.getStringExtra("data")
                scanData?.let {
                    methodChannel.invokeMethod("onScanResult", it)
                }
            }
        }

        val filter = IntentFilter().apply { addAction("16888") }
        registerReceiver(scanReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
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

    override fun onDestroy() {
        super.onDestroy()
        scanReceiver?.let { unregisterReceiver(it) }
    }
}

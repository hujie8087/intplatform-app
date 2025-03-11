package com.iwip.intplatform
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.iwip.intplatform"
    private lateinit var methodChannel: MethodChannel
    private var scanReceiver: BroadcastReceiver? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
        
        scanReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val scanData = intent?.getStringExtra("data") // 替换成你的广播 key
                scanData?.let {
                    methodChannel.invokeMethod("onScanResult", it)
                }
            }
        }

        val filter = IntentFilter().apply { addAction("16888") }
        registerReceiver(scanReceiver, filter,Context.RECEIVER_NOT_EXPORTED)
    }

    override fun onDestroy() {
        super.onDestroy()
        scanReceiver?.let { unregisterReceiver(it) }
    }
}

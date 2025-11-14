package com.iwip.intplatform

import android.content.*
import android.os.Bundle
import android.util.Log
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.SwitchCompat
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.view.View
import com.example.iscandemo.iScanInterface
import com.example.iscandemo.ConstantUtil
import android.os.IScanListener
import android.os.IScanImageCallBackListener


class ScanServiceActivity : AppCompatActivity(), View.OnClickListener {

    private lateinit var mFocusResult: EditText
    private lateinit var mCallbackResult: TextView
    private lateinit var mBroadcastResult: TextView
    private lateinit var mDecodeSucceedBeep: SwitchCompat
    private lateinit var mOpenScanKey: SwitchCompat
    private lateinit var mStartScan: Button
    private lateinit var mStopScan: Button
    private lateinit var mFocusOutput: Button
    private lateinit var mBroadcastOutput: Button
    private lateinit var mHidOutput: Button

    private val RES_ACTION = "android.intent.action.SCANRESULT"
    private val RES_LABEL = "value"

    private lateinit var scanReceiver: BroadcastReceiver
    private lateinit var miScanInterface: iScanInterface

    private val miScanListener = object : IScanListener {
        override fun onScanResults(
            data: String?,
            type: Int,
            decodeTime: Long,
            keyDownTime: Long,
            imagePath: String?
        ) {
            val result = data ?: "decode error"
            val finalData = "$result\n"
            runOnUiThread {
                mCallbackResult.text = finalData
                mCallbackResult.append(getString(R.string.decode_result, type, decodeTime))
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        miScanInterface = iScanInterface(this)
        miScanInterface.registerScan(miScanListener)

        initView()
        registerBroadcast()
    }

    private fun initView() {
        mFocusResult = findViewById(R.id.focus_result)
        mCallbackResult = findViewById(R.id.callback_result)
        mBroadcastResult = findViewById(R.id.broadcast_result)
        mDecodeSucceedBeep = findViewById(R.id.decode_succeed_beep)
        mOpenScanKey = findViewById(R.id.open_scan_key)
        mStartScan = findViewById(R.id.start_scan)
        mStopScan = findViewById(R.id.stop_scan)
        mFocusOutput = findViewById(R.id.focus_output)
        mBroadcastOutput = findViewById(R.id.broadcast_output)
        mHidOutput = findViewById(R.id.hid_output)

        mDecodeSucceedBeep.setOnClickListener(this)
        mOpenScanKey.setOnClickListener(this)
        mStartScan.setOnClickListener(this)
        mStopScan.setOnClickListener(this)
        mFocusOutput.setOnClickListener(this)
        mBroadcastOutput.setOnClickListener(this)
        mHidOutput.setOnClickListener(this)

        mFocusResult.requestFocus()
    }

    private fun registerBroadcast() {
        val intentFilter = IntentFilter()
        intentFilter.addAction(RES_ACTION)
        scanReceiver = ScannerResultReceiver()
        registerReceiver(scanReceiver, intentFilter)
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.decode_succeed_beep -> miScanInterface.enablePlayBeep(mDecodeSucceedBeep.isChecked)
            R.id.open_scan_key -> miScanInterface.lockScanKey(mOpenScanKey.isChecked)
            R.id.start_scan -> {
                miScanInterface.scan_start()
                miScanInterface.setMultiBarEnable(true)
            }
            R.id.stop_scan -> {
                miScanInterface.scan_stop()
                miScanInterface.setMultiBarEnable(false)
            }
            R.id.focus_output -> miScanInterface.setOutputMode(0)
            R.id.broadcast_output -> miScanInterface.setOutputMode(1)
            R.id.hid_output -> miScanInterface.setOutputMode(2)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        miScanInterface.unregisterScan(miScanListener)
        unregisterReceiver(scanReceiver)
    }

    private inner class ScannerResultReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            Log.e("idata", "intent.getAction()-->${intent.action}")
            if (intent.action == RES_ACTION) {
                val scanData = intent.getStringExtra(RES_LABEL)
                scanData?.let {
                    Log.e("idata", "recv = $it")
                    mBroadcastResult.text = it
                }
            }
        }
    }
}

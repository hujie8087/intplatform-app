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

class NativeLocationService extends AppCompatActivity implements View.OnClickListener {

    public EditText mFocusResult;
    public TextView mCallbackResult,mBroadcastResult;
    public SwitchCompat mDecodeSucceedBeep,mOpenScanKey;
    public Button mStartScan,mStopScan,mFocusOutput,mBroadcastOutput,mHidOutput;

    //iscan 默认扫描结果广播
    private static final String RES_ACTION = "android.intent.action.SCANRESULT";
    private static final String RES_LABEL = "value";
    BroadcastReceiver scanReceiver;

    //iScan接口
    private iScanInterface miScanInterface;

    //数据回调监听
    private IScanListener miScanListener = new IScanListener() {

        /*
         * param data 扫描数据
         * param type 条码类型
         * param decodeTime 扫描时间
         * param keyDownTime 按键按下的时间
         * param imagePath 图片存储地址，通常用于ocr识别需求（需要先开启保存图片才有效）
         */
        @Override
        public void onScanResults(String data, int type, long decodeTime, long keyDownTime,String imagePath) {

            //解码失败
            if(data == null || data.isEmpty()){
                data = "  decode error ";
            }

            // 更新UI界面
            String finalData = data + "\n";
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mCallbackResult.setText(finalData);
                    mCallbackResult.append(getString(R.string.decode_result,type,decodeTime));
                }
            });
        }
    };


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //创建iScanInterface实例化对象
        miScanInterface = new iScanInterface(this);

        //注册iScanInterface 数据回调监听
        miScanInterface.registerScan(miScanListener);

        initView();
        registerBroadcast();

    }

    /*
     * 描述：初始化并绑定UI布局
     */
    public void initView(){

        //初始化UI对象
        mFocusResult = findViewById(R.id.focus_result);
        mCallbackResult= findViewById(R.id.callback_result);
        mBroadcastResult= findViewById(R.id.broadcast_result);
        mDecodeSucceedBeep = findViewById(R.id.decode_succeed_beep);
        mOpenScanKey = findViewById(R.id.open_scan_key);
        mStartScan = findViewById(R.id.start_scan);
        mStopScan = findViewById(R.id.stop_scan);
        mFocusOutput = findViewById(R.id.focus_output);
        mBroadcastOutput = findViewById(R.id.broadcast_output);
        mHidOutput = findViewById(R.id.hid_output);

        //绑定按键监听
        mDecodeSucceedBeep.setOnClickListener(this);
        mOpenScanKey.setOnClickListener(this);

        mStartScan.setOnClickListener(this);
        mStopScan.setOnClickListener(this);
        mFocusOutput.setOnClickListener(this);
        mBroadcastOutput.setOnClickListener(this);
        mHidOutput.setOnClickListener(this);

        // 获取焦点
        mFocusResult.requestFocus();

    }

    private void registerBroadcast(){
        //扫描结果广播监听注册
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(RES_ACTION);

        //注册广播接受者
        scanReceiver = new ScannerResultReceiver();
        registerReceiver(scanReceiver, intentFilter);
    }

    @Override
    public void onClick(View v) {

        switch (v.getId()){

            case R.id.decode_succeed_beep:
                /* 配置扫描成功是否播放声音 */
                miScanInterface.enablePlayBeep(mDecodeSucceedBeep.isChecked());
                break;

            case R.id.open_scan_key:
                /* 是否启用扫描按键 */
                miScanInterface.lockScanKey(mOpenScanKey.isChecked());
                break;

            case R.id.start_scan:
                /* 开始扫描 */
                miScanInterface.scan_start();
                miScanInterface.setMultiBarEnable(true);
                break;

            case R.id.stop_scan:
                /* 停止扫描 */
                miScanInterface.scan_stop();
                miScanInterface.setMultiBarEnable(false);
                break;

            case R.id.focus_output:
                /*配置扫描结果输出方式
                 * mode  0：焦点输出   （没有焦点的时候会误触发UI）
                 *       1：广播输出    action：android.intent.action.SCANRESULT
                 *       2：模拟按键输出   （没有焦点的时候会误触发UI）
                 *       3：复制到粘贴板
                 */
                miScanInterface.setOutputMode(0);
                break;

            case R.id.broadcast_output:
                miScanInterface.setOutputMode(1);
                break;

            case R.id.hid_output:
                miScanInterface.setOutputMode(2);
                break;
        }

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        //注销iScanInterface 数据回调监听
        miScanInterface.unregisterScan(miScanListener);
        unregisterReceiver(scanReceiver);
    }

    /**
     * 扫描结果广播接收
     */
    //*********重要
    private class ScannerResultReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            Log.e("idata","intent.getAction()-->"+intent.getAction());//

            if (intent.getAction().equals(RES_ACTION)){
                //获取扫描结果
                String scan_data = intent.getStringExtra(RES_LABEL);
                if(scan_data!=null){
                    Log.e("idata","recv = " + scan_data);
                    mBroadcastResult.setText(scan_data);
                }
            }
        }
    }


}
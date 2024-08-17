import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:logistics_app/api/firebase_api.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/firebase_options.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/http_utils.dart';
import 'package:logistics_app/http/log_utils.dart';
import 'package:logistics_app/http/model/app_check_update_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/device_utils.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pub_semver/pub_semver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  await _checkConnectivity();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  initXUpdate();
  LogUtils.init();
  HttpUtils.initDio();
  checkUpdate();
  runApp(MyApp());
}

Future<void> _checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  _updateNetworkType(connectivityResult);

  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    _updateNetworkType(result);
  });
}

void _updateNetworkType(ConnectivityResult result) {
  switch (result) {
    case ConnectivityResult.mobile:
      HttpUtils.setBaseUrl(APIs.apiPrefix);
      SpUtils.saveString(Constants.SP_IMAGE_PREFIX, APIs.imagePrefix);
      break;
    case ConnectivityResult.wifi:
      HttpUtils.setBaseUrl(APIs.apiPrefix);
      SpUtils.saveString(Constants.SP_IMAGE_PREFIX, APIs.imagePrefix);
      break;
    case ConnectivityResult.none:
      break;
  }
}

///初始化
void initXUpdate() {
  if (Platform.isAndroid) {
    FlutterXUpdate.init(

            ///是否输出日志
            debug: true,

            ///是否使用post请求
            isPost: false,

            ///post请求是否是上传json
            isPostJson: false,

            ///请求响应超时时间
            timeout: 25000,

            ///是否开启自动模式
            isWifiOnly: false,

            ///是否开启自动模式
            isAutoMode: false,

            ///需要设置的公共参数
            supportSilentInstall: false,

            ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
            enableRetry: false)
        .then((value) {
      print('初始化成功: $value');
      FlutterXUpdate.setErrorHandler(
        onUpdateError: (Map<String, dynamic>? message) async {
          print("下载错误: $message");
        },
      );
      FlutterXUpdate.setCustomParseHandler();
    }).catchError((error) {
      print(error);
    });
  } else {
    //showToast('ios暂不支持XUpdate更新');
  }
}

///检查更新
Future checkUpdate() async {
  if (Platform.isAndroid) {
    //获取当前app的版本code
    String versionCode = await DeviceUtils.version();
    String versionName = await DeviceUtils.version();
    String downloadUrlPre = await SpUtils.getString(Constants.SP_IMAGE_PREFIX);
    DataUtils.getAppLastVersion(
      success: (data) {
        UpdateInfoData updateModel = UpdateInfoData.fromJson(data['data']);
        //线上版本的code
        Version oldVersion = Version.parse(versionName);
        Version newVersion = Version.parse(updateModel.versionName);
        try {
          //如果当前版本小于线上版本，需要更新
          if (oldVersion == newVersion) {
            SpUtils.saveString(
                Constants.SP_NEW_APP_VERSION, updateModel.versionName);
          } else {
            SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
          }
          if (oldVersion < newVersion) {
            UpdateEntity customParseJson() {
              return UpdateEntity(
                  isForce: true,
                  hasUpdate: true,
                  isIgnorable: false,
                  versionCode: int.parse(updateModel.versionCode),
                  versionName: updateModel.versionName,
                  updateContent: updateModel.updateLog,
                  downloadUrl: downloadUrlPre + updateModel.apkUrl,
                  apkSize: updateModel.apkSize);
            }

            FlutterXUpdate.updateByInfo(updateEntity: customParseJson());
          }
        } catch (e) {
          SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
        }
      },
    );
  }
}

/// 设计尺寸
Size get designSize {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  // 逻辑短边
  final logicalShortestSide =
      firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  // 逻辑长边
  final logicalLongestSide =
      firstView.physicalSize.longestSide / firstView.devicePixelRatio;
  // 缩放比例 designSize越小，元素越大
  const scaleFactor = 0.95;
  // 缩放后的逻辑短边和长边
  return Size(
      logicalShortestSide * scaleFactor, logicalLongestSide * scaleFactor);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return OKToast(
        //屏幕适配父组件组件
        child: ScreenUtilInit(
      designSize: designSize,
      builder: (context, child) {
        return MaterialApp(
          title: 'IWIP后勤服务',
          debugShowCheckedModeBanner: false,
          locale: const Locale('zh', 'CN'),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            platform: TargetPlatform.iOS,
            navigationBarTheme: const NavigationBarThemeData(
              backgroundColor: Colors.white,
              indicatorColor: Colors.transparent,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.darkText,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
            useMaterial3: false,
          ),
          navigatorKey: RouteUtils.navigatorKey,
          onGenerateRoute: Routes.generateRoute,
          initialRoute: RoutePath.home,
          // home:FitnessAppHomeScreen(),
        );
      },
    ));
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

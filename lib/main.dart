import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/http_utils.dart';
import 'package:logistics_app/http/log_utils.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:mobpush_plugin/mobpush_custom_message.dart';
import 'package:mobpush_plugin/mobpush_notify_message.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:oktoast/oktoast.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // //上传隐私协议许可
  // MobpushPlugin.updatePrivacyPermissionStatus(true).then((value) {
  //   print(
  //       ">>>>>>>>>>>>>>>>>>>updatePrivacyPermissionStatus:" + value.toString());
  // });
  // if (Platform.isIOS) {
  //   //设置地区：regionId 默认0（国内），1:海外
  //   MobpushPlugin.setRegionId(0);
  //   MobpushPlugin.registerApp(
  //       "3a2cebc425f10", "c91dab150797b3c47374c379c4bb9426");
  // }
  // initPlatformState();
  // if (Platform.isIOS) {
  //   MobpushPlugin.setCustomNotification();
  //   MobpushPlugin.setAPNsForProduction(true);
  // }
  // MobpushPlugin.addPushReceiver(_onEvent, _onError);
  await _checkConnectivity();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  initXUpdate();
  LogUtils.init();
  HttpUtils.initDio();
  String languageCode = await SpUtils.getString('locale') ?? 'zh';
  runApp(MyApp(
    languageCode: languageCode,
  ));
}

void _onEvent(dynamic event) {
  print('>>>>>>>>>>>>>>>>>>>>>>>>>>>onEvent:' + event.toString());
  Map<String, dynamic> eventMap = json.decode(event as String);
  Map<String, dynamic> result = eventMap['result'];
  int action = eventMap['action'];

  switch (action) {
    case 0:
      MobPushCustomMessage message = new MobPushCustomMessage.fromJson(result);
      ProgressHUD.showInfo(message.content);
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         content: Text(message.content),
      //         actions: <Widget>[
      //           TextButton(
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //             child: Text("确定")
      //           )
      //         ],
      //       );
      // });
      break;
    case 1:
      MobPushNotifyMessage message = new MobPushNotifyMessage.fromJson(result);
      print(message);
      ProgressHUD.showInfo(message.content);
      break;
    case 2:
      MobPushNotifyMessage message = new MobPushNotifyMessage.fromJson(result);
      print(message);
      break;
  }
}

void _onError(dynamic event) {
  print('>>>>>>>>>>>>>>>>>>>>>>>>>>>onError:' + event.toString());
}

Future<void> initPlatformState() async {
  String sdkVersion;
  String _registrationId;
  try {
    sdkVersion = await MobpushPlugin.getSDKVersion();
  } on PlatformException {
    sdkVersion = 'Failed to get platform version.';
  }
  try {
    Future.delayed(Duration(milliseconds: 500), () {
      MobpushPlugin.getRegistrationId().then((Map<String, dynamic> ridMap) {
        print(ridMap);
        _registrationId = ridMap['res'].toString();
        print('------>#### registrationId: ' + _registrationId);
      });
    });
  } on PlatformException {
    _registrationId = 'Failed to get registrationId.';
  }
  print('sdkVersion$sdkVersion');
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

///初始化在线升级
void initXUpdate() async {
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
  const MyApp({Key? key, required this.languageCode}) : super(key: key);
  final String languageCode;
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
          onGenerateTitle: (context) {
            return S.of(context).appTitle;
          },
          debugShowCheckedModeBanner: false,
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('zh', 'CN'),
            const Locale('id', 'ID'),
          ],
          locale: languageCode == 'en'
              ? Locale('en', 'US')
              : languageCode == 'id'
                  ? Locale('id', 'ID')
                  : Locale('zh', 'CN'),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            SpUtils.getString('locale').then((languageCode) {
              // 如果语言是英语
              if (languageCode == 'en') {
                //注意大小写，返回美国英语
                S.load(Locale('en', 'US'));
                return const Locale('en', 'US');
              } else if (languageCode == 'id') {
                S.load(Locale('id', 'ID'));
                return const Locale('id', 'ID');
              } else {
                S.load(Locale('zh', 'CN'));
                return const Locale('zh', 'CN');
              }
            });
          },
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

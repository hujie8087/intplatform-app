import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/firebase_service.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/error_handle.dart';
import 'package:logistics_app/http/http_utils.dart';
import 'package:logistics_app/http/log_utils.dart';
import 'package:logistics_app/route/auto_route_generator.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quick_actions/quick_actions.dart';

import 'firebase_options.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 注册所有注解路由
  // RouteRegistry.registerAllAnnotatedRoutes();

  initializeFirebase();
  // 设置竖屏
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  initXUpdate();
  LogUtils.init();
  HttpUtils.initDio();
  // notifyInit();
  String languageCode = await SpUtils.getString('locale') ?? 'zh';
  runApp(OverlaySupport.global(child: MyApp(languageCode: languageCode)));
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> initializeFirebase() async {
  if (Platform.isAndroid) {
    final availability =
        await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability();

    if (availability != GooglePlayServicesAvailability.success) {
      print("Google Play 服务不可用: $availability");
      return; // 跳过 Firebase 初始化
    }
  }

  try {
    // 初始化Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 判断firebase是否初始化成功
    final connectivityStatus = await FirebaseMessaging.instance.getToken();
    if (connectivityStatus != null) {
      // 初始化Firebase推送
      await FirebaseService().initNotifications();
      await FirebaseService().notifyInit();
    }
  } catch (e) {
    print("初始化Firebase失败: $e");
  }
}

///初始化在线级
void initXUpdate() async {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(debug: true);
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
    logicalShortestSide * scaleFactor,
    logicalLongestSide * scaleFactor,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.languageCode}) : super(key: key);
  final String languageCode;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final QuickActions quickActions = const QuickActions();
  String? _pendingShortcut;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    quickActions.setShortcutItems([
      const ShortcutItem(type: "qrcode", localizedTitle: "付款码", icon: "qrcode"),
      const ShortcutItem(
        type: "shopping",
        localizedTitle: "在线点餐",
        icon: "cart",
      ),
      const ShortcutItem(type: "bus", localizedTitle: "公交时刻表", icon: "bus"),
    ]);

    quickActions.initialize((String shortcutType) {
      // 如果 context 还没准备好，先缓存
      if (!mounted) {
        _pendingShortcut = shortcutType;
        return;
      }
      _handleShortcut(shortcutType);
    });

    // 应用启动完成后，检查是否有待处理的 shortcut
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pendingShortcut != null) {
        _handleShortcut(_pendingShortcut!);
        _pendingShortcut = null;
      }
    });
  }

  void _handleShortcut(String shortcutType) {
    print("iOS快捷键触发: $shortcutType");
    switch (shortcutType) {
      case "qrcode":
        print("跳转到付款码页面");
        RouteUtils.navigatorKey.currentState?.pushNamed(
          RoutePath.PaymentQRCodePage,
        );
        break;
      case "shopping":
        print("跳转到在线点餐页面");
        RouteUtils.navigatorKey.currentState?.pushNamed(
          RoutePath.ShoppingScreenPage,
        );
        break;
      case "bus":
        print("跳转到公交时刻表页面");
        RouteUtils.navigatorKey.currentState?.pushNamed(
          RoutePath.RouteQueryPage,
        );
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SpUtils.getString(Constants.SP_TOKEN).then((token) {
        if (token != null) {
          // 应用从后台返回前台时刷新 token
          _checkAndRefreshToken();
        }
      });
    }
  }

  Future<void> _checkAndRefreshToken() async {
    String refreshToken = await SpUtils.getString(Constants.SP_REFRESH_TOKEN);
    DataUtils.updateToken(
      {'refreshToken': refreshToken},
      success: (data) async {
        var token = data['data']['accessToken'];
        var refreshToken = data['data']['refreshToken'];
        await SpUtils.saveString(Constants.SP_TOKEN, token ?? "");
        await SpUtils.saveString(
          Constants.SP_REFRESH_TOKEN,
          refreshToken ?? "",
        );
      },
      fail: (code, msg) {
        print('refreshToken fail: $code, $msg');
        if (code == ExceptionHandle.refresh_token_invalid) {
          SpUtils.remove(Constants.SP_TOKEN);
          SpUtils.remove(Constants.SP_REFRESH_TOKEN);
          RouteUtils.navigateToLogin();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness:
            !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return OKToast(
      //屏幕适配父组件组件
      child: ScreenUtilInit(
        designSize: designSize,
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              builder: (context, child) {
                // 初始化屏幕适配
                ScreenAdapterHelper.init(context);
                return child!;
              },
              onGenerateTitle: (context) {
                return S.of(context).appTitle;
              },
              debugShowCheckedModeBanner: false,
              supportedLocales: const [
                Locale('zh', 'CN'),
                Locale('en', ''),
                Locale('id', ''),
              ],
              locale: const Locale('zh', 'CN'),
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
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
                return null;
              },
              theme: ThemeData(
                scaffoldBackgroundColor: backgroundColor,
                primarySwatch: primaryColor,
                platform: TargetPlatform.iOS,
                iconTheme: const IconThemeData(size: 20),
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
              navigatorObservers: [routeObserver],
              onGenerateRoute: Routes.generateRoute,
              initialRoute: RoutePath.home,
              // home:FitnessAppHomeScreen(),
            ),
          );
        },
      ),
    );
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

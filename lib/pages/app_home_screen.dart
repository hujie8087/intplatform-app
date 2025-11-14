// import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_update_dialog/update_dialog.dart';
// import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:logistics_app/common_ui/navigation/navigation_bar_item.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/app_check_update_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/home_page/home_page.dart';
import 'package:logistics_app/pages/mine_page/mine_page.dart';
import 'package:logistics_app/pages/models/tabIcon_data.dart';
import 'package:logistics_app/pages/repair/report_hazard_page.dart';
import 'package:logistics_app/pages/sos/sos_index_page.dart';
import 'package:logistics_app/pages/tool_box_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/device_utils.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

// 在文件顶部定义全局 key
final GlobalKey<_AppHomeScreenState> appHomeScreenKey =
    GlobalKey<_AppHomeScreenState>();

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({Key? key}) : super(key: key);

  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final GlobalKey<NavigationBarItemState> navigationKey =
      GlobalKey<NavigationBarItemState>();
  double _progress = -1;
  UpdateDialog? _updateDialog;

  List<TabIconData> _tabIconsList = [];
  int _grooveIndex = 2;

  void _loadTabIcons() {
    setState(() {
      if (_tabIconsList.isEmpty) {
        _tabIconsList = <TabIconData>[
          TabIconData(
            imagePath: 'assets/images/tab_1.png',
            selectedImagePath: 'assets/images/tab_1s1.png',
            index: 0,
            isSelected: true,
            animationController: animationController,
            labelName: '', // 先设为空，在build中设置
          ),
          TabIconData(
            imagePath: 'assets/images/tab_danger1.png',
            selectedImagePath: 'assets/images/tab_danger1s.png',
            index: 1,
            isSelected: true,
            animationController: animationController,
            labelName: '', // 先设为空，在build中设置
          ),
          TabIconData(
            imagePath: 'assets/images/tab_tool1.png',
            selectedImagePath: 'assets/images/tab_tool21.png',
            index: 2,
            isSelected: false,
            animationController: animationController,
            labelName: '', // 先设为空，在build中设置
          ),
          // TabIconData(
          //   imagePath: 'assets/images/tab_warn.png',
          //   selectedImagePath: 'assets/images/tab_warn1.png',
          //   index: 3,
          //   isSelected: false,
          //   animationController: animationController,
          //   labelName: '', // 先设为空，在build中设置
          // ),
          TabIconData(
            imagePath: 'assets/images/tab_4.png',
            selectedImagePath: 'assets/images/tab_4s1.png',
            index: 3,
            isSelected: false,
            animationController: animationController,
            labelName: '', // 先设为空，在build中设置
          ),
        ];
      }
    });
  }

  // 更新tab标签名称
  void _updateTabLabels() {
    if (_tabIconsList.isNotEmpty) {
      _tabIconsList[0].labelName = S.of(context).homePage;
      _tabIconsList[1].labelName = S.of(context).dangerPage;
      _tabIconsList[2].labelName = S.of(context).toolPage;
      // _tabIconsList[3].labelName = S.of(context).warningPage;
      _tabIconsList[3].labelName = S.of(context).minePage;
    }
  }

  Widget tabBody = Container(color: Colors.white);

  Future<bool> isLogin() async {
    final token = await SpUtils.getString(Constants.SP_TOKEN);
    if (token == null || token.isEmpty) {
      ProgressHUD.showText(S.of(context).needLogin);
      RouteUtils.navigateToLogin();
      return false;
    } else {
      // 用Completer来等待回调
      final completer = Completer<bool>();
      DataUtils.getThirdUserInfo(
        success: (res) async {
          ThirdUserInfoModel userInfo = ThirdUserInfoModel.fromJson(
            res['data'],
          );
          await SpUtils.saveModel('thirdUserInfo', userInfo);
          SpUtils.saveString(Constants.SP_USER_NAME, userInfo.name ?? '');
          SpUtils.saveString(
            Constants.SP_USER_DEPT,
            userInfo.formatOrganizeName ?? '',
          );
          completer.complete(true);
        },
        fail: (code, msg) {
          DataUtils.logout(
            success: (data) {
              SpUtils.remove(Constants.SP_USER_NAME);
              SpUtils.remove(Constants.SP_USER_DEPT);
              SpUtils.remove(Constants.SP_TOKEN);
              Navigator.pushNamed(context, '/login');
            },
          );
          completer.complete(false);
        },
      );
      return completer.future;
    }
  }

  ///检查更新
  Future checkUpdate(BuildContext context) async {
    //获取当前app的版本code
    String versionCode = await DeviceUtils.version();
    String downloadUrlPre = 'https://web.iwipwedabay.com/static/';
    DataUtils.getAppLastVersion(
      success: (data) async {
        UpdateInfoData updateModel = UpdateInfoData.fromJson(data['data']);

        if (updateModel.update == true) {
          //线上版本的code
          try {
            if (Platform.isAndroid) {
              // checkUpdateFlutterXUpdate(updateModel, downloadUrlPre);
              // downloadApk(downloadUrlPre + updateModel.apkUrl);
              _updateDialog = UpdateDialog.showUpdate(
                context,
                title: '发现新版本 v${updateModel.versionName ?? ''}',
                updateContent: updateModel.content ?? '',
                themeColor: Color.fromRGBO(255, 101, 50, 1),
                updateButtonText: S.of(context).updateNow,
                topImage: Image.asset('assets/images/bg_update_top.png'),
                isForce: true,
                onUpdate: () async {
                  if (updateModel.updateType == 3) {
                    final url = Uri.parse(updateModel.url ?? '');
                    // 替换为外部的链接
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  } else {
                    downloadApk(downloadUrlPre + (updateModel.url ?? ''));
                  }
                },
                progress: _progress,
              );
            } else {
              UpdateDialog.showUpdate(
                context,
                title: S.of(context).updateAppStore,
                updateContent: updateModel.content ?? '',
                themeColor: Color.fromRGBO(255, 101, 50, 1),
                updateButtonText: S.of(context).updateNow,
                topImage: Image.asset('assets/images/bg_update_top.png'),
                isForce: true,
                onUpdate: () async {
                  final url = Uri.parse(
                    'https://apps.apple.com/app/id6667111068',
                  );
                  // 替换为你的应用在 App Store 的链接
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              );
            }
          } catch (e) {
            SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
          }
        }
      },
    );
  }

  Future<void> downloadApk(String apkUrl) async {
    try {
      // 获取存储路径
      Directory? dir = await getExternalStorageDirectory();
      String savePath = '${dir?.path}/update.apk';

      // 开始下载
      await Dio().download(
        apkUrl,
        savePath,
        onReceiveProgress: (count, total) {
          double progress = count / total * 100;
          print('下载进度: ${progress.toStringAsFixed(1)}%');
          setState(() {
            _progress = progress;
            _updateDialog?.update(count / total);
          });
        },
      );

      print("下载完成: $savePath");

      // 下载完成后打开 APK
      installApk(savePath);
    } catch (e) {
      print("下载失败: $e");
    }
  }

  void installApk(String apkPath) async {
    try {
      await InstallApkUtils.installApk(apkPath);
    } on PlatformException catch (e) {
      debugPrint("Error launching intent: ${e.message}");
    }
  }

  @override
  void initState() {
    _loadTabIcons();
    _tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    _tabIconsList[_grooveIndex].isSelected = true;

    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    super.initState();
    handleTabChanged(_grooveIndex);
    // tabBody = HomePage(
    //     animationController: animationController, onChanged: handleTabChanged);
    checkUpdate(context);
  }

  void handleTabChanged(int newValue) async {
    _tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    _tabIconsList[newValue].isSelected = true;
    setState(() {
      _grooveIndex = newValue;
    });
    animationController?.reverse().then<dynamic>((data) async {
      if (!mounted) {
        return;
      }
      switch (newValue) {
        case 0:
          setState(() {
            tabBody = HomePage(onChanged: handleTabChanged);
          });
          break;
        case 1:
          setState(() {
            tabBody = ReportHazardPage();
          });
          break;
        case 2:
          setState(() {
            tabBody = ToolBoxPage();
          });
          break;
        // case 3:
        //   setState(() {
        //     tabBody = SosIndexPage();
        //   });
        //   break;
        case 3:
          await isLogin();
          setState(() {
            tabBody = MinePage();
          });
          break;
      }
      navigationKey.currentState?.setRemoveAllSelection(
        _tabIconsList[newValue],
      );
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 在build方法中更新标签名称
    _updateTabLabels();

    return WillPopScope(
      onWillPop: () async {
        // 如果是主页面，返回时退出应用
        SystemNavigator.pop(); // 或 exit(0)，但不推荐
        // 禁用返回行为
        return false;
      },
      child: Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: FutureBuilder<bool>(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                return Stack(children: <Widget>[tabBody, bottomBar()]);
              }
            },
          ),
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(child: SizedBox()),
        NavigationBarItem(
          key: navigationKey,
          tabIconsList: _tabIconsList,
          changeIndex: (int index) {
            handleTabChanged(index);
          },
          grooveIndex: _grooveIndex,
        ),
      ],
    );
  }
}

class InstallApkUtils {
  static const MethodChannel _channel = MethodChannel('com.iwip.intplatform');

  static Future<void> installApk(String apkPath) async {
    try {
      await _channel.invokeMethod('installApk', {'apkPath': apkPath});
    } on PlatformException catch (e) {
      print('安装 APK 失败: ${e.message}');
    }
  }
}

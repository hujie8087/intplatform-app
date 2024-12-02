// import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_update_dialog/update_dialog.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
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
import 'package:logistics_app/pages/tool_box_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/device_utils.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

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

  List<TabIconData> _tabIconsList = [];

  void updateTabIconsList() {
    _loadTabIcons();
    setState(() {});
  }

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
            labelName: S.current.homePage,
          ),
          TabIconData(
            imagePath: 'assets/images/tab_tool1.png',
            selectedImagePath: 'assets/images/tab_tool21.png',
            index: 1,
            isSelected: false,
            animationController: animationController,
            labelName: S.current.toolPage,
          ),
          TabIconData(
            imagePath: 'assets/images/tab_4.png',
            selectedImagePath: 'assets/images/tab_4s1.png',
            index: 2,
            isSelected: false,
            animationController: animationController,
            labelName: S.current.minePage,
          ),
        ];
      } else {
        _tabIconsList[0].labelName = S.current.homePage;
        _tabIconsList[1].labelName = S.current.toolPage;
        _tabIconsList[2].labelName = S.current.minePage;
      }
    });
  }

  Widget tabBody = Container(
    color: Colors.white,
  );

  Future<bool> isLogin() async {
    // 判断是否登录
    final token = await SpUtils.getString(Constants.SP_TOKEN);
    if (token == null || token.isEmpty) {
      ProgressHUD.showText(S.of(context).needLogin);
      RouteUtils.navigateToLogin();
      return false;
    } else {
      DataUtils.getUserInfo(
        success: (res) async {
          UserInfoModel userInfo = UserInfoModel.fromJson(res['data']);
          await SpUtils.saveModel('userInfo', userInfo);
          SpUtils.saveString(
              Constants.SP_USER_NAME, userInfo.user?.nickName ?? '');
          SpUtils.saveString(
              Constants.SP_USER_DEPT, userInfo.user?.dept?.deptName ?? '');
          return true;
        },
        fail: (code, msg) {
          DataUtils.logout(
            success: (data) {
              //清除缓存
              SpUtils.remove(Constants.SP_USER_NAME);
              SpUtils.remove(Constants.SP_USER_DEPT);
              SpUtils.remove(Constants.SP_TOKEN);
              Navigator.pushNamed(context, '/login');
            },
          );
          return false;
        },
      );
      return true;
    }
  }

  ///检查更新
  Future checkUpdate(BuildContext context) async {
    //获取当前app的版本code
    String versionCode = await DeviceUtils.version();
    String versionName = await DeviceUtils.version();
    String downloadUrlPre = APIs.imagePrefix;
    DataUtils.getAppLastVersion(
      success: (data) async {
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
            if (Platform.isAndroid) {
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

              FlutterXUpdate.updateByInfo(
                  updateEntity: customParseJson(),
                  themeColor: '#ff6532',
                  buttonTextColor: '#ffffff',
                  topImageRes: 'bg_update_top');
            } else {
              UpdateDialog.showUpdate(context,
                  title: S.of(context).updateAppStore,
                  updateContent: updateModel.updateLog ?? '',
                  themeColor: Color.fromRGBO(255, 101, 50, 1),
                  updateButtonText: S.of(context).updateNow,
                  topImage: Image.asset('assets/images/bg_update_top.png'),
                  isForce: true, onUpdate: () async {
                final url =
                    Uri.parse('https://apps.apple.com/app/id6667111068');
                // 替换为你的应用在 App Store 的链接
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              });
            }
          }
        } catch (e) {
          SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
        }
      },
    );
  }

  @override
  void initState() {
    _loadTabIcons();
    _tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    _tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    super.initState();
    _handleTabChanged(0);
    // tabBody = HomePage(
    //     animationController: animationController, onChanged: _handleTabChanged);

    checkUpdate(context);
  }

  void _handleTabChanged(int newValue) async {
    _tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    _tabIconsList[newValue].isSelected = true;
    animationController?.reverse().then<dynamic>((data) async {
      if (!mounted) {
        return;
      }
      switch (newValue) {
        case 0:
          setState(() {
            tabBody = HomePage(
                animationController: animationController,
                onChanged: _handleTabChanged);
          });
          break;
        case 1:
          setState(() {
            tabBody = ToolBoxPage();
          });
          break;
        case 2:
          await isLogin();
          setState(() {
            tabBody = MinePage(
              animationController: animationController,
              updateTabIconsList: updateTabIconsList,
            );
          });
          break;
      }
      navigationKey.currentState
          ?.setRemoveAllSelection(_tabIconsList[newValue]);
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
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
                  return Stack(
                    children: <Widget>[
                      tabBody,
                      bottomBar(),
                    ],
                  );
                }
              },
            ),
          ),
        ));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        NavigationBarItem(
          key: navigationKey,
          tabIconsList: _tabIconsList,
          changeIndex: (int index) {
            _handleTabChanged(index);
          },
        ),
      ],
    );
  }
}

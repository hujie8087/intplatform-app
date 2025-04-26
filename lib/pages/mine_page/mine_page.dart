import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/avatar_widget.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:flutter_update_dialog/update_dialog.dart';
import 'package:logistics_app/common_ui/divider_widget.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
// import 'package:logistics_app/common_ui/xupdate.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/app_check_update_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/auth/login_page.dart';
import 'package:logistics_app/pages/mine_page/change_password_page.dart';
import 'package:logistics_app/pages/mine_page/contact_us_page.dart';
import 'package:logistics_app/pages/mine_page/mine_view_model.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/my_address_page.dart';
import 'package:logistics_app/pages/mine_page/person_info_page.dart';
import 'package:logistics_app/pages/news/notice_page/notice_list_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/device_utils.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with TickerProviderStateMixin {
  var model = MineViewModel();

  Animation<double>? opacityAnimation;
  Animation<double>? offsetAnimation;
  String version = '';
  String localeName = '中文';
  UserInfoModel? userInfo;
  AnimationController? animationController;
  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    animationController!.forward();
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // 模拟异步数据获取
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    }
    version = await DeviceUtils.version();
    var languageCode = await SpUtils.getString('locale');
    if (languageCode == 'en') {
      localeName = 'English';
    } else if (languageCode == 'id') {
      localeName = 'Indonesia';
    } else {
      localeName = '中文';
    }
    // 更新状态
    setState(() {});
  }

  Future _changeLocale(value, context) async {
    setState(() {
      localeName = value;
      SpUtils.saveString('locale', value);
      if (value == 'en') {
        localeName = 'English';
        S.load(Locale('en', 'US'));
      } else if (value == 'id') {
        localeName = 'Indonesia';
        S.load(Locale('id', 'ID'));
      } else {
        localeName = '中文';
        S.load(Locale('zh', 'CN'));
      }
      // widget.updateTabIconsList();
      Navigator.pop(context);
      // Restart.restartApp();
    });
  }

  Future wxPicker(BuildContext context) {
    return Picker.showModalSheet(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            Text('中文'),
            onTap: () {
              _changeLocale('zh', context);
            },
          ),
          DividerWidget(),
          _buildButton(
            Text('English'),
            onTap: () {
              _changeLocale('en', context);
            },
          ),
          DividerWidget(),
          _buildButton(
            Text('Indonesia'),
            onTap: () {
              _changeLocale('id', context);
            },
          ),
        ],
      ),
    );
  }

  static InkWell _buildButton(Widget child, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40.px,
        child: child,
      ),
    );
  }

  Animation<double> createOffsetAnimation(double endValue) {
    return Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Interval(0.0, endValue, curve: Curves.fastOutSlowIn),
      ),
    );
  }

  double _progress = -1;
  UpdateDialog? _updateDialog;

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
              Constants.SP_NEW_APP_VERSION,
              updateModel.versionName,
            );
          } else {
            SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
          }
          if (oldVersion < newVersion) {
            if (Platform.isAndroid) {
              // checkUpdateFlutterXUpdate(updateModel, downloadUrlPre);
              // downloadApk(downloadUrlPre + updateModel.apkUrl);
              _updateDialog = UpdateDialog.showUpdate(
                context,
                title: '${S.current.newVersion} v${newVersion}',
                updateContent: updateModel.updateLog ?? '',
                themeColor: Color.fromRGBO(255, 101, 50, 1),
                updateButtonText: S.of(context).updateNow,
                topImage: Image.asset('assets/images/bg_update_top.png'),
                isForce: true,
                onUpdate: () async {
                  downloadApk(downloadUrlPre + updateModel.apkUrl);
                },
                progress: _progress,
              );
            } else {
              UpdateDialog.showUpdate(
                context,
                title: S.of(context).updateAppStore,
                updateContent: updateModel.updateLog ?? '',
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
          } else {
            ProgressHUD.showText(S.current.currentVersionIsLatest);
          }
        } catch (e) {
          SpUtils.saveString(Constants.SP_NEW_APP_VERSION, versionCode);
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
      // 下载完成后打开 APK
      installApk(savePath);
    } catch (e) {
      print("下载失败: $e");
    }
  }

  void installApk(String apkPath) async {
    try {
      final Uri contentUri = Uri.parse('content://${apkPath}');

      final intent = AndroidIntent(
        action: 'action_view',
        data: contentUri.toString(),
        type: 'application/vnd.android.package-archive',
        flags: [
          Flag.FLAG_ACTIVITY_NEW_TASK,
          Flag.FLAG_GRANT_READ_URI_PERMISSION,
        ],
      );

      await intent.launch();
    } on PlatformException catch (e) {
      debugPrint("Error launching intent: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapterHelper.init(context);
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Container(
        color: AppTheme.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20.px, top: 10.px, right: 20.px),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _personCard(),
                    SizedBox(height: 10.px),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.px,
                        right: 10.px,
                        top: 20.px,
                      ),
                      child: Column(
                        children: [
                          _commonItem(
                            S.of(context).userInfo,
                            Icons.account_circle,
                            () {
                              RouteUtils.push(context, PersonInfoPage());
                            },
                            '',
                            0.2,
                          ),
                          _commonItem(
                            S.of(context).changePassword,
                            Icons.lock,
                            () async {
                              var res = await RouteUtils.push(
                                context,
                                ChangePasswordPage(),
                              );
                              if (res != null) {
                                ProgressHUD.showText(res['msg']);
                              }
                            },
                            '',
                            0.3,
                          ),
                          _commonItem(
                            S.of(context).notifications,
                            Icons.notifications,
                            () {
                              RouteUtils.push(context, NoticeListPage());
                            },
                            '',
                            0.4,
                          ),
                          _commonItem(
                            S.of(context).myAddress,
                            Icons.location_on,
                            () {
                              RouteUtils.push(context, MyAddressPage());
                            },
                            '',
                            0.5,
                          ),
                          // 留言反馈
                          // _commonItem(
                          //     S.of(context).myFeedback, Icons.feedback, () {
                          //   RouteUtils.push(context, FeedbackPage());
                          // }, '', 0.6),
                          // 语言设置
                          _commonItem(
                            S.of(context).changeLanguage,
                            Icons.language,
                            () {
                              wxPicker(context);
                            },
                            localeName,
                            0.6,
                          ),
                          // _commonItem(
                          //     '清除缓存', Icons.delete_rounded, () {}, '', 0.7),
                          _commonItem(
                            S.of(context).contactUs,
                            Icons.info,
                            () {
                              RouteUtils.push(context, ContactUsPage());
                            },
                            '',
                            0.8,
                          ),
                          _commonItem(
                            S.of(context).appVersion,
                            Icons.update,
                            () {
                              checkUpdate(context);
                            },
                            version,
                            0.9,
                          ),
                          _logoutButton(
                            () => DialogFactory.new().showConfirmDialog(
                              context: context,
                              title: S.of(context).logout,
                              content: S.of(context).logoutTip,
                              confirmClick: () {
                                // 退出登录
                                model
                                    .logout()
                                    .then(
                                      (value) => {
                                        ProgressHUD.showText(
                                          S.of(context).logoutSuccess,
                                        ),
                                        RouteUtils.push(context, LoginPage()),
                                      },
                                    )
                                    .catchError(
                                      (e) => {
                                        ProgressHUD.showError(
                                          S.of(context).logoutFailed,
                                        ),
                                      },
                                    );
                              },
                            ),
                          ),
                          SizedBox(height: 50.px),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 人物卡片
  Widget _personCard() {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacityAnimation!,
          child: Transform.translate(
            offset: Offset(0.0, 40.px * (1.0 - opacityAnimation!.value)),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).mine,
                        style: TextStyle(
                          fontSize: 18.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.px),
                  Container(
                    padding: EdgeInsets.all(10.px),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.3)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(10.px),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: primaryColor.withOpacity(0.6),
                          offset: const Offset(1.0, 1.1),
                          blurRadius: 10.0,
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage('assets/images/person_bg.png'),
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                AvatarWidget(width: 60.px),
                                SizedBox(width: 10.px),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userInfo?.user?.nickName ?? '',
                                      style: TextStyle(
                                        fontSize: 14.px,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 5.px),
                                    Text(
                                      userInfo?.user?.userName ?? '',
                                      style: TextStyle(
                                        fontSize: 14.px,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 5.px),
                                    Text(
                                      userInfo?.user?.dept?.deptName ?? '',
                                      style: TextStyle(
                                        fontSize: 12.px,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // 职位
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.px),
                        Row(
                          children: [
                            Text(
                              S.of(context).cardBalance,
                              style: TextStyle(
                                fontSize: 14.px,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 5.px),
                            Text(
                              userInfo?.user?.money ?? '',
                              style: TextStyle(
                                fontSize: 24.px,
                                letterSpacing: -1,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _commonItem(
    String title,
    IconData icon,
    GestureTapCallback? onTap,
    String? subTitle,
    animationValue,
  ) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacityAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              100.px * createOffsetAnimation(animationValue).value,
              0.0,
            ),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                margin: EdgeInsets.only(bottom: 10.px),
                padding: EdgeInsets.only(bottom: 10.px),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                ),
                child: Row(
                  children: [
                    // 带背景的色的图标
                    Icon(icon, color: primaryColor, size: 22.px),
                    SizedBox(width: 10.px),
                    Expanded(
                      child: Text(title, style: TextStyle(fontSize: 14.px)),
                    ),
                    Text(subTitle ?? '', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10.px),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16.px,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///退出登录按钮
  Widget _logoutButton(GestureTapCallback? onTap) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacityAnimation!,
          child: Transform.translate(
            offset: Offset(0.0, 40.px * (1.0 - opacityAnimation!.value)),
            child: Container(
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  height: 36.px,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: 30.px,
                    right: 30.px,
                    top: 40.px,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.all(Radius.circular(15.px)),
                  ),
                  child: Text(
                    S.of(context).logout,
                    style: TextStyle(color: Colors.white, fontSize: 14.px),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

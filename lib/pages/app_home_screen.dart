// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/navigation/navigation_bar_item.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/home_page/home_page.dart';
import 'package:logistics_app/pages/mine_page/mine_page.dart';
import 'package:logistics_app/pages/models/tabIcon_data.dart';
import 'package:logistics_app/pages/tool_box_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class AppHomeScreen extends StatefulWidget {
  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final GlobalKey<NavigationBarItemState> navigationKey = GlobalKey();
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
      ProgressHUD.showText('请登录您的帐号');
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
  }

  void _handleTabChanged(int newValue) async {
    _tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    _tabIconsList[newValue].isSelected = true;
    if (newValue == 0) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabBody = HomePage(
              animationController: animationController,
              onChanged: _handleTabChanged);
        });
      });
    } else if (newValue == 1) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          // tabBody = ShoppingScreenPage();
          tabBody = ToolBoxPage();
        });
      });
    } else if (newValue == 2) {
      await isLogin();
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabBody = MinePage(
            animationController: animationController,
            updateTabIconsList: updateTabIconsList,
          );
        });
      });
    }
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
          addClick: () {
            setState(() {
              tabBody = ToolBoxPage();
              _handleTabChanged(4);
            });
          },
          changeIndex: (int index) {
            _handleTabChanged(index);
          },
        ),
      ],
    );
  }
}

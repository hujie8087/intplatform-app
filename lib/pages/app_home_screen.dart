// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/navigation/navigation_bar_item.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/pages/film_page/film_screen_page.dart';
import 'package:logistics_app/pages/home_page/home_page.dart';
import 'package:logistics_app/pages/mine_page/mine_page.dart';
import 'package:logistics_app/pages/models/tabIcon_data.dart';
import 'package:logistics_app/pages/shopping/shopping_screen_page.dart';
import 'package:logistics_app/pages/tool_box_page.dart';
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
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: Colors.white,
  );

  @override
  void initState() {
    // 判断是否登录
    SpUtils.getString(Constants.SP_TOKEN).then((token) => {
          if (token == null || token.isEmpty)
            {Navigator.pushNamed(context, '/login')}
        });

    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    // tabBody = HomePage(
    //     animationController: animationController, onChanged: _handleTabChanged);
    super.initState();
    _handleTabChanged(0);
  }

  void _handleTabChanged(int newValue) {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    if (newValue != 4) {
      tabIconsList[newValue].isSelected = true;
    }
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
          tabBody = ShoppingScreenPage();
        });
      });
    } else if (newValue == 2) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabBody = FilmScreenPage(animationController: animationController);
        });
      });
    } else if (newValue == 3) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabBody = MinePage(animationController: animationController);
        });
      });
    } else if (newValue == 4) {
      animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          tabBody = ToolBoxPage();
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
          tabIconsList: tabIconsList,
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

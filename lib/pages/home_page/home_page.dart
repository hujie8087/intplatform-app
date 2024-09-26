import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/avatar_widget.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/pages/news_page/news_list_page.dart';
import 'package:logistics_app/pages/notice_page/notice_detail_page.dart';
import 'package:logistics_app/pages/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/notice_page/notice_view_model.dart';
import 'package:logistics_app/pages/repair/my_repair_page.dart';
import 'package:logistics_app/pages/repair/repair_form_page.dart';
import 'package:logistics_app/pages/shopping/shopping_screen_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.animationController, required this.onChanged})
      : super(key: key);

  final AnimationController? animationController;
  final ValueChanged<int>? onChanged;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var model = NoticeViewModel();
  final ScrollController scrollController = ScrollController();
  String userName = '';
  String deptName = '';
  String avatar = '';
  double topBarOpacity = 0.0;
  Animation<double>? topBarAnimation;
  int current = 0;
  Timer? _timer;
  PageController _pageController = PageController();

  final List<SwitchType> buttonLabels = [
    SwitchType(S.current.notifications, 0),
    SwitchType(S.current.news, 1),
  ];
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.3, curve: Curves.fastOutSlowIn)));
    scrollController.addListener(() {
      if (scrollController.offset >= 50) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 50 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 50) {
          setState(() {
            topBarOpacity = scrollController.offset / 50;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    model.getNoticeModelList(1, 10);
    model.getNewsModelList(1, 10);
    super.initState();
    _fetchData();
    widget.animationController?.forward();
  }

  Future<void> _fetchData() async {
    // 模拟异步数据获取
    var res = await SpUtils.getString(Constants.SP_USER_NAME);
    var dept = await SpUtils.getString(Constants.SP_USER_DEPT);
    // 模拟异步数据获取
    var userInfo = await SpUtils.getModel('userInfo');
    // 更新状态
    avatar = userInfo != null ? userInfo['user']['avatar'] : '';
    // 更新状态
    setState(() {
      userName = res ?? '';
      deptName = dept ?? '';
      _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
        if (_pageController.hasClients) {
          int nextPage = _pageController.page!.toInt() + 1;
          if (nextPage == model.list?.length) {
            nextPage = 0;
          }
          _pageController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => model,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            top: false,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        _Banner(),
                        _Announcement(),
                        _FunctionArea(),
                        SwitchTypeView(
                          listData: buttonLabels,
                          callBack: (int value) {
                            updateCurrent(value);
                          },
                          animationController: widget.animationController,
                          animation: topBarAnimation,
                          current: current,
                        ),
                        Container(
                          child: current == 0
                              ? Consumer<NoticeViewModel>(
                                  builder: (context, model, child) {
                                  if (model.list?.isEmpty == true) {
                                    return Center(
                                      child: Text("暂无数据"),
                                    );
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.list?.length ?? 0,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    itemBuilder: (context, index) {
                                      final int count = model.list?.length ?? 0;
                                      final Animation<double> animation =
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                                  parent: widget
                                                      .animationController!,
                                                  curve: Interval(
                                                      (1 / count) * index, 1.0,
                                                      curve: Curves
                                                          .fastOutSlowIn)));
                                      return NoticeDataView(
                                        listData: model.list?[index],
                                        callBack: () => {
                                          // 跳转到详情页
                                          RouteUtils.push(
                                              context,
                                              NoticeDetailPage(
                                                  noticeId: model
                                                      .list![index]!.noticeId!))
                                        },
                                        animation: animation,
                                        animationController:
                                            widget.animationController,
                                      );
                                    },
                                  );
                                })
                              : Consumer<NoticeViewModel>(
                                  builder: (context, model, child) {
                                  if (model.newsList?.isEmpty == true) {
                                    return Center(
                                      child: Text("暂无数据"),
                                    );
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.newsList?.length ?? 0,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    itemBuilder: (context, index) {
                                      final int count = model.list?.length ?? 0;
                                      final Animation<double> animation =
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                                  parent: widget
                                                      .animationController!,
                                                  curve: Interval(
                                                      (1 / count) * index, 1.0,
                                                      curve: Curves
                                                          .fastOutSlowIn)));
                                      widget.animationController?.forward();
                                      return NewsDataView(
                                        listData: model.newsList?[index],
                                        callBack: () => {
                                          // 跳转到详情页
                                          RouteUtils.push(
                                              context,
                                              NoticeDetailPage(
                                                  noticeId: model
                                                      .newsList![index]!
                                                      .noticeId!))
                                        },
                                        animation: animation,
                                        animationController:
                                            widget.animationController,
                                      );
                                    },
                                  );
                                }),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
                getAppBarUI(),
              ],
            ),
          ),
        ));
  }

  // 功能图标区域
  Widget _FunctionArea() {
    return AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: topBarAnimation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 50 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  margin:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      // 在线报修
                      _FunctionAreaItem(
                          S.of(context).repairOnline,
                          true,
                          Icons.build,
                          () => RouteUtils.push(context, RepairFormPage())),
                      // 我的报修
                      _FunctionAreaItem(
                          S.of(context).myRepair,
                          false,
                          Icons.history,
                          () => RouteUtils.push(context, MyRepairPage())),
                      // _FunctionAreaItem('失物招领', true, Icons.search,
                      //     () => RouteUtils.push(context, LostFoundListPage())),
                      // 通知公告
                      _FunctionAreaItem(
                          S.of(context).notifications,
                          false,
                          Icons.notifications,
                          () => RouteUtils.push(context, NoticeListPage())),
                      // _FunctionAreaItem('意见反馈', true, Icons.feedback,
                      //     () => RouteUtils.push(context, FeedbackPage())),
                      // 联系我们
                      // _FunctionAreaItem(
                      //     S.of(context).contactUs,
                      //     false,
                      //     Icons.phone,
                      //     () => RouteUtils.push(context, ContactUsPage())),
                      _FunctionAreaItem('在线订餐', false, Icons.fastfood,
                          () => RouteUtils.push(context, ShoppingScreenPage())),
                      // _FunctionAreaItem(
                      //     '我的收藏',
                      //     true,
                      //     Icons.star,
                      //     () => Toast.showToast(
                      //         color: Colors.red,
                      //         icon: Icon(Icons.error, color: Colors.red),
                      //         title: '功能开发中，敬请期待！')),
                      // _FunctionAreaItem('更多功能', false, Icons.more_horiz,
                      //     () => widget.onChanged!(4)),
                    ],
                  ),
                )),
          );
        });
  }

  // 公告
  Widget _Announcement() {
    return AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: topBarAnimation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                            child: Text(S.current.notice,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor)),
                            padding: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 2,
                                        color: Colors.grey.withOpacity(0.3))))),
                        SizedBox(width: 10),
                        Expanded(
                          child: Consumer<NoticeViewModel>(
                              builder: (context, model, child) {
                            return SizedBox(
                                height: 30, // 限制高度以只显示一个公告
                                child: model.list?.isEmpty == true
                                    ? Text(
                                        S.of(context).noData,
                                        style: TextStyle(height: 2),
                                      )
                                    : PageView.builder(
                                        controller: _pageController,
                                        itemCount: model.list?.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              RouteUtils.push(
                                                  context,
                                                  NoticeDetailPage(
                                                      noticeId: model
                                                          .list![index]!
                                                          .noticeId!));
                                            },
                                            child: Row(children: [
                                              Expanded(
                                                  child: Text(
                                                      model.list?[index]
                                                              ?.noticeTitle ??
                                                          '',
                                                      style: TextStyle(
                                                          fontSize: 14))),
                                              Container(
                                                  child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                              )),
                                            ]),
                                          );
                                        },
                                      ));
                          }),
                        ),
                      ],
                    ))),
          );
        });
  }

  // 广告图轮播
  Widget _Banner() {
    return AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: topBarAnimation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Swiper(
                    itemCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        'assets/images/banner.jpg',
                        fit: BoxFit.fill,
                      );
                    },
                    autoplay: true,
                    indicatorLayout: PageIndicatorLayout.COLOR,
                  ),
                )),
          );
        });
  }

  void _handleTap() {
    //给方法传值
    widget.onChanged!(1);
  }

  //更新焦点的事件名
  void updateCurrent(int text) {
    if (text == 1) {
      model.getNoticeModelList(1, 10);
    } else {
      model.getNewsModelList(1, 10);
    }
    setState(() {
      current = text;
    });
  }

  // 头部
  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 12.0 * topBarOpacity,
                            bottom: 12),
                        child: Row(
                          mainAxisAlignment: userName != ''
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.end,
                          children: <Widget>[
                            if (userName != '')
                              Expanded(
                                  child: InkWell(
                                onTap: _handleTap,
                                child: Row(
                                  children: [
                                    // 圆形图片
                                    AvatarWidget(width: 40),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                14 + 2 - 2 * topBarOpacity,
                                            letterSpacing: 1.2,
                                            color: topBarOpacity == 1.0
                                                ? AppTheme.darkerText
                                                : Colors.white,
                                          ),
                                        ),
                                        Text(
                                          deptName,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontSize:
                                                12 + 2 - 2 * topBarOpacity,
                                            color: topBarOpacity == 1.0
                                                ? AppTheme.darkerText
                                                : Colors.white,
                                          ),
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              )),
                            Container(
                              padding: const EdgeInsets.all(5),
                              // 圆形背景
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              // 消息图标
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Icon(
                                  Icons.notifications,
                                  color: primaryColor[500],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  static InkWell _buildButton(Widget child, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        child: child,
      ),
    );
  }

  Widget _FunctionAreaItem(
      String title, bool isEven, IconData icon, GestureTapCallback? onTap) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isEven
                    ? primaryColor.withOpacity(0.1)
                    : secondaryColor.withOpacity(0.1)),
            child: Icon(
              icon,
              color: isEven ? primaryColor : secondaryColor,
              size: 24,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

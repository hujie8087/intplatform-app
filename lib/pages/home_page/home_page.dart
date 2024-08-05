import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/avatar_widget.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/common_ui/toast.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/mine_page/contact_us_page.dart';
import 'package:logistics_app/pages/mine_page/feedback_page/feedback_page.dart';
import 'package:logistics_app/pages/models/tabIcon_data.dart';
import 'package:logistics_app/pages/news_page/news_list_page.dart';
import 'package:logistics_app/pages/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/notice_page/notice_view_model.dart';
import 'package:logistics_app/pages/repair/my_repair_page.dart';
import 'package:logistics_app/pages/repair/repair_form_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
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
  String userName = '未登录';
  String deptName = '';
  double topBarOpacity = 0.0;
  Animation<double>? topBarAnimation;
  List<Widget> listViews = <Widget>[];
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  int current = 1;
  final List<SwitchType> buttonLabels = [
    SwitchType('通知公告', 0),
    SwitchType('公司新闻', 1),
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
    super.initState();
    _fetchData();
    widget.animationController?.forward();
  }

  Future<void> _fetchData() async {
    // 模拟异步数据获取
    var res = await SpUtils.getString(Constants.SP_USER_NAME);
    var dept = await SpUtils.getString(Constants.SP_USER_DEPT);
    // 更新状态
    setState(() {
      userName = res ?? '';
      deptName = dept ?? '';
    });
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
                            print(value);
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
                                          print('跳转到详情页')
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
                                      widget.animationController?.forward();
                                      return NewsDataView(
                                        listData: model.list?[index],
                                        callBack: () => {
                                          // 跳转到详情页
                                          print('跳转到详情页')
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      // 线路查询
                      _FunctionAreaItem('在线报修', true, Icons.build,
                          () => RouteUtils.push(context, RepairFormPage())),
                      _FunctionAreaItem('我的报修', false, Icons.history,
                          () => RouteUtils.push(context, MyRepairPage())),
                      _FunctionAreaItem('失物招领', true, Icons.search,
                          () => RouteUtils.push(context, LostFoundListPage())),
                      _FunctionAreaItem('通知公告', false, Icons.notifications,
                          () => RouteUtils.push(context, NoticeListPage())),
                      _FunctionAreaItem('意见反馈', true, Icons.feedback,
                          () => RouteUtils.push(context, FeedbackPage())),
                      _FunctionAreaItem('联系我们', false, Icons.phone,
                          () => RouteUtils.push(context, ContactUsPage())),
                      _FunctionAreaItem(
                          '我的收藏',
                          true,
                          Icons.star,
                          () => Toast.showToast(
                              color: Colors.red,
                              icon: Icon(Icons.error, color: Colors.red),
                              title: '功能开发中，敬请期待！')),
                      _FunctionAreaItem('更多功能', false, Icons.more_horiz,
                          () => widget.onChanged!(4)),
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
                            child: Text('公告',
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
                            child: Text('关于2021年国庆节放假通知',
                                style: TextStyle(fontSize: 14))),
                        Container(
                            child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        )),
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
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        'assets/hotel/hotel_1.png',
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
    widget.onChanged!(3);
  }

  //更新焦点的事件名
  void updateCurrent(int text) {
    setState(() {
      current = text;
      print(current);
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
                            top: 12 - 12.0 * topBarOpacity,
                            bottom: 12),
                        child: Row(
                          children: <Widget>[
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
                                          fontSize: 14 + 2 - 2 * topBarOpacity,
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
                                          fontSize: 12 + 2 - 2 * topBarOpacity,
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
                                color: Colors.white.withOpacity(0.3),
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
                                child: Center(
                                  child: Icon(
                                    Icons.notifications,
                                    color: primaryColor,
                                  ),
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

  Widget _FunctionAreaItem(
      String title, bool isEven, IconData icon, GestureTapCallback? onTap) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isEven
                    ? primaryColor.withOpacity(0.1)
                    : secondaryColor.withOpacity(0.1)),
            child: Icon(
              icon,
              color: isEven ? primaryColor : secondaryColor,
              size: 30,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title, style: TextStyle(fontSize: 12))
        ],
      ),
      onTap: onTap,
    );
  }
}

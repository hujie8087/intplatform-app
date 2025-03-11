import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/avatar_widget.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/pages/home_page/message_page.dart';
import 'package:logistics_app/pages/mine_page/contact_us_page.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/my_address_page.dart';
import 'package:logistics_app/pages/news/news_page/news_list_page.dart';
import 'package:logistics_app/pages/news/notice_page/notice_detail_page.dart';
import 'package:logistics_app/pages/news/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/news/notice_page/notice_view_model.dart';
import 'package:logistics_app/pages/repair/my_repair_page/my_repair_page.dart';
import 'package:logistics_app/pages/repair/submit_page/repair_form_page.dart';
import 'package:logistics_app/pages/shopping/order/order_list_page.dart';
import 'package:logistics_app/pages/shopping/payment/payment_qrcode_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.onChanged, this.addClick})
      : super(key: key);

  final ValueChanged<int>? onChanged;
  final Function()? addClick;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var model = NoticeViewModel();
  final ScrollController scrollController = ScrollController();
  String userName = '';
  String nickName = '';
  String avatar = '';
  double topBarOpacity = 0.0;
  Animation<double>? topBarAnimation;
  int current = 0;
  Timer? _timer;
  PageController _pageController = PageController();
  AnimationController? animationController;

  final List<SwitchType> buttonLabels = [
    SwitchType(S.current.notifications, 0),
    SwitchType(S.current.news, 1),
  ];
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0, 0.3, curve: Curves.fastOutSlowIn)));
    scrollController.addListener(() {
      if (scrollController.offset >= 50) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 50.px &&
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
    // model.getNewsModelList(1, 10);
    super.initState();
    _fetchData();
    animationController?.forward();
  }

  Future<void> _fetchData() async {
    // 模拟异步数据获取
    var res = await SpUtils.getString(Constants.SP_USER_NAME);
    // 模拟异步数据获取
    var userInfo = await SpUtils.getModel('userInfo');
    // 更新状态
    avatar = userInfo != null ? userInfo['user']['avatar'] : '';

    // 更新状态
    setState(() {
      userName = res ?? '';
      nickName = userInfo != null ? userInfo['user']['userName'] : '';
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
                          animationController: animationController,
                          animation: topBarAnimation,
                          current: current,
                        ),
                        Container(
                          child: current == 0
                              ? Consumer<NoticeViewModel>(
                                  builder: (context, model, child) {
                                  if (model.list?.isEmpty == true) {
                                    return Center(
                                      child: EmptyView(),
                                    );
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.list?.length ?? 0,
                                    padding: EdgeInsets.only(
                                        left: 8.px, right: 8.px),
                                    itemBuilder: (context, index) {
                                      final int count = model.list?.length ?? 0;
                                      final Animation<double> animation =
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                                  parent: animationController!,
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
                                            animationController,
                                      );
                                    },
                                  );
                                })
                              : Consumer<NoticeViewModel>(
                                  builder: (context, model, child) {
                                  if (model.newsList?.isEmpty == true) {
                                    return Center(
                                      child: EmptyView(),
                                    );
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.newsList?.length ?? 0,
                                    padding: EdgeInsets.only(
                                        left: 8.px, right: 8.px),
                                    itemBuilder: (context, index) {
                                      final int count = model.list?.length ?? 0;
                                      final Animation<double> animation =
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                                  parent: animationController!,
                                                  curve: Interval(
                                                      (1 / count) * index, 1.0,
                                                      curve: Curves
                                                          .fastOutSlowIn)));
                                      animationController?.forward();
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
                                            animationController,
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
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: topBarAnimation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 50 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  margin: EdgeInsets.only(
                      top: 10.px, left: 8.px, right: 8.px, bottom: 0),
                  padding: EdgeInsets.only(top: 10.px),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.px),
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
                          true,
                          Icons.notifications,
                          () => RouteUtils.push(context, NoticeListPage())),
                      // _FunctionAreaItem('意见反馈', true, Icons.feedback,
                      //     () => RouteUtils.push(context, FeedbackPage())),
                      // 联系我们
                      _FunctionAreaItem(
                          S.of(context).contactUs,
                          false,
                          Icons.phone,
                          () => RouteUtils.push(context, ContactUsPage())),
                      _FunctionAreaItem(
                          S.of(context).addressManagement,
                          true,
                          Icons.fastfood,
                          () => RouteUtils.push(context, MyAddressPage())),
                      // 我的订单
                      _FunctionAreaItem(
                          S.of(context).myOrder,
                          false,
                          Icons.bookmark_outline,
                          () => RouteUtils.push(context, OrderListPage())),
                      // 付款码
                      _FunctionAreaItem(
                          S.of(context).paymentQRCode,
                          false,
                          Icons.qr_code,
                          () => RouteUtils.push(context, PaymentQRCodePage())),
                      // _FunctionAreaItem(
                      //     '我的收藏',
                      //     true,
                      //     Icons.star,
                      //     () => Toast.showToast(
                      //         color: Colors.red,
                      //         icon: Icon(Icons.error, color: Colors.red),
                      //         title: '功能开发中，敬请期待！')),
                      _FunctionAreaItem(S.of(context).moreFunction, false,
                          Icons.more_horiz, () => widget.onChanged!(1)),
                    ],
                  ),
                )),
          );
        });
  }

  // 公告
  Widget _Announcement() {
    return AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: topBarAnimation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30.px * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                    margin:
                        EdgeInsets.only(top: 10.px, left: 8.px, right: 8.px),
                    padding: EdgeInsets.all(10.px),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.px),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(S.current.notice,
                                style: TextStyle(
                                    fontSize: 14.px,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor)),
                            padding: EdgeInsets.only(right: 8.px),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 2,
                                        color: Colors.grey.withOpacity(0.3))))),
                        SizedBox(width: 8.px),
                        Expanded(
                          child: Consumer<NoticeViewModel>(
                              builder: (context, model, child) {
                            return SizedBox(
                                height: 24.px, // 限制高度以只显示一个公告
                                child: model.list?.isEmpty == true
                                    ? Text(
                                        S.of(context).noData,
                                        style: TextStyle(height: 1.5),
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
                                                          fontSize: 12.px))),
                                              Container(
                                                  child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 14.px,
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
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: topBarAnimation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 24.px * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  width: double.infinity,
                  height: 180.px,
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

  void _handleTap(int value) {
    //给方法传值
    widget.onChanged!(value);
  }

  //更新焦点的事件名
  void updateCurrent(int text) async {
    if (text == 0) {
      if (model.list?.isEmpty == true) {
        await model.getNoticeModelList(1, 10);
      }
    } else {
      if (model.newsList?.isEmpty == true) {
        await model.getNewsModelList(1, 10);
      }
    }
    current = text;
    setState(() {});
    return;
  }

  // 头部
  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 24.px * (1.0 - topBarAnimation!.value), 0.0),
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
                            left: 10.px,
                            right: 10.px,
                            top: 10.px * topBarOpacity,
                            bottom: 10.px),
                        child: Row(
                          mainAxisAlignment: userName != ''
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.end,
                          children: <Widget>[
                            if (userName != '')
                              Expanded(
                                  child: InkWell(
                                onTap: () => _handleTap(2),
                                child: Row(
                                  children: [
                                    // 圆形图片
                                    AvatarWidget(width: 36.px),
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
                                                (12 + 2 - 2 * topBarOpacity).px,
                                            letterSpacing: 1.2,
                                            color: topBarOpacity == 1.0
                                                ? AppTheme.darkerText
                                                : Colors.white,
                                          ),
                                        ),
                                        Text(
                                          nickName,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontSize:
                                                (12 + 2 - 2 * topBarOpacity).px,
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
                              padding: EdgeInsets.all(5.px),
                              // 圆形背景
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.px),
                                ),
                              ),
                              // 消息图标
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.px)),
                                onTap: () {
                                  RouteUtils.push(context, MessagePage());
                                },
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
        height: 36.px,
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
            width: 36.px,
            height: 36.px,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isEven
                    ? primaryColor.withOpacity(0.1)
                    : secondaryColor.withOpacity(0.1)),
            child: Icon(
              icon,
              color: isEven ? primaryColor : secondaryColor,
              size: 20.px,
            ),
          ),
          SizedBox(
            height: 5.px,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12.px),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

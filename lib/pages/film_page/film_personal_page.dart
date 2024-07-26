import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logistics_app/pages/film_page/film_download_page.dart';
import 'package:logistics_app/pages/film_page/film_feedback_page.dart';
import 'package:logistics_app/pages/film_page/film_history_page.dart';
import 'package:logistics_app/pages/film_page/film_message_page.dart';
import 'package:logistics_app/pages/film_page/film_request_page.dart';
import 'package:logistics_app/pages/notice_page/notice_view_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class FilePage {
  final IconData iconData;
  final String title;
  // 点击事件
  final GestureTapCallback;
  FilePage(this.iconData, this.title, this.GestureTapCallback);
}

class FilmPersonalPage extends StatefulWidget {
  const FilmPersonalPage({Key? key, this.animationController})
      : super(key: key);

  final AnimationController? animationController;
  @override
  _FilmPersonalPage createState() => _FilmPersonalPage();
}

class _FilmPersonalPage extends State<FilmPersonalPage> {
  var model = NoticeViewModel();

  Animation<double>? opacityAnimation;

  @override
  void initState() {
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));

    widget.animationController!.forward();
    super.initState();
    model.getNoticeModelList(1, 10);
  }

  @override
  Widget build(BuildContext context) {
    final List<FilePage> pageList = [
      FilePage(Icons.star, '我的收藏', () => {print('我的收藏')}),
      FilePage(Icons.history, '观看历史',
          () => {RouteUtils.push(context, FilmHistoryPage())}),
      FilePage(Icons.download, '我的下载',
          () => {RouteUtils.push(context, FilmDownloadPage())}),
      FilePage(Icons.message, '我的消息',
          () => {RouteUtils.push(context, FilmMessagePage())}),
    ];
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "个人中心",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: filmAppBarBackgroundColor,
          foregroundColor: Colors.white,
        ),
        backgroundColor: filmBackgroundColor,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                // 设置背景图片
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10),
                padding:
                    EdgeInsets.only(top: 0, bottom: 30, right: 15, left: 15),
                decoration: BoxDecoration(
                  color: filmAppBarBackgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                  ),
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/video_personal_background.png'),
                      fit: BoxFit.none,
                      alignment: Alignment.centerRight,
                      scale: 1),
                ),
                child: Row(
                  children: [
                    // 圆形图片
                    Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/fitness_app/snack.png'),
                            fit: BoxFit.fill,
                          ),
                          color: primaryColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '用户名',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 110,
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                      color: filmAppBarBackgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: pageList.length | 4, // 每行显示三个
                    crossAxisSpacing: 10, // 水平间距
                    mainAxisSpacing: 10, // 垂直间距
                    children: List.generate(pageList.length, (index) {
                      return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: pageList[index].GestureTapCallback,
                            child: Ink(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      pageList[index].iconData,
                                      color: primaryColor,
                                      size: 32,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      pageList[index].title,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: filmAppBarBackgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      _commonItem(
                          '我要反馈',
                          Icons.edit_square,
                          () => RouteUtils.push(
                              context,
                              FilmFeedbackPage(
                                  animationController:
                                      widget.animationController)),
                          '',
                          0.2,
                          false),
                      _commonItem(
                          '我要求片',
                          Icons.video_camera_back_outlined,
                          () => RouteUtils.push(
                              context,
                              FilmRequestPage(
                                  animationController:
                                      widget.animationController)),
                          '',
                          0.4,
                          false),
                      _commonItem('清楚缓存', Icons.cleaning_services, () {
                        // 清楚缓存
                        _clearCache;
                        // 弹窗提示清楚缓存成功
                        showToast('清楚缓存成功');
                      }, '', 0.6, true),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _clearCache() async {
    await DefaultCacheManager().emptyCache();
    print('Cache cleared');
  }

  Animation<double> createOffsetAnimation(double endValue) {
    return Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: Interval(
          0.0,
          endValue,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  Widget _commonItem(String title, IconData icon, GestureTapCallback? onTap,
      String? subTitle, animationValue, bool isLast) {
    return AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: opacityAnimation!,
              child: Transform(
                  transform: Matrix4.translationValues(0.0,
                      100 * createOffsetAnimation(animationValue).value, 0.0),
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: !isLast
                              ? Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.2)))
                              : null),
                      child: Row(
                        children: [
                          // 带背景的色的图标
                          Icon(
                            icon,
                            color: primaryColor,
                            size: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          Text(
                            subTitle ?? '',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  )));
        });
  }
}

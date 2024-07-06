import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/pages/auth/login_page.dart';
import 'package:logistics_app/pages/mine_page/change_password_page.dart';
import 'package:logistics_app/pages/mine_page/contact_us_page.dart';
import 'package:logistics_app/pages/mine_page/feedback_page/feedback_page.dart';
import 'package:logistics_app/pages/mine_page/mine_view_model.dart';
import 'package:logistics_app/pages/mine_page/person_info_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:oktoast/oktoast.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with TickerProviderStateMixin {
  var model = MineViewModel();

  Animation<double>? opacityAnimation;
  Animation<double>? offsetAnimation;

  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));

    widget.animationController!.forward();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(left: 20, top: 10, right: 20),
          child: Column(
            children: [
              _personCard(),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Column(
                    children: [
                      _commonItem('个人信息', Icons.account_circle, () {
                        RouteUtils.push(context, PersonInfoPage());
                      }, '', 0.2),
                      _commonItem('修改密码', Icons.lock, () {
                        RouteUtils.push(context, ChangePasswordPage());
                      }, '', 0.3),
                      _commonItem('消息通知', Icons.notifications, () {}, '', 0.4),
                      _commonItem('意见反馈', Icons.feedback, () {
                        RouteUtils.push(context, FeedbackPage());
                      }, '', 0.5),
                      // 语言设置
                      _commonItem('语言设置', Icons.language, () {}, '中文', 0.6),
                      _commonItem('清除缓存', Icons.delete_rounded, () {}, '', 0.7),
                      _commonItem('检查更新', Icons.update, () {
                        checkAppUpdate();
                      }, model.needUpdate ? '有新版本' : 'V1.0.0', 0.8),
                      _commonItem('联系我们', Icons.info, () {
                        RouteUtils.push(context, ContactUsPage());
                      }, '', 0.9),
                      _logoutButton(() => DialogFactory.new().showConfirmDialog(
                            context: context,
                            title: '退出登录',
                            content: '确定要退出登录吗？',
                            confirmClick: () {
                              // 退出登录
                              model
                                  .logout()
                                  .then((value) => {
                                        print(value),
                                        showToast('退出登录成功'),
                                        RouteUtils.push(context, LoginPage())
                                      })
                                  .catchError((e) {
                                showToast('退出登录失败');
                              });
                            },
                          )),
                    ],
                  )),
            ],
          ),
        )),
      ),
    );
  }

  // 人物卡片
  Widget _personCard() {
    return AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: opacityAnimation!,
              child: Transform.translate(
                offset: Offset(0.0, 50 * (1.0 - opacityAnimation!.value)),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '我的',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 100,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              primaryColor.withOpacity(0.3)
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: primaryColor.withOpacity(0.6),
                                offset: const Offset(1.0, 1.1),
                                blurRadius: 10.0),
                          ],
                          image: DecorationImage(
                              image: AssetImage('assets/images/person_bg.png'),
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/userImage.png'),
                                              fit: BoxFit.cover)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '张三',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '信息技术部',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        // 职位
                                        Text(
                                          '工程师',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  Widget _commonItem(String title, IconData icon, GestureTapCallback? onTap,
      String? subTitle, animationValue) {
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
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)))),
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
                                fontSize: 16,
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

  ///退出登录按钮
  Widget _logoutButton(GestureTapCallback? onTap) {
    return AnimatedBuilder(
        animation: widget.animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: opacityAnimation!,
              child: Transform.translate(
                offset: Offset(0.0, 50 * (1.0 - opacityAnimation!.value)),
                child: Container(
                  child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                          width: double.infinity,
                          height: 40,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 40, right: 40, top: 50),
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text("退出登录",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)))),
                ),
              ));
        });
  }

  ///检查更新
  void checkAppUpdate() {
    model.checkUpdate().then((url) {
      if (url != null && url.isNotEmpty == true) {
        DialogFactory.instance.showNeedUpdateDialog(
            context: context,
            dismissClick: () {
              //是否显示更新红点
              model.shouldShowUpdateDot();
            },
            confirmClick: () {
              //跳转到外部浏览器打开
              model.jumpToOutLink(url);
            });
      } else {
        showToast("已是最新版本", backgroundColor: primaryColor);
      }
    });
  }
}

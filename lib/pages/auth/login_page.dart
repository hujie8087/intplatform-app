import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/pages/app_home_screen.dart';
import 'package:logistics_app/pages/auth/Login_form.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          RouteUtils.push(context, AppHomeScreen());
          return false;
        },
        // TODO: implement build
        child: Scaffold(
          body: SafeArea(
              top: false,
              child: Container(
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    // 背景图片
                    Positioned.fill(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/images/login_bg1_1.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          Expanded(
                            child: Image.asset(
                              'assets/images/login_bg2_1.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 其他内容
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // 自适应键盘弹起不遮挡
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 26.px, right: 26.px),
                            width: SizedBox.expand().width,
                            child: Text(
                              S.of(context).hello,
                              style: TextStyle(
                                  fontSize: 28.px,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 26.px, right: 26.px),
                            width: SizedBox.expand().width,
                            child: Text(
                              S.of(context).welcome,
                              style: TextStyle(
                                  fontSize: 16.px, color: Colors.grey),
                              textAlign: TextAlign.left,
                            ),
                            margin: EdgeInsets.only(bottom: 40.px),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 18.px, right: 18.px),
                            child: LoginForm(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
              // 居中显示
              ),
        ));
  }
}

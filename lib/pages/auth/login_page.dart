import 'package:logistics_app/pages/auth/Login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
                        padding: EdgeInsets.only(left: 30, right: 30),
                        width: SizedBox.expand().width,
                        child: Text(
                          '您好，',
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        width: SizedBox.expand().width,
                        child: Text(
                          '欢迎来到智慧后勤',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                        margin: EdgeInsets.only(bottom: 50),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
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
    );
  }
}

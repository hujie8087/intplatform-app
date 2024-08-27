import 'package:flutter/material.dart';
import 'package:logistics_app/pages/auth/Register_form.dart';

class RegisterPage extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterPage> {
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
                // 返回按钮
                Positioned(
                  top: 50,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      print(111);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      color: Colors.transparent, // 添加透明背景以确保点击区域
                      child: Icon(
                        Icons.arrow_back,
                        size: 36,
                      ),
                    ),
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
                          '欢迎注册IWIP后勤综合服务APP',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                        margin: EdgeInsets.only(bottom: 50),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: RegisterForm(),
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

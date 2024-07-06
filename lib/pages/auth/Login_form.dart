import 'package:logistics_app/pages/app_home_screen.dart';
import 'package:logistics_app/pages/auth/auth_view_model.dart';
import 'package:logistics_app/pages/home_page/home_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _focuseNode = FocusNode();
  var model = AuthViewModel();
  TextEditingController _usernameController =
      TextEditingController(text: 'admin');
  TextEditingController _passwordController =
      TextEditingController(text: 'admin123');
  bool _isLoading = false;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focuseNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return model;
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextField(
                focusNode: _focuseNode,
                // autofocus: true,
                cursorColor: primaryColor,
                controller: _usernameController,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '请输入您的工号',
                  prefixIcon: Icon(
                    Icons.person_2_outlined,
                    color: primaryColor,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  model.inputUserName = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextField(
                cursorColor: primaryColor,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: '请输入密码',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: primaryColor,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  model.inputPassword = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '忘记密码',
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20, bottom: 150),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                    ))
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        model.login().then((value) {
                          if (value) {
                            RouteUtils.push(context, AppHomeScreen());
                          }
                        }).catchError((e) {
                          // showToast("网络连接错误${e}");
                        }).whenComplete(() {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      },
                      child: Text(
                        '登录',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/pages/app_home_screen.dart';
import 'package:logistics_app/pages/auth/Register_page.dart';
import 'package:logistics_app/pages/auth/auth_view_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
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
  TextEditingController _usernameController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
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
                keyboardType: TextInputType.number,
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
                        model.login().then((value) async {
                          if (value) {
                            var token =
                                await SpUtils.getString('fCMToken') ?? '';
                            if (token != '') {
                              DataUtils.setUserToken(token);
                            }
                            RouteUtils.push(context, AppHomeScreen());
                            showToast("登录成功");
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }).catchError((e) {
                          showToast("网络连接错误${e}");
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
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('没有帐号？'),
                    GestureDetector(
                      onTap: () {
                        RouteUtils.push(context, RegisterPage());
                      },
                      child: Text(
                        '立即注册',
                        style: TextStyle(color: primaryColor),
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}

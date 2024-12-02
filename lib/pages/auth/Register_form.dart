import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/pages/app_home_screen.dart';
import 'package:logistics_app/pages/auth/auth_view_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _focuseNode = FocusNode();
  var model = AuthViewModel();
  TextEditingController _nicknameController = TextEditingController(text: '');
  TextEditingController _usernameController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController _confirmController = TextEditingController(text: '');
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
                controller: _nicknameController,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: S.of(context).inputMessage(S.of(context).name),
                  prefixIcon: Icon(
                    Icons.person_2_outlined,
                    color: primaryColor,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  model.nickName = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextField(
                // autofocus: true,
                cursorColor: primaryColor,
                controller: _usernameController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: '请输入您的帐号',
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
                  hintText: '请输入您的密码',
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
              child: TextField(
                cursorColor: primaryColor,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                obscureText: true,
                controller: _confirmController,
                decoration: InputDecoration(
                  hintText: '请确认您的密码',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: primaryColor,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  model.confirmPassword = value;
                },
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
                        model.register().then((value) async {
                          if (value) {
                            showToast("注册成功");
                            model.login().then((val) async {
                              var token =
                                  await SpUtils.getString('fCMToken') ?? '';
                              if (token != '') {
                                DataUtils.setUserToken(token,
                                    success: (val) => print('123456'));
                              }
                              RouteUtils.push(context, AppHomeScreen());
                              setState(() {
                                _isLoading = false;
                              });
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
                        '注册',
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
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/pages/app_home_screen.dart';
import 'package:logistics_app/pages/auth/auth_view_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

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
              margin: EdgeInsets.only(bottom: 10.px),
              child: TextField(
                focusNode: _focuseNode,
                // autofocus: true,
                cursorColor: primaryColor,
                controller: _usernameController,
                style: TextStyle(
                    fontSize: 16.px,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: S.of(context).usernamePlaceholder,
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
              margin: EdgeInsets.only(bottom: 10.px),
              child: TextField(
                cursorColor: primaryColor,
                style: TextStyle(
                    fontSize: 14.px,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: S.of(context).passwordPlaceholder,
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
                            var token = await SpUtils.getString(
                                    Constants.SP_DEVICE_TOKEN) ??
                                '';
                            if (token != '') {
                              DataUtils.setUserToken({'mobilePhoneId': token});
                            }

                            RouteUtils.push(context, AppHomeScreen());
                            ProgressHUD.showText(S.of(context).loginSuccess);
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }).catchError((e) {
                          ProgressHUD.showError(
                              S.of(context).networkError + ":${e}");
                        }).whenComplete(() {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      },
                      child: Text(
                        S.of(context).loginBtn,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor[500]),
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 14.px, color: Colors.white)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.px))),
                      ),
                    ),
            ),
          ],
        ));
  }
}

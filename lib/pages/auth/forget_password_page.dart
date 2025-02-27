import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/pages/auth/auth_view_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final AuthViewModel model = AuthViewModel();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _cardFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/forgetPassword_bg.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 30.px, right: 30.px),
                margin: EdgeInsets.only(top: 100.px, bottom: 50.px),
                width: SizedBox.expand().width,
                child: Text(
                  S.of(context).resetPassword,
                  style: TextStyle(
                      fontSize: 24.px,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.px, right: 20.px),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10.px),
                      child: TextField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        autofocus: true,
                        cursorColor: primaryColor,
                        style: TextStyle(
                            fontSize: 14.px,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: S.of(context).inputWorkNumber,
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: primaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.px),
                      child: TextField(
                        autofocus: true,
                        cursorColor: primaryColor,
                        controller: _cardController,
                        focusNode: _cardFocusNode,
                        style: TextStyle(
                            fontSize: 14.px,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: S.of(context).inputIdCard,
                          prefixIcon: Icon(
                            Icons.card_travel_outlined,
                            color: primaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.px),
                      child: TextField(
                        cursorColor: primaryColor,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        style: TextStyle(
                            fontSize: 14.px,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: S.of(context).inputNewPassword,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: primaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.px),
                      width: double.infinity,
                      child: TextField(
                        cursorColor: primaryColor,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        style: TextStyle(
                            fontSize: 14.px,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: S.of(context).inputConfirmPassword,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: primaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.px),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          model.forgetPassword(
                            context,
                            {
                              'userName': _usernameController.text,
                              'card': _cardController.text,
                              'newPassword': _passwordController.text,
                              'confirmPassword':
                                  _confirmPasswordController.text,
                            },
                          );
                        },
                        child: Text(
                          S.of(context).confirm,
                          style:
                              TextStyle(fontSize: 16.px, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor[500]),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 14.px, color: Colors.white)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.px))),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

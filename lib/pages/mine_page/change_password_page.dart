import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage(
      {Key? key, this.isFirstLogin = false, this.animationController})
      : super(key: key);

  final AnimationController? animationController;
  final bool isFirstLogin;
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool oldInputState = false;
  bool newPasswordInputState = false;
  bool confirmInputState = false;

  @override
  Widget build(BuildContext context) {
    print(widget.isFirstLogin);
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                  decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('assets/images/login_bg1_1.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter),
              )),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/login_bg2_1.png'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // 自适应键盘弹起不遮挡
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 24.px, right: 24.px),
                      margin: EdgeInsets.only(bottom: 10.px),
                      width: SizedBox.expand().width,
                      child: Text(
                        S.of(context).changePassword,
                        style: TextStyle(
                            fontSize: 20.px,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    if (widget.isFirstLogin)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 24.px, right: 24.px),
                        margin: EdgeInsets.only(bottom: 14.px),
                        child: Text(
                          '为了您的资金安全，首次登录请您尽快修改密码！',
                          style:
                              TextStyle(fontSize: 12.px, color: secondaryColor),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.only(left: 16.px, right: 16.px),
                      child: _ChangePasswordForm(),
                    )
                  ],
                ),
              ),
              // 返回按钮
              if (!widget.isFirstLogin)
                Positioned(
                  top: 36.px,
                  left: 20.px,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
            ],
          )
          // 居中显示
          ),
    );
  }

  Widget _ChangePasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _oldPasswordController,
            validator: (v) {
              return v!.trim().isNotEmpty
                  ? null
                  : S.of(context).oldPasswordNotEmpty;
            },
            obscureText: !oldInputState,
            decoration: InputDecoration(
                labelStyle:
                    TextStyle(fontSize: 12.px, fontWeight: FontWeight.bold),
                hintText: S.of(context).inputMessage(S.of(context).oldPassword),
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.lock_outlined, color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                      oldInputState ? Icons.visibility_off : Icons.visibility,
                      color: primaryColor),
                  onPressed: () {
                    oldInputState = !oldInputState;
                    setState(() {});
                  },
                )),
          ),
          SizedBox(
            height: 20.px,
          ),
          TextFormField(
            controller: _newPasswordController,
            obscureText: !newPasswordInputState,
            decoration: InputDecoration(
                labelStyle:
                    TextStyle(fontSize: 12.px, fontWeight: FontWeight.bold),
                hintText: S.of(context).inputMessage(S.of(context).newPassword),
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.lock_outlined, color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                      newPasswordInputState
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: primaryColor),
                  onPressed: () {
                    newPasswordInputState = !newPasswordInputState;
                    setState(() {});
                  },
                )),
            validator: (v) {
              return v!.trim().isNotEmpty
                  ? null
                  : S.of(context).newPasswordNotEmpty;
            },
          ),
          SizedBox(
            height: 16.px,
          ),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !confirmInputState,
            decoration: InputDecoration(
                labelStyle:
                    TextStyle(fontSize: 12.px, fontWeight: FontWeight.bold),
                hintText: S.of(context).enterNewPasswordAgin,
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.lock_outlined, color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                      confirmInputState
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: primaryColor),
                  onPressed: () {
                    confirmInputState = !confirmInputState;
                    setState(() {});
                  },
                )),
            validator: (v) {
              if (v!.trim().isNotEmpty) {
                if (v != _newPasswordController.text) {
                  return S.of(context).passwordNotSame;
                }
                return null;
              } else {
                return S.of(context).enterNewPasswordAgin;
              }
            },
          ),
          SizedBox(
            height: 16.px,
          ),
          // 提示信息
          Padding(
            padding: EdgeInsets.only(left: 15.px, right: 15.px),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: primaryColor,
                  size: 12.px,
                ),
                Text(
                  S.of(context).passwordLength,
                  style: TextStyle(color: Colors.grey, fontSize: 10.px),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 26.px,
          ),
          Padding(
              padding: EdgeInsets.only(left: 15.px, right: 15.px),
              child: ElevatedButton(
                onPressed: () {
                  if ((_formKey.currentState as FormState).validate()) {
                    //验证通过提交数据
                    DataUtils.updateUserPwd(
                      {
                        'oldPassword': _oldPasswordController.text,
                        'newPassword': _newPasswordController.text
                      },
                      success: (data) {
                        ProgressHUD.showText(
                            S.of(context).passwordChangeSuccess);
                        Navigator.pushNamed(context, RoutePath.login);
                      },
                    );
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(primaryColor[500]),
                    minimumSize:
                        MaterialStateProperty.all(Size(double.infinity, 32.px)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.px)))),
                child: Text(
                  S.of(context).submit,
                  style: TextStyle(
                      fontSize: 14.px,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/card_info_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:logistics_app/common_ui/password_input.dart';

class CardInfoPage extends StatefulWidget {
  @override
  _CardInfoPageState createState() => _CardInfoPageState();
}

class _CardInfoPageState extends State<CardInfoPage> {
  CardInfoModel? cardInfo;
  TextEditingController _passwordController = TextEditingController();
  UserInfoModel? userInfo;
  bool isLoading = false;
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _fetchCardInfo();
  }

  void _fetchCardInfo() async {
    setState(() {
      isLoading = true;
    });
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    }
    ShoppingUtils.getCardInfo(
      {'uniqueId': userInfo?.user?.userName},
      success: (data) {
        cardInfo = CardInfoModel.fromJson(data['data']);
        setState(() {
          isLoading = false;
        });
      },
      fail: (code, msg) {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusMap = {
      '0': S.of(context).cardDelete,
      '1': S.of(context).cardValid,
      '2': S.of(context).cardLoss,
      '3': S.of(context).cardFreeze,
      '4': S.of(context).cardPreDelete,
      '5': S.of(context).cardLock,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).cardInfo, style: TextStyle(fontSize: 16.px)),
      ),
      body: Container(
        padding: EdgeInsets.all(16.px),
        width: double.infinity,
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10.px),
                      decoration: BoxDecoration(
                        // 渐变背景
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.4),
                            secondaryColor.withOpacity(0.4),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10.px),
                        // 阴影
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5.px,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                // 姓名
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).cardName,
                                      style: TextStyle(fontSize: 14.px),
                                    ),
                                    SizedBox(width: 5.px),
                                    Text(
                                      cardInfo?.accName ?? '',
                                      style: TextStyle(
                                        fontSize: 16.px,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.px),
                                // 卡号
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).cardNumber,
                                      style: TextStyle(fontSize: 14.px),
                                    ),
                                    SizedBox(width: 5.px),
                                    Text(
                                      cardInfo?.accNum ?? '',
                                      style: TextStyle(
                                        fontSize: 16.px,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.px),
                                // 部门
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).cardDep,
                                      style: TextStyle(fontSize: 14.px),
                                    ),
                                    SizedBox(width: 5.px),
                                    Text(
                                      cardInfo?.accDepName ?? '',
                                      style: TextStyle(
                                        fontSize: 16.px,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.px),
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).cardBalance,
                                      style: TextStyle(fontSize: 14.px),
                                    ),
                                    SizedBox(width: 5.px),
                                    Text(
                                      cardInfo?.balance ?? '',
                                      style: TextStyle(
                                        fontSize: 16.px,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                S.of(context).cardStatus,
                                style: TextStyle(fontSize: 10.px),
                              ),
                              SizedBox(height: 8.px),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.px,
                                  vertical: 5.px,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  statusMap[cardInfo?.cardStatusNum ?? '0'] ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 18.px,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.px),
                    // 挂失或解锁
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 30.px),
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.px),
                          ),
                        ),
                        onPressed: () {
                          // 弹窗校验输入密码框
                          DialogFactory.instance.showParentDialog(
                            context: context,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            child: AlertDialog(
                              insetPadding: EdgeInsets.zero,
                              contentPadding: EdgeInsets.all(20.px),
                              title: Text(
                                S.of(context).cardPassword,
                                style: TextStyle(fontSize: 16.px),
                              ),
                              content: PasswordInput(
                                onCompleted: (password) {
                                  if (password.length != 6) {
                                    ProgressHUD.showError(
                                      S.of(context).inputPasswordError,
                                    );
                                    return;
                                  }
                                  // 验证密码
                                  ShoppingUtils.verifyPayPassword(
                                    {
                                      'oriPassword': password,
                                      'uniqueId': userInfo?.user?.userName,
                                      'pwdType': '1',
                                    },
                                    success: (data) {
                                      // 挂失
                                      if (cardInfo?.cardStatusNum == '1') {
                                        ShoppingUtils.disableCard(
                                          {
                                            'uniqueId':
                                                userInfo?.user?.userName,
                                          },
                                          success: (data) {
                                            ProgressHUD.showSuccess(
                                              S.of(context).cardLossSuccess,
                                            );
                                            _fetchCardInfo();
                                          },
                                        );
                                      } else {
                                        ShoppingUtils.enableCard(
                                          {
                                            'uniqueId':
                                                userInfo?.user?.userName,
                                          },
                                          success: (data) {
                                            ProgressHUD.showSuccess(
                                              S.of(context).cardLockSuccess,
                                            );
                                            _fetchCardInfo();
                                          },
                                        );
                                      }
                                    },
                                  );
                                  Navigator.of(context).pop(); // 关闭弹窗
                                },
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(S.of(context).cancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          cardInfo?.cardStatusNum == '2'
                              ? S.of(context).cardLock
                              : S.of(context).cardLoss,
                          style: TextStyle(
                            fontSize: 16.px,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/parse_qrcode_model.dart';
import 'package:logistics_app/http/model/qr_code_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/shopping/payment/qr_scanner_page.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentQRCodePage extends StatefulWidget {
  const PaymentQRCodePage({
    Key? key,
  }) : super(key: key);

  @override
  _PaymentQRCodePageState createState() => _PaymentQRCodePageState();
}

class _PaymentQRCodePageState extends State<PaymentQRCodePage> {
  bool _isLoading = false;
  QrCodeModel? _qrCodeData;

  UserInfoModel? userInfo;
  String? version;
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _generateQRCode();
  }

  Future<void> _generateQRCode() async {
    setState(() {
      _isLoading = true;
    });
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    }
    ShoppingUtils.getPayQrCode(
      {
        'uniqueId': userInfo?.user?.userName,
      },
      success: (data) {
        _qrCodeData = QrCodeModel.fromJson(data['data']);
        setState(() {
          _isLoading = false;
        });
      },
      fail: (code, msg) {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 扫码按钮点击事件
  Future<void> _scanQRCode() async {
    var status = await Permission.camera.status;
    print(status);
    if (status.isDenied) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRScannerPage(),
        ),
      );

      if (result != null) {
        // 处理扫码结果
        try {
          // 弹窗验证支付密码的弹窗
          _passwordController.clear();

          DialogFactory.instance.showParentDialog(
            context: context,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.all(20.px),
              title: Text(
                S.current.inputPasswordError,
                style: TextStyle(fontSize: 16.px),
              ),
              // 6位密码输入框
              content: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 40.px,
                      height: 40.px,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 2.px),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8.px),
                      ),
                      child: TextField(
                        controller: TextEditingController(
                          text: _passwordController.text.length > index
                              ? _passwordController.text[index]
                              : '',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.px, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        // 加密
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        onChanged: (value) {
                          String currentText = _passwordController.text;
                          if (value.isEmpty && currentText.isNotEmpty) {
                            // 删除操作
                            _passwordController.text = currentText.substring(
                                0, currentText.length - 1);
                          } else if (value.isNotEmpty) {
                            // 添加操作
                            if (currentText.length < 6) {
                              _passwordController.text = currentText + value;
                            }
                          }

                          // 自动跳转到下一个输入框
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                          // 自动跳转到上一个输入框
                          else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }

                          setState(() {});
                        },
                      ),
                    );
                  }),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(S.of(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop(); // 关闭弹窗
                  },
                ),
                TextButton(
                  child: Text(S.of(context).confirm),
                  onPressed: () {
                    String password = _passwordController.text;
                    // 处理密码逻辑
                    if (password.length != 6) {
                      ProgressHUD.showError(S.of(context).inputPasswordError);
                      return;
                    }
                    // 验证密码
                    ShoppingUtils.verifyPayPassword({
                      'oriPassword': password,
                      'uniqueId': userInfo?.user?.userName,
                      'pwdType': '1'
                    }, success: (msg) {
                      ShoppingUtils.parsePayQrCode(
                        {'qrCode': result},
                        success: (data) {
                          ParseQrCodeModel parseQrCodeData =
                              ParseQrCodeModel.fromJson(data['data']);
                          ShoppingUtils.processPaymentQRCode(
                            //交易类型 1:充值消费 3:充值 5:消费
                            {
                              'sign': parseQrCodeData.sign,
                              'uniqueId': userInfo?.user?.userName,
                              'otpType': '5',
                              'queryType': '2',
                              'eWalletNum': ' 1',
                              'dealerNum': parseQrCodeData.dealerNum,
                              'orderNum': parseQrCodeData.recId,
                              'staNum': parseQrCodeData.staNum,
                              'password': password,
                              'type': parseQrCodeData.type,
                              'monDeal': parseQrCodeData.amount,
                            },
                            success: (data) {
                              // showToast('支付成功');
                              ProgressHUD.showSuccess(S.of(context).paySuccess);
                              // Navigator.pop(context, true); // 返回上一页并传递支付成功状态
                            },
                            fail: (code, msg) {
                              ProgressHUD.showError(
                                  '${S.of(context).payFail}:$msg');
                            },
                          );
                        },
                      );
                      // 清楚密码
                      _passwordController.clear();
                    });

                    Navigator.of(context).pop(); // 关闭弹窗
                  },
                ),
              ],
            ),
          );
        } catch (e) {
          ProgressHUD.showError('${S.of(context).payFail}:${e.toString()}');
        }
      }
    } else if (status.isDenied) {
      // 检查相机权限
      var requestStatus = await Permission.camera.request();
      if (requestStatus.isGranted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerPage(),
          ),
        );

        if (result != null) {
          // 处理扫码结果
          try {
            // 弹窗验证支付密码的弹窗
            _passwordController.clear();
            DialogFactory.instance.showParentDialog(
              context: context,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.all(20.px),
                title: Text(
                  S.current.inputPasswordError,
                  style: TextStyle(fontSize: 16.px),
                ),
                // 6位密码输入框
                content: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 40.px,
                        height: 40.px,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 2.px),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8.px),
                        ),
                        child: TextField(
                          controller: TextEditingController(
                            text: _passwordController.text.length > index
                                ? _passwordController.text[index]
                                : '',
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.px, fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.number,
                          // 加密
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                          onChanged: (value) {
                            String currentText = _passwordController.text;
                            if (value.isEmpty && currentText.isNotEmpty) {
                              // 删除操作
                              _passwordController.text = currentText.substring(
                                  0, currentText.length - 1);
                            } else if (value.isNotEmpty) {
                              // 添加操作
                              if (currentText.length < 6) {
                                _passwordController.text = currentText + value;
                              }
                            }

                            // 自动跳转到下一个输入框
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                            // 自动跳转到上一个输入框
                            else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }

                            setState(() {});
                          },
                        ),
                      );
                    }),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(S.of(context).cancel),
                    onPressed: () {
                      Navigator.of(context).pop(); // 关闭弹窗
                    },
                  ),
                  TextButton(
                    child: Text(S.of(context).confirm),
                    onPressed: () {
                      String password = _passwordController.text;
                      // 处理密码逻辑
                      if (password.length != 6) {
                        ProgressHUD.showError(S.of(context).inputPasswordError);
                        return;
                      }
                      // 验证密码
                      ShoppingUtils.verifyPayPassword({
                        'oriPassword': password,
                        'uniqueId': userInfo?.user?.userName,
                        'pwdType': '1'
                      }, success: (msg) {
                        ShoppingUtils.parsePayQrCode(
                          {'qrCode': result},
                          success: (data) {
                            ParseQrCodeModel parseQrCodeData =
                                ParseQrCodeModel.fromJson(data['data']);
                            ShoppingUtils.processPaymentQRCode(
                              //交易类型 1:充值消费 3:充值 5:消费
                              {
                                'sign': parseQrCodeData.sign,
                                'uniqueId': userInfo?.user?.userName,
                                'otpType': '5',
                                'queryType': '2',
                                'eWalletNum': ' 1',
                                'dealerNum': parseQrCodeData.dealerNum,
                                'orderNum': parseQrCodeData.recId,
                                'staNum': parseQrCodeData.staNum,
                                'password': password,
                                'type': parseQrCodeData.type,
                                'monDeal': parseQrCodeData.amount,
                              },
                              success: (data) {
                                // showToast('支付成功');
                                ProgressHUD.showSuccess(
                                    S.of(context).paySuccess);
                                // Navigator.pop(context, true); // 返回上一页并传递支付成功状态
                              },
                              fail: (code, msg) {
                                ProgressHUD.showError(
                                    '${S.of(context).payFail}:$msg');
                              },
                            );
                          },
                        );
                        // 清楚密码
                        _passwordController.clear();
                      });

                      Navigator.of(context).pop(); // 关闭弹窗
                    },
                  ),
                ],
              ),
            );
          } catch (e) {
            ProgressHUD.showError('${S.of(context).payFail}:${e.toString()}');
          }
        } else {
          ProgressHUD.showError(S.current.needCameraPermission);
        }
      }

      print('requestStatus::${requestStatus}');
    } else if (status.isPermanentlyDenied) {
      ProgressHUD.showError('相机权限被永久拒绝，打开设置页面');
      openAppSettings();
    } else {
      ProgressHUD.showError(S.current.needCameraPermission);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).paymentQRCode,
              style: TextStyle(fontSize: 16.px)),
          centerTitle: true,
          actions: [
            // 扫码，打开摄像头
            IconButton(
              onPressed: _scanQRCode,
              icon: Icon(Icons.qr_code_scanner),
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child:
                    // 二维码区域
                    Center(
                  child: Container(
                    margin: EdgeInsets.all(16.px),
                    padding: EdgeInsets.all(16.px),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.px),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 倒计时
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.px, vertical: 5.px),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20.px),
                          ),
                          child: Text(
                            S.of(context).paymentQRCode,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.px,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.px),

                        // 二维码
                        if (_qrCodeData != null)
                          Container(
                            padding: EdgeInsets.all(8.px),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10.px),
                            ),
                            child: QrImageView(
                              data: _qrCodeData?.qrCode ?? '',
                              version: QrVersions.auto,
                              size: 260.px,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}

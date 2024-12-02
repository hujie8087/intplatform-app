import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class ModifyPaymentPasswordPage extends StatefulWidget {
  const ModifyPaymentPasswordPage({Key? key}) : super(key: key);

  @override
  _ModifyPaymentPasswordPageState createState() =>
      _ModifyPaymentPasswordPageState();
}

class _ModifyPaymentPasswordPageState extends State<ModifyPaymentPasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  UserInfoModel? userInfo;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    } else {
      DataUtils.getUserInfo(
        success: (res) async {
          UserInfoModel userInfoModel = UserInfoModel.fromJson(res['data']);
          await SpUtils.saveModel('userInfo', userInfoModel);
          userInfo = userInfoModel;
          setState(() {});
        },
      );
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _modifyPassword() async {
    // 验证输入
    if (_oldPasswordController.text.length != 6) {
      ProgressHUD.showError(S.of(context).inputOldPassword);
      return;
    }
    if (_newPasswordController.text.length != 6) {
      ProgressHUD.showError(S.of(context).inputNewPassword);
      return;
    }
    if (_confirmPasswordController.text != _newPasswordController.text) {
      ProgressHUD.showError(S.of(context).inputConfirmPassword);
      return;
    }

    setState(() {
      _isLoading = true;
    });
    ShoppingUtils.modifyPaymentPassword(
      {
        'oriPassword': _oldPasswordController.text,
        'newPassword': _newPasswordController.text,
        'uniqueId': userInfo?.user?.userName,
        "pwdType": "1"
      },
      success: (data) {
        ProgressHUD.showSuccess(S.of(context).passwordModifySuccess);
        Navigator.pop(context);
        setState(() {
          _isLoading = false;
        });
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  Widget _buildPasswordInput(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 3.px),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 100.px,
            child: Text(
              label,
              style: TextStyle(fontSize: 12.px),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: true,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 14.px),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.px, vertical: 6.px),
                hintText: S.of(context).inputPasswordError,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12.px,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).updatePaymentPassword,
            style: TextStyle(fontSize: 16.px)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.px),
            _buildPasswordInput(
                S.of(context).inputOldPassword, _oldPasswordController),
            _buildPasswordInput(
                S.of(context).inputNewPassword, _newPasswordController),
            _buildPasswordInput(
                S.of(context).inputConfirmPassword, _confirmPasswordController),
            SizedBox(height: 16.px),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.px),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _modifyPassword,
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor[700],
                    padding: EdgeInsets.symmetric(vertical: 6.px),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.px),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: _isLoading
                    ? SizedBox(
                        width: 16.px,
                        height: 16.px,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        S.of(context).confirmModify,
                        style: TextStyle(fontSize: 12.px),
                      ),
              ),
            ),
            SizedBox(height: 16.px),
            Text(
              S.of(context).passwordTips,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10.px,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

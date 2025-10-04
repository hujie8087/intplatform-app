import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class FoodSuggestionPage extends StatefulWidget {
  const FoodSuggestionPage({Key? key}) : super(key: key);

  @override
  _FoodSuggestionPageState createState() => _FoodSuggestionPageState();
}

class _FoodSuggestionPageState extends State<FoodSuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  UserInfoModel? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    String? token = await SpUtils.getString(Constants.SP_TOKEN);
    print(token);
    var user = await SpUtils.getModel('userInfo');
    if (user != null) {
      userInfo = UserInfoModel.fromJson(user);
      _nameController.text = userInfo?.user?.nickName ?? '';
      _employeeIdController.text = userInfo?.user?.userName ?? '';
      _phoneController.text = userInfo?.user?.phonenumber ?? '';
      setState(() {});
    }
  }

  void _submitSuggestion() async {
    // 防止重复提交
    if (_isLoading) return;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final data = {
          'typeId': 1,
          'contacts': _nameController.text,
          'def2': _employeeIdController.text,
          'phone': _phoneController.text,
          'def1': _foodNameController.text,
          'content': _contentController.text,
        };
        DataUtils.submitMessage(
          data,
          success: (response) {
            if (mounted) {
              ProgressHUD.showSuccess(S.of(context).submitSuccess);
              // 延迟返回上一页
              Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
              });
            }
          },
          fail: (code, msg) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
              ProgressHUD.showError(msg);
            }
          },
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ProgressHUD.showError(S.of(context).submit_failed);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).iWantToEat,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.px),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              SizedBox(height: 16.px),
              _buildSuggestionCard(),
              SizedBox(height: 24.px),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.px)),
      ),
      padding: EdgeInsets.only(top: 15.px, right: 12.px, left: 12.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).personalInfo,
            style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.px),
          _buildTextField(
            label: S.of(context).name,
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseFillIn(S.of(context).name);
              }
              return null;
            },
          ),
          SizedBox(height: 8.px),
          _buildTextField(
            label: S.of(context).employeeNumber,
            controller: _employeeIdController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseFillIn(S.of(context).employeeNumber);
              }
              return null;
            },
          ),
          SizedBox(height: 8.px),
          _buildTextField(
            label: S.of(context).phone,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseFillIn(S.of(context).phone);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.px)),
      ),
      padding: EdgeInsets.only(top: 15.px, right: 12.px, left: 12.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).dishSuggestion,
            style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.px),
          _buildTextField(
            label: S.of(context).dishName,
            controller: _foodNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseFillIn(S.of(context).dishName);
              }
              return null;
            },
          ),
          SizedBox(height: 8.px),
          _buildTextField(
            label: S.of(context).dishMethod,
            controller: _contentController,
            maxLines: 8,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseFillIn(S.of(context).dishMethod);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.px),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            maxLines == 1
                ? Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color.fromARGB(10, 0, 0, 0),
                  ),
                )
                : null,
        borderRadius: maxLines == 1 ? null : BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 12.px, color: Colors.black)),
          SizedBox(width: 10.px),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              // 校验错误信息靠右显示
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLines: maxLines,
              style: TextStyle(fontSize: 12.px, color: Colors.black),
              textAlign: maxLines > 1 ? TextAlign.start : TextAlign.right,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.px,
                  horizontal: 8.px,
                ),
                border:
                    maxLines > 1
                        ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.px),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        )
                        : InputBorder.none,
                enabledBorder:
                    maxLines > 1
                        ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.px),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        )
                        : InputBorder.none,
                focusedBorder:
                    maxLines > 1
                        ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.px),
                          borderSide: BorderSide(color: primaryColor),
                        )
                        : InputBorder.none,
                hintText: S.of(context).inputMessage(label),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 10.px),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      onPressed: _isLoading ? null : _submitSuggestion,
      color: _isLoading ? Colors.grey : (primaryColor[700] ?? primaryColor),
      textColor: Colors.white,
      child:
          _isLoading
              ? SizedBox(
                width: 16.px,
                height: 16.px,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : Text(
                S.of(context).confirmSubmit,
                style: TextStyle(fontSize: 12.px),
              ),
    );
  }

  Widget RaisedButton({
    required void Function()? onPressed,
    required Widget child,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      height: 36.px,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 64.px, right: 64.px, top: 15.px),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(16.px)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(textColor),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeIdController.dispose();
    _phoneController.dispose();
    _foodNameController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

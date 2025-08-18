import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class FoodFeedbackPage extends StatefulWidget {
  const FoodFeedbackPage({Key? key}) : super(key: key);

  @override
  _FoodFeedbackPageState createState() => _FoodFeedbackPageState();
}

class _FoodFeedbackPageState extends State<FoodFeedbackPage> {
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

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final data = {
          'typeId': 2,
          'contacts': _nameController.text,
          'def2': _employeeIdController.text,
          'phone': _phoneController.text,
          'def1': _foodNameController.text,
          'content': _contentController.text,
        };
        DataUtils.submitMessage(
          data,
          success: (response) {
            ProgressHUD.showSuccess(S.of(context).submitSuccess);
            Navigator.pop(context);
          },
          fail: (code, msg) {
            ProgressHUD.showError(msg);
          },
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).feedback, style: TextStyle(fontSize: 16.px)),
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
              _buildFeedbackCard(),
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

  Widget _buildFeedbackCard() {
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
            S.of(context).feedback,
            style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.px),
          _buildTextField(
            label: S.of(context).feedbackTitle,
            controller: _foodNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseFillIn(S.of(context).feedbackTitle);
              }
              return null;
            },
          ),
          SizedBox(height: 8.px),
          _buildTextField(
            label: S.of(context).feedbackContent,
            controller: _contentController,
            maxLines: 8,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S
                    .of(context)
                    .pleaseFillIn(S.of(context).feedbackContent);
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
      onPressed: _isLoading ? () {} : _submitFeedback,
      color: primaryColor[700] ?? primaryColor,
      textColor: Colors.white,
      child: Text(
        S.of(context).confirmSubmit,
        style: TextStyle(fontSize: 12.px),
      ),
    );
  }

  Widget RaisedButton({
    required void Function() onPressed,
    required Text child,
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
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
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

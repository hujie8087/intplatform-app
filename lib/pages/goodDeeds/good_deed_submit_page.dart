import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/http_utils.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

@AppRoute(path: 'good_deed_submit_page', name: '好人好事发布页')
class GoodDeedSubmitPage extends StatefulWidget {
  const GoodDeedSubmitPage({Key? key}) : super(key: key);

  @override
  _GoodDeedSubmitPageState createState() => _GoodDeedSubmitPageState();
}

class _GoodDeedSubmitPageState extends State<GoodDeedSubmitPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _personNameController = TextEditingController();
  final _contactInfoController = TextEditingController();
  final _remarkController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _personNameController.dispose();
    _contactInfoController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).publish_good_deeds,
          style: TextStyle(fontSize: 16.px),
        ),
      ),
      body: Column(
        children: [
          // 内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12.px),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 页面说明
                    _buildPageDescription(),

                    SizedBox(height: 12.px),

                    // 基本信息卡片
                    _buildBasicInfoCard(),

                    SizedBox(height: 12.px),

                    // 详细描述卡片
                    _buildDescriptionCard(),

                    SizedBox(height: 12.px),

                    // 个人信息卡片
                    _buildPersonInfoCard(),

                    SizedBox(height: 12.px),
                  ],
                ),
              ),
            ),
          ),

          // 底部提交区域
          _buildSubmitSection(),
        ],
      ),
    );
  }

  // 构建页面说明
  Widget _buildPageDescription() {
    return Container(
      padding: EdgeInsets.all(8.px),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.px),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.px),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: primaryColor,
              size: 20.px,
            ),
          ),
          SizedBox(width: 8.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).share_your_good_deeds,
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                SizedBox(height: 4.px),
                Text(
                  S.of(context).record_the_warm_moments_around_you,
                  style: TextStyle(fontSize: 10.px, color: AppTheme.lightText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建基本信息卡片
  Widget _buildBasicInfoCard() {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.title, color: primaryColor, size: 18.px),
              SizedBox(width: 8.px),
              Text(
                S.of(context).basic_info,
                style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.px),

          // 标题输入
          _buildInputField(
            controller: _titleController,
            label: S.of(context).title,
            hint: S.of(context).please_enter_good_deeds_title,
            icon: Icons.edit,
            maxLines: 1,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).please_enter_good_deeds_title;
              }
              if (value.trim().length < 2) {
                return S.of(context).title_at_least_2_characters;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 构建详细描述卡片
  Widget _buildDescriptionCard() {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: Colors.blue.shade600, size: 18.px),
              SizedBox(width: 8.px),
              Text(
                S.of(context).detailed_description,
                style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.px),

          // 描述输入
          _buildInputField(
            controller: _descriptionController,
            label: S.of(context).description_content,
            hint: S.of(context).please_enter_good_deeds_description,
            icon: Icons.text_fields,
            maxLines: 6,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).please_enter_good_deeds_description;
              }
              if (value.trim().length < 10) {
                return S.of(context).description_at_least_10_characters;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 构建个人信息卡片
  Widget _buildPersonInfoCard() {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.green.shade600, size: 18.px),
              SizedBox(width: 8.px),
              Text(
                S.of(context).personal_info,
                style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.px),

          // 姓名输入
          _buildInputField(
            controller: _personNameController,
            label: S.of(context).good_name,
            hint: S.of(context).please_enter_good_deeds_name,
            icon: Icons.person_outline,
            maxLines: 1,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).please_enter_good_deeds_name;
              }
              return null;
            },
          ),

          SizedBox(height: 16.px),

          // 联系方式输入
          _buildInputField(
            controller: _contactInfoController,
            label: S.of(context).contact_info,
            hint: S.of(context).please_enter_good_deeds_contact_info,
            icon: Icons.phone,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).please_enter_good_deeds_contact_info;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // 构建输入字段
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.px, color: AppTheme.lightText),
            SizedBox(width: 6.px),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.px,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkText,
              ),
            ),
            if (required)
              Text(' *', style: TextStyle(fontSize: 12.px, color: Colors.red)),
          ],
        ),

        SizedBox(height: 8.px),

        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(fontSize: 12.px, color: AppTheme.darkText),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12.px, color: AppTheme.lightText),
            filled: true,
            fillColor: backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.px),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.px),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.px),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.px),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.px),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.px,
              vertical: maxLines > 1 ? 12.px : 8.px,
            ),
          ),
        ),
      ],
    );
  }

  // 构建底部提交区域
  Widget _buildSubmitSection() {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 重置按钮
          Expanded(
            child: OutlinedButton(
              onPressed: _isSubmitting ? null : _resetForm,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade400),
                padding: EdgeInsets.symmetric(vertical: 8.px),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.px),
                ),
              ),
              child: Text(
                S.of(context).reset,
                style: TextStyle(
                  fontSize: 12.px,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.px),

          // 提交按钮
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 8.px),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.px),
                ),
              ),
              child:
                  _isSubmitting
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16.px,
                            height: 16.px,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.px),
                          Text(
                            S.of(context).submitting,
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 16.px),
                          SizedBox(width: 6.px),
                          Text(
                            S.of(context).publish,
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }

  // 重置表单
  void _resetForm() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).confirm_reset),
            content: Text(S.of(context).confirm_empty_all_input),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _titleController.clear();
                  _descriptionController.clear();
                  _personNameController.clear();
                  _contactInfoController.clear();
                  _remarkController.clear();
                  ProgressHUD.showSuccess(S.of(context).reset_success);
                },
                child: Text(S.of(context).confirm),
              ),
            ],
          ),
    );
  }

  // 提交表单
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      Map<String, dynamic> data = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'personName': _personNameController.text.trim(),
        'contactInfo': _contactInfoController.text.trim(),
        'status': 0, // 待审核状态
      };

      HttpUtils.post(
        '/other/deeds',
        data,
        success: (response) {
          setState(() {
            _isSubmitting = false;
          });

          ProgressHUD.showSuccess(S.of(context).publish_success_wait_for_audit);

          // 延迟返回上一页
          Future.delayed(Duration(seconds: 1), () {
            RouteUtils.pop(context);
          });
        },
        fail: (error, message) {
          setState(() {
            _isSubmitting = false;
          });
          ProgressHUD.showError(message);
        },
      );
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ProgressHUD.showError(S.of(context).publish_failed);
    }
  }
}

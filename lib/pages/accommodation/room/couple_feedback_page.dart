import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class CoupleFeedbackPage extends StatefulWidget {
  @override
  _CoupleFeedbackPageState createState() => _CoupleFeedbackPageState();
}

class _CoupleFeedbackPageState extends State<CoupleFeedbackPage> {
  String feedbackType = '';
  TextEditingController contentController = TextEditingController();
  bool _isLoading = false;
  ThirdUserInfoModel? userInfo;

  @override
  void initState() {
    super.initState();
    _fetchCardInfo();
  }

  void _fetchCardInfo() async {
    var userInfoData = await SpUtils.getModel('thirdUserInfo');
    if (userInfoData != null) {
      userInfo = ThirdUserInfoModel.fromJson(userInfoData);
    }
  }

  // 提交留言
  void _submitFeedback() async {
    if (feedbackType.isEmpty) {
      ProgressHUD.showError('请选择反馈类型');
      return;
    }
    if (contentController.text.isEmpty) {
      ProgressHUD.showError('请输入反馈内容');
      return;
    }
    // 防止重复提交
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'typeId': 3,
        'contacts': userInfo?.name,
        'def2': userInfo?.account,
        'phone': userInfo?.tel,
        'def1': feedbackType,
        'content': contentController.text,
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

  @override
  Widget build(BuildContext context) {
    List<String> types = [
      S.current.coupleRoom_feedback_room,
      S.current.coupleRoom_feedback_system,
      S.current.coupleRoom_feedback_other,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.coupleRoom_feedback,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 8.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 反馈类型
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.px),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.px,
                  vertical: 8.px,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '*',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14.px,
                          ),
                        ),
                        Text(
                          S.current.coupleRoom_feedback_type,
                          style: TextStyle(
                            fontSize: 14.px,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      types.length,
                      (i) => Column(
                        children: [
                          RadioListTile<String>(
                            value: types[i],
                            groupValue: feedbackType,
                            onChanged: (v) {
                              setState(() {
                                feedbackType = v!;
                              });
                            },
                            title: Text(
                              types[i],
                              style: TextStyle(fontSize: 12.px),
                            ),
                            dense: true,
                            activeColor: primaryColor,
                            contentPadding: EdgeInsets.zero,
                          ),
                          if (i != types.length - 1)
                            Divider(height: 1, color: Colors.grey.shade300),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.px),
            // 反馈内容
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.px),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.px,
                  vertical: 8.px,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '*',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14.px,
                          ),
                        ),
                        Text(
                          S.current.coupleRoom_feedback_content,
                          style: TextStyle(
                            fontSize: 14.px,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.px),
                    Container(
                      height: 120.px,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.px),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: contentController,
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.px,
                            vertical: 8.px,
                          ),
                          hintText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.px),
            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _submitFeedback();
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(
                    Size(double.infinity, 36.px),
                  ),
                  backgroundColor: WidgetStateProperty.all(primaryColor[500]),
                  textStyle: WidgetStateProperty.all(
                    TextStyle(fontSize: 14.px, color: Colors.white),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.px),
                    ),
                  ),
                ),
                child: Text(
                  S.current.coupleRoom_feedback_submit,
                  style: TextStyle(fontSize: 16.px, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

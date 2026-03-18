import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/GalleryWidget.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/repair/submit_page/repair_form_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
  ThirdUserInfoModel? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  List<AssetEntity> selectedAssets = [];
  // 是否开始拖拽
  bool isDragNow = false;
  // 是否将要删除
  bool isWillRemove = false;
  List<String> _uploadedImageUrls = [];

  Future<void> _loadUserInfo() async {
    String? token = await SpUtils.getString(Constants.SP_TOKEN);
    print(token);
    var user = await SpUtils.getModel('thirdUserInfo');
    if (user != null) {
      userInfo = ThirdUserInfoModel.fromJson(user);
      _nameController.text = userInfo?.name ?? '';
      _employeeIdController.text = userInfo?.account ?? '';
      _phoneController.text = userInfo?.tel ?? '';
      setState(() {});
    }
  }

  void _submitFeedback() async {
    // 防止重复提交
    if (_isLoading) return;

    if (_formKey.currentState!.validate()) {
      if (selectedAssets.isNotEmpty) {
        ProgressHUD.showLoadingText(S.of(context).imageUploading);
        final res = await uploadImages(selectedAssets);
        if (res.isNotEmpty) {
          setState(() {
            _uploadedImageUrls = res;
          });
        } else {
          ProgressHUD.showError('图片上传失败');
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
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
          'def4': _uploadedImageUrls.join(','),
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
          Row(
            children: [
              Text(
                S.of(context).uploadImages,
                style: TextStyle(fontSize: 12.px),
              ),
              Text(
                '(' + S.of(context).dragRemoveImage + ')',
                style: TextStyle(color: Colors.grey, fontSize: 12.px),
              ),
            ],
          ),
          SizedBox(height: 8.px),
          // 上传图片
          _buildPhotoList(),
          SizedBox(height: 16.px),
        ],
      ),
    );
  }

  // 列表图片
  Widget _buildPhotoList() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constants) {
        final double width = (constants.maxWidth - 8.px * 2) / 3;
        return Wrap(
          spacing: 8.px,
          runSpacing: 8.px,
          children: [
            for (final asset in selectedAssets)
              Draggable(
                // 拖拽的数据
                data: asset,
                // 开始拖拽
                onDragStarted: () {
                  setState(() {
                    isDragNow = true;
                  });
                },
                // 拖拽结束
                onDragEnd: (details) {
                  setState(() {
                    isDragNow = false;
                  });
                },
                onDragCompleted: () {},
                onDraggableCanceled: (velocity, offset) {
                  setState(() {
                    isDragNow = false;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return GalleryWidget(
                            initialIndex: selectedAssets.indexOf(asset),
                            items: selectedAssets,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: AssetEntityImage(
                      asset,
                      isOriginal: true,
                      width: width,
                      height: width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                feedback: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: AssetEntityImage(
                    asset,
                    isOriginal: true,
                    width: width,
                    height: width,
                    fit: BoxFit.cover,
                  ),
                ),
                childWhenDragging: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: AssetEntityImage(
                    asset,
                    isOriginal: true,
                    width: width,
                    height: width,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.3),
                  ),
                ),
              ),
            if (selectedAssets.length < 6)
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: GestureDetector(
                  onTap: () async {
                    final result = await HJBottomSheet.wxPicker(
                      context,
                      selectedAssets,
                      6,
                      RequestType.image,
                    );
                    if (result != null) {
                      selectedAssets = result;
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(Icons.add, size: 22.px),
                  ),
                ),
              ),
          ],
        );
      },
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

  Timer? _debounce;
  void _onDebounceSubmit() {
    if (_isLoading) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _submitFeedback();
    });
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 36.px,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onDebounceSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.px),
          ),
          elevation: 2,
        ),
        child: Text(
          _isLoading ? S.of(context).submitting : S.of(context).submit,
          style: TextStyle(
            fontSize: 14.px,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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

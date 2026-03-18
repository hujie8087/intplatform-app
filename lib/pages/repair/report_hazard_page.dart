import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';

import 'package:logistics_app/pages/repair/my_hazard_page.dart';
import 'package:logistics_app/pages/repair/safety_reward_page.dart';
import 'package:logistics_app/pages/repair/submit_page/repair_form_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:badges/badges.dart' as badges;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ReportHazardPage extends StatefulWidget {
  @override
  _ReportHazardPageState createState() => _ReportHazardPageState();
}

class _ReportHazardPageState extends State<ReportHazardPage> {
  final _formKey = GlobalKey<FormState>();

  // 表单控制器
  TextEditingController _hazardNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _reporterController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DictModel? selectedHazardType;
  bool isSubmitting = false;
  List<DictModel> hazardTypeList = [];
  int hiddenDangerUnreadCount = 0;

  // 选择的图片
  List<AssetEntity> selectedAssets = [];
  List<String> _uploadedImageUrls = [];

  // 选择的日期和时间
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  // 用户信息
  ThirdUserInfoModel? userInfo;

  // 获取用户信息
  void _getUserInfo() async {
    var userInfoData = await SpUtils.getModel('thirdUserInfo');
    setState(() {
      if (userInfoData != null) {
        userInfo = ThirdUserInfoModel.fromJson(userInfoData);
        _reporterController.text = userInfo!.name ?? '';
        _phoneController.text = userInfo!.tel ?? '';
      }
    });
  }

  void getHiddenDangerUnreadCount() async {
    final token = await SpUtils.getString(Constants.SP_TOKEN);
    if (token == null) {
      return;
    }
    DataUtils.getData(
      '/maintenance/hidden/danger/appNoReadNum',
      null,
      success: (data) {
        setState(() {
          hiddenDangerUnreadCount = data['data'];
        });
      },
    );
  }

  // 获取隐患类型
  Future<void> getHazardType() async {
    DataUtils.getDictDataList(
      'hazard_collection_type',
      success: (data) {
        final result =
            BaseListModel<DictModel>.fromJson(
              data,
              (json) => DictModel.fromJson(json),
            ).data ??
            [];
        this.hazardTypeList = result;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _getUserInfo();
    getHazardType();
    getHiddenDangerUnreadCount();
  }

  @override
  void dispose() {
    _hazardNameController.dispose();
    _locationController.dispose();
    _reporterController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 选择日期
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 选择时间
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // 删除图片
  void _removeImage(int index) {
    setState(() {
      selectedAssets.removeAt(index);
    });
  }

  // 提交隐患报告
  Future<void> _submitReport() async {
    // 先进行表单验证

    if (selectedHazardType == null) {
      ProgressHUD.showError(S.current.pleaseSelect(S.current.hazard_type));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ProgressHUD.showError(S.current.select_discover_date);
      return;
    }

    if (_selectedTime == null) {
      ProgressHUD.showError(S.current.select_discover_time);
      return;
    }

    if (_reporterController.text.isEmpty) {
      ProgressHUD.showError(S.current.please_enter_reporter_name);
      return;
    }

    if (_phoneController.text.isEmpty) {
      ProgressHUD.showError(S.current.please_enter_reporter_tel);
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ProgressHUD.showError(S.current.please_enter_hazard_description);
      return;
    }

    if (selectedAssets.isEmpty) {
      ProgressHUD.showError(S.current.please_upload_hazard_photo);
      return;
    }

    // 处理图片上传
    if (selectedAssets.isNotEmpty) {
      try {
        ProgressHUD.showLoadingText(S.current.imageUploading);
        final res = await uploadImages(selectedAssets);
        ProgressHUD.hide();

        if (res.isNotEmpty) {
          _uploadedImageUrls = res;
        } else {
          ProgressHUD.showError(S.current.upload_images_failed);
          return;
        }
      } catch (e) {
        ProgressHUD.hide();
        ProgressHUD.showError(
          '${S.current.upload_images_failed}：${e.toString()}',
        );
        return;
      }
    }
    setState(() {
      isSubmitting = true;
    });
    // 提交隐患报告
    DataUtils.submitHazardReport(
      {
        'name': _hazardNameController.text,
        'location': _locationController.text,
        'type': selectedHazardType!.dictValue,
        'findTime':
            _selectedDate!.toString().split(' ')[0] +
            ' ' +
            _selectedTime!.hour.toString().padLeft(2, '0') +
            ':' +
            _selectedTime!.minute.toString().padLeft(2, '0'),
        'reportPerson': _reporterController.text,
        'tel': _phoneController.text,
        'describes': _descriptionController.text,
        'url': _uploadedImageUrls.join(','),
      },
      success: (data) {
        ProgressHUD.showSuccess(S.current.submit_hazard_report_success);
        // 调整到工具箱
        // 调整到工具箱
        Navigator.pop(context);
        setState(() {
          isSubmitting = false;
        });
      },
      fail: (code, msg) {
        ProgressHUD.showError('${S.current.submit_hazard_report_fail}：$msg');
        setState(() {
          isSubmitting = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          S.of(context).report_hazard,
          style: TextStyle(fontSize: 16.px),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final result = await RouteUtils.push(context, MyHazardPage());
              print(result);
              if (result == true) {
                getHiddenDangerUnreadCount();
              }
            },
            child: badges.Badge(
              showBadge: hiddenDangerUnreadCount > 0,
              badgeContent: Text(
                hiddenDangerUnreadCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 12.px),
              ),
              position: badges.BadgePosition.topEnd(top: -15.px, end: 0.px),
              child: Row(
                children: [
                  Icon(Icons.feedback, size: 14.px, color: primaryColor[600]),
                  SizedBox(width: 2.px),
                  Text(
                    S.of(context).my_discovery,
                    style: TextStyle(fontSize: 12.px, color: primaryColor[600]),
                  ),
                  SizedBox(width: 4.px),
                ],
              ),
            ),
          ),
        ],
        leadingWidth: 140.px,
        // 奖励细则
        leading: TextButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SafetyRewardPage()),
              ),
          child: Row(
            children: [
              Icon(Icons.info, size: 14.px, color: secondaryColor[600]),
              SizedBox(width: 2.px),
              Text(
                S.of(context).reward_details,
                style: TextStyle(fontSize: 12.px, color: secondaryColor[600]),
              ),
              SizedBox(width: 4.px),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        bottom: true,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 隐患类型
                _buildSelectField(
                  label: S.of(context).hazard_type,
                  value: selectedHazardType?.dictLabel ?? '',
                  onTap: () {
                    Picker.showModalSheet(
                      context,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 标题栏
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.px,
                                vertical: 12.px,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .pleaseSelect(
                                          S.of(context).hazard_type,
                                        ),
                                    style: TextStyle(
                                      fontSize: 16.px,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 20.px,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, thickness: 0.5),
                            // 选项列表（可滚动）
                            Flexible(
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 8.px),
                                itemCount: hazardTypeList.length,
                                separatorBuilder:
                                    (context, index) => Divider(
                                      height: 1,
                                      thickness: 0.5,
                                      indent: 16.px,
                                      endIndent: 16.px,
                                    ),
                                itemBuilder: (context, index) {
                                  final hazardType = hazardTypeList[index];
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context, hazardType);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.px,
                                          vertical: 16.px,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                hazardType.dictLabel ?? '',
                                                style: TextStyle(
                                                  fontSize: 15.px,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              size: 20.px,
                                              color: Colors.grey[400],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).then((value) {
                      if (value != null && value is DictModel) {
                        setState(() {
                          selectedHazardType = value;
                        });
                      }
                    });
                  },
                  icon: Icons.warning,
                ),
                SizedBox(height: 12.px),

                // 隐患名称
                _buildFormField(
                  label: S.of(context).hazard_name,
                  controller: _hazardNameController,
                  icon: Icons.warning,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_enter_hazard_name;
                    }
                    return null;
                  },
                  hintText: S.of(context).please_enter_hazard_name,
                ),

                SizedBox(height: 12.px),

                // 地点
                _buildFormField(
                  label: S.of(context).hazard_location,
                  controller: _locationController,
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_enter_hazard_location;
                    }
                    return null;
                  },
                  hintText: S.of(context).please_enter_hazard_location,
                ),

                SizedBox(height: 12.px),

                // 日期和时间
                Row(
                  children: [
                    Expanded(
                      child: _buildSelectField(
                        label: S.of(context).select_discover_date,
                        value:
                            _selectedDate == null
                                ? S.of(context).please_select_hazard_date
                                : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                        onTap: _selectDate,
                        icon: Icons.calendar_today,
                      ),
                    ),
                    SizedBox(width: 12.px),
                    Expanded(
                      child: _buildSelectField(
                        label: S.of(context).select_discover_time,
                        value:
                            _selectedTime == null
                                ? S.of(context).please_select_hazard_time
                                : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                        onTap: _selectTime,
                        icon: Icons.access_time,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.px),

                // 上报人信息
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        label: S.of(context).reporter,
                        controller: _reporterController,
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).please_enter_reporter_name;
                          }
                          return null;
                        },
                        hintText: S.of(context).please_enter_reporter_name,
                      ),
                    ),
                    SizedBox(width: 12.px),
                    Expanded(
                      child: _buildFormField(
                        label: S.of(context).reporter_tel,
                        controller: _phoneController,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).please_enter_reporter_tel;
                          }
                          return null;
                        },
                        hintText: S.of(context).please_enter_reporter_tel,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.px),

                // 隐患描述
                _buildFormField(
                  label: S.of(context).hazard_description,
                  controller: _descriptionController,
                  icon: Icons.description,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_enter_hazard_description;
                    }
                    return null;
                  },
                  hintText: S.of(context).please_enter_hazard_description,
                ),

                SizedBox(height: 12.px),

                // 隐患图片
                _buildImageSection(),

                SizedBox(height: 12.px),

                // 提交按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10.px),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.px),
                      ),
                      elevation: 0,
                    ),
                    child:
                        isSubmitting
                            ? SizedBox(
                              width: 16.px,
                              height: 16.px,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              S.of(context).hazard_submit,
                              style: TextStyle(
                                fontSize: 14.px,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),

                SizedBox(height: 30.px),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建表单字段
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16.px, color: Colors.grey[600]),
                SizedBox(width: 6.px),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (validator != null) ...[
                  Text(
                    ' *',
                    style: TextStyle(color: Colors.red, fontSize: 12.px),
                  ),
                ],
              ],
            ),
            SizedBox(height: 8.px),
            TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: TextStyle(fontSize: 12.px),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建选择字段
  Widget _buildSelectField({
    required String label,
    required String value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.px),
        child: Padding(
          padding: EdgeInsets.all(12.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16.px, color: Colors.grey[600]),
                  SizedBox(width: 6.px),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.px,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(color: Colors.red, fontSize: 12.px),
                  ),
                ],
              ),
              SizedBox(height: 8.px),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value.isEmpty ? S.current.pleaseSelect(label) : value,
                      style: TextStyle(
                        fontSize: 12.px,
                        color:
                            value.isEmpty ? Colors.grey[700] : Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[500],
                    size: 16.px,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建图片选择区域
  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_camera, size: 16.px, color: Colors.grey[600]),
                SizedBox(width: 6.px),
                Text(
                  S.of(context).hazard_photo,
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                // 必填
                Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 12.px),
                ),
              ],
            ),
            SizedBox(height: 8.px),
            Row(
              children: [
                Text(
                  S.of(context).please_upload_hazard_photo_tips,
                  style: TextStyle(fontSize: 10.px, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8.px),
            Wrap(
              spacing: 8.px,
              runSpacing: 8.px,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: [
                for (final asset in selectedAssets)
                  Container(
                    margin: EdgeInsets.only(right: 8.px),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.px),
                          child: AssetEntityImage(
                            asset,
                            width: 80.px,
                            height: 80.px,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2.px,
                          right: 2.px,
                          child: GestureDetector(
                            onTap:
                                () =>
                                    _removeImage(selectedAssets.indexOf(asset)),
                            child: Container(
                              padding: EdgeInsets.all(2.px),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 12.px,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                        width: 80.px,
                        height: 80.px,
                        color: Colors.grey[200],
                        child: Icon(Icons.add, size: 22.px),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

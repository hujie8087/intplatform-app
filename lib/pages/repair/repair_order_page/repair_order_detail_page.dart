import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/divider_widget.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/repair_utils.dart';
import 'package:logistics_app/http/model/repair_view_model.dart';
import 'package:logistics_app/http/model/repaire_type_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class RepairOrderDetailPage extends StatefulWidget {
  final RepairViewModel order;

  const RepairOrderDetailPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  _RepairOrderDetailPageState createState() => _RepairOrderDetailPageState();
}

class _RepairOrderDetailPageState extends State<RepairOrderDetailPage> {
  final TextEditingController _noteController = TextEditingController();
  RepairTypeModel? selectedRepairType;
  String? selectedRepairTime;
  int selectedStatus = 1;
  List<RepairTypeModel> repairTypes = [];
  List<String> images = [];
  UserInfoModel? userInfo;

  // 获取维修类型
  Future<void> _getRepairType() async {
    var params = {
      'pageNum': 1,
      'pageSize': 1000,
      'status': '0',
    };

    RepairUtils.getRepairType(params, success: (data) {
      setState(() {
        repairTypes = (data['rows'] as List)
            .map((type) => RepairTypeModel.fromJson(type))
            .toList();
      });
    });
  }

  Future<void> _getUserInfo() async {
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    }
  }

  // 维修状态选项

  final List<Map<String, dynamic>> statusOptions = [
    {'label': '已维修', 'value': 1},
    {'label': '待返修', 'value': 2},
  ];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    selectedStatus = widget.order.repairState ?? 0;
    _noteController.text = widget.order.repairNote ?? '';
    _getRepairType();

    setState(() {
      if (widget.order.repairPhoto != '') {
        images = widget.order.repairPhoto!.split(',');
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // 提交处理结果
  void _submitRepair() {
    if (selectedRepairType == null) {
      ProgressHUD.showError('请选择维修类型');
      return;
    }
    if (selectedRepairTime == null) {
      ProgressHUD.showError('请选择维修时间');
      return;
    }
    if (_noteController.text.isEmpty) {
      ProgressHUD.showError('请填写维修说明');
      return;
    }

    DialogFactory.instance.showConfirmDialog(
      context: context,
      title: '确认提交',
      content: '是否确认提交维修处理结果？',
      confirmClick: () {
        widget.order.repairType = selectedRepairType?.id;
        widget.order.repairTime = selectedRepairTime;
        widget.order.repairNote = _noteController.text;
        widget.order.repairState = selectedStatus;
        widget.order.engineerId = userInfo?.user?.userId;
        widget.order.engineer = userInfo?.user?.nickName;
        RepairUtils.editRepairDetail(
          widget.order,
          success: (data) {
            ProgressHUD.showSuccess('提交成功');
            DataUtils.getUserInfoByUsername(widget.order.createBy,
                success: (data) {
              if (data['msg'] != null) {
                DataUtils.sendOneMessage(
                  {
                    'title': '您的维修单已处理',
                    'body':
                        widget.order.repairArea! + "/" + widget.order.roomNo!,
                    'type': "1",
                    'payload': '',
                    'userName': widget.order.createBy,
                    'equipmentToken': data['msg']
                  },
                  success: (data) {
                    // ProgressHUD.showSuccess('提交成功');
                    Navigator.pop(context, true);
                  },
                  fail: (code, msg) {
                    ProgressHUD.showError(msg);
                  },
                );
              }
            });
          },
          fail: (code, msg) {
            ProgressHUD.showError(msg);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('维修单处理', style: TextStyle(fontSize: 16.px)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单基本信息卡片
            Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.px),
                ),
                child: Padding(
                    padding: EdgeInsets.only(
                      left: 8.px,
                      right: 8.px,
                      top: 8.px,
                      bottom: 4.px,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              label: '订单编号:',
                              value: widget.order.repairNo,
                              icon: Icon(Icons.info_outline,
                                  size: 16.px, color: Colors.grey)),
                          _buildInfoRow(
                              label: '报修房间号:',
                              value: widget.order.roomNo,
                              icon: Icon(Icons.home,
                                  size: 16.px, color: Colors.grey)),
                          _buildInfoRow(
                              label: '报修区域:',
                              value: widget.order.repairArea,
                              icon: Icon(Icons.location_on,
                                  size: 16.px, color: Colors.grey)),

                          _buildInfoRow(
                              label: '联系人:',
                              value: widget.order.repairPerson,
                              icon: Icon(Icons.person,
                                  size: 16.px, color: Colors.grey)),
                          _buildInfoRow(
                              label: '联系电话:',
                              value: widget.order.tel,
                              icon: Icon(Icons.phone,
                                  size: 16.px, color: Colors.grey)),
                          _buildInfoRow(
                              label: '提交时间:',
                              value: widget.order.createTime,
                              icon: Icon(Icons.access_time,
                                  size: 16.px, color: Colors.grey)),
                          _buildInfoRow(
                              label: '报修信息:',
                              value: widget.order.repairMessage,
                              icon: Icon(Icons.message,
                                  size: 16.px, color: Colors.grey)),
                          if (widget.order.repairState == 2)
                            _buildInfoRow(
                                label: '返修信息:',
                                value: widget.order.repairMessage,
                                icon: Icon(Icons.feedback,
                                    size: 16.px, color: Colors.grey),
                                labelColor: secondaryColor),

                          // 报修图片
                          if (images.length > 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.image,
                                        size: 16.px, color: Colors.grey),
                                    SizedBox(height: 4.px),
                                    Text(
                                      '报修图片:',
                                      style: TextStyle(
                                        fontSize: 12.px,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4.px,
                                ),
                                GridView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // 每行显示3张图片
                                    crossAxisSpacing: 8.px,
                                    mainAxisSpacing: 8.px,
                                  ),
                                  itemCount: images.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PhotoViewGallery(
                                                      pageOptions: images
                                                          .map(
                                                            (item) =>
                                                                PhotoViewGalleryPageOptions(
                                                              imageProvider:
                                                                  NetworkImage(
                                                                      APIs.imagePrefix +
                                                                          item),
                                                              initialScale:
                                                                  PhotoViewComputedScale
                                                                      .contained,
                                                              heroAttributes:
                                                                  PhotoViewHeroAttributes(
                                                                tag:
                                                                    'galleryTag_$index',
                                                              ),
                                                              onTapUp: (context,
                                                                      details,
                                                                      controllerValue) =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                            ),
                                                          )
                                                          .toList(),
                                                      backgroundDecoration:
                                                          BoxDecoration(
                                                        color: Colors.white,
                                                      ),
                                                      pageController:
                                                          PageController(
                                                              initialPage:
                                                                  index),
                                                    )));
                                      },
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Image.network(
                                          APIs.imagePrefix + images[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                        ]))),

            SizedBox(height: 20.px),

            // 处理信息表单
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.px),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.px),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 维修类型下拉选择
                    Row(
                      children: [
                        Text(
                          '维修类型',
                          style: TextStyle(
                            fontSize: 14.px,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.px),
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                Picker.showModalSheet(context,
                                    child: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          for (final type in repairTypes)
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(
                                                        context, type);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 44.px,
                                                    child:
                                                        Text(type.name ?? ''),
                                                  ),
                                                ),
                                                DividerWidget()
                                              ],
                                            ),
                                        ],
                                      ),
                                    )).then((value) {
                                  if (value != null) {
                                    print(value);
                                    setState(() {
                                      selectedRepairType = value;
                                    });
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(selectedRepairType?.name ?? '请选择维修类型'),
                                  Icon(Icons.chevron_right,
                                      size: 16.px, color: Colors.grey),
                                ],
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 16.px),

                    // 维修时间选择
                    Text(
                      '维修时间',
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.px),
                    InkWell(
                      onTap: () {
                        DatePicker.showDateTimePicker(
                          context,
                          showTitleActions: true,
                          onConfirm: (date) {
                            setState(() {
                              selectedRepairTime = date.toString();
                            });
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.zh,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.px),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8.px),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedRepairTime ?? '请选择维修时间',
                                style: TextStyle(
                                  fontSize: 12.px,
                                  color: selectedRepairTime != null
                                      ? Colors.black87
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                            Icon(Icons.calendar_today,
                                size: 16.px, color: Colors.grey[600]),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16.px),

                    // 维修状态选择
                    Text(
                      '维修状态',
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.px),
                    Wrap(
                      spacing: 8.px,
                      runSpacing: 8.px,
                      children: statusOptions.map((status) {
                        bool isSelected = selectedStatus == status['value'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = status['value'];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.px,
                              vertical: 6.px,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? primaryColor : Colors.grey[100],
                              borderRadius: BorderRadius.circular(20.px),
                            ),
                            child: Text(
                              status['label'],
                              style: TextStyle(
                                fontSize: 12.px,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 16.px),

                    // 维修说明输入框
                    Text(
                      '维修说明',
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.px),
                    TextField(
                      controller: _noteController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: '请输入维修说明',
                        hintStyle:
                            TextStyle(fontSize: 12.px, color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.px),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.px),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.px),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        contentPadding: EdgeInsets.all(12.px),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(5.px),
          child: ElevatedButton(
            onPressed: _submitRepair,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.px),
              ),
              padding: EdgeInsets.symmetric(vertical: 5.px),
            ),
            child: Text(
              '提交',
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    String? value,
    required Icon icon,
    MaterialColor labelColor = Colors.grey,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.px),
      child: Row(
        children: [
          icon,
          SizedBox(width: 8.px),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.px,
              color: labelColor,
            ),
          ),
          SizedBox(width: 8.px),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: 12.px,
                color: labelColor == Colors.grey ? Colors.black87 : labelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

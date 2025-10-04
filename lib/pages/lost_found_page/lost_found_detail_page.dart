import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/GalleryWidget.dart';
import 'package:logistics_app/common_ui/divider_widget.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/found_model.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_view_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/route/route_annotation.dart';

@AppRoute(path: 'lost_found_detail_page', name: '失物招领详情页')
class LostFoundDetailPage extends StatefulWidget {
  const LostFoundDetailPage({Key? key}) : super(key: key);

  @override
  _LostFoundDetailPageState createState() => _LostFoundDetailPageState();
}

class _LostFoundDetailPageState extends State<LostFoundDetailPage> {
  String? title;
  String? content;
  final _formKey = GlobalKey<FormState>();
  final _lostFoundViewModel = LostFoundViewModel();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _receivePlaceController = TextEditingController();
  String type = '';
  List<String> uploadedImagesList = [];
  List<AssetEntity> selectedAssets = [];
  String _uploadedImageUrls = '';
  // 是否开始拖拽
  bool isDragNow = false;

  DateTime? _selectedDate;
  int? id;

  // 是否是编辑
  bool isEdit = false;

  // 获取详情
  Future<void> getDetail(String id) async {
    final result = await _lostFoundViewModel.getDetail(id);
    if (result != null) {
      setState(() {
        _itemNameController.text = result.lostName ?? '';
        _locationController.text = result.foundPlace ?? '';
        _nameController.text = result.receiveName ?? '';
        _phoneController.text = result.tel ?? '';
        _receivePlaceController.text = result.receivePlace ?? '';
        _selectedDate =
            result.foundTime != null ? DateTime.parse(result.foundTime!) : null;
        _typeController.text = result.def2 ?? '';
        _descriptionController.text = result.remark ?? '';
        _uploadedImageUrls = result.photo ?? '';
        // 处理已上传的图片URL
        if (result.photo?.isNotEmpty == true) {
          uploadedImagesList =
              result.photo!.split(',').where((url) => url.isNotEmpty).toList();
        }
        isEdit = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _typeController.text = '1';
    // 获取路由参数
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var map = ModalRoute.of(context)?.settings.arguments;
      if (map is Map) {
        id = map['id'];
        if (id != null) {
          await getDetail(id.toString());
        }
        setState(() {});
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> submitLostFound(FoundModel params) async {
    DataUtils.submitLostFound(
      params,
      success: (data) {
        Navigator.pop(context, {
          'success': true,
          'msg': S.of(context).toBeAuditedMessage,
        });
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
  }

  Future<void> updateLostFound(FoundModel params) async {
    DataUtils.updateLostFound(
      params,
      success: (data) {
        Navigator.pop(context, {
          'success': true,
          'msg': S.of(context).editToBeAuditedMessage,
        });
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
  }

  Future<void> _submit() async {
    // 处理图片
    List<String> allImageUrls = [...uploadedImagesList];

    // 如果有新选择的图片，则上传它们
    if (selectedAssets.isNotEmpty) {
      try {
        var fileUrls = await _lostFoundViewModel.uploadImages(selectedAssets);
        allImageUrls.addAll(fileUrls);
        _uploadedImageUrls = allImageUrls.join(',');
      } catch (e) {
        print('图片上传错误: ${e.toString()}');
        ProgressHUD.showError(S.of(context).uploadImageFailed);
        return;
      }
    } else {
      // 使用已有的图片URLs
      _uploadedImageUrls = uploadedImagesList.join(',');
    }

    if (_formKey.currentState!.validate()) {
      // 提交数据
      final FoundModel params = FoundModel(
        lostName: _itemNameController.text,
        foundTime: _selectedDate?.toIso8601String(),
        foundPlace: _locationController.text,
        remark: _descriptionController.text,
        photo: _uploadedImageUrls,
        tel: _phoneController.text,
        receiveName: _nameController.text,
        receivePlace: _receivePlaceController.text,
        def2: _typeController.text,
        reviewStatus: 0,
      );
      if (isEdit) {
        params.id = id;
        await updateLostFound(params);
      } else {
        await submitLostFound(params);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).publishInfo,
          style: TextStyle(fontSize: 16.px),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(8.px),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.px, horizontal: 16.px),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPhotoList(),
                  // 类型，失物，拾物
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).type,
                          style: TextStyle(
                            fontSize: 12.px,
                            color: Colors.black,
                            height: 3,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        // 类型选择，从屏幕底部选择
                        GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.px,
                              vertical: 5.px,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.px),
                            ),
                            width: double.infinity,
                            height: 30.px,
                            child: Text(
                              _typeController.text == '0'
                                  ? S.of(context).lost
                                  : S.of(context).found,
                              style: TextStyle(
                                fontSize: 12.px,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildFormColumn(S.of(context).itemName, _itemNameController),
                  _buildFormColumn(
                    _typeController.text == '0'
                        ? S.of(context).lostPlace
                        : S.of(context).receivePlace,
                    _locationController,
                  ),
                  _buildFormColumn(
                    S.of(context).contactPerson,
                    _nameController,
                  ),
                  _buildFormColumn(
                    S.of(context).contactNumber,
                    _phoneController,
                    keyboardType: TextInputType.number,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _typeController.text == '0'
                            ? S.of(context).lostTime
                            : S.of(context).receiveTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 3,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.date_range),
                              SizedBox(width: 10),
                              Text(
                                _selectedDate == null
                                    ? S.of(context).selectDate
                                    : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_typeController.text == '1')
                    _buildFormColumn(
                      S.of(context).receivePlace,
                      _receivePlaceController,
                    ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.teal,
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          S.of(context).confirmPublish,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormColumn(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.px, color: Colors.black, height: 3),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorHeight: 20.px,
            style: TextStyle(fontSize: 12.px),
            decoration: InputDecoration(
              hintText: S.of(context).pleaseInput(label),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.px),
              filled: true,
              fillColor: Colors.white,
              isCollapsed: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.px),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.px,
                vertical: 5.px,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseInput(label);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        // 圆角
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.px, horizontal: 8.px),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 让内容自适应高度
            children: [
              ListTile(
                title: Text(
                  S.of(context).lost,
                  style: TextStyle(fontSize: 14.px),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _typeController.text = '0';
                  Navigator.pop(context, S.of(context).lost);
                },
              ),
              DividerWidget(),
              ListTile(
                title: Text(
                  S.of(context).found,
                  style: TextStyle(fontSize: 14.px),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  _typeController.text = '1';
                  Navigator.pop(context, S.of(context).found);
                },
              ),
              DividerWidget(),
              ListTile(
                title: Text(
                  S.of(context).cancel,
                  style: TextStyle(fontSize: 14.px),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        // 处理选择结果
        print("你选择了: $value");
      }
    });
  }

  // 列表图片
  Widget _buildPhotoList() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = (constraints.maxWidth - 8.px * 2) / 3;
        return Wrap(
          spacing: 8.px,
          runSpacing: 8.px,
          children: [
            // 显示已上传的远程图片
            ...uploadedImagesList.map(
              (imageUrl) => Container(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // 显示图片预览
                        _previewNetworkImage(imageUrl);
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.px),
                        ),
                        child: Image.network(
                          APIs.imagePrefix + imageUrl, // 根据实际URL格式调整
                          width: width,
                          height: width,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: width,
                                height: width,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 20.px,
                      height: 20.px,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              uploadedImagesList.remove(imageUrl);
                              // 更新 _uploadedImageUrls 字符串
                              _uploadedImageUrls = uploadedImagesList.join(',');
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 12.px,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 显示新选择的本地图片
            ...selectedAssets.map(
              (asset) => Container(
                child: Stack(
                  children: [
                    GestureDetector(
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
                          borderRadius: BorderRadius.circular(5.px),
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
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 20.px,
                      height: 20.px,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              selectedAssets.remove(asset);
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 12.px,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 添加图片按钮
            if (uploadedImagesList.length + selectedAssets.length < 3)
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.px),
                ),
                child: GestureDetector(
                  onTap: () async {
                    final result = await HJBottomSheet.wxPicker(
                      context,
                      selectedAssets,
                      3 - uploadedImagesList.length, // 剩余可选数量
                    );
                    if (result != null) {
                      selectedAssets = result;
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: width,
                    height: width,
                    color: Colors.white,
                    child: Icon(Icons.add, size: 22.px),
                  ),
                ),
              ),
            Container(
              width: double.infinity,
              child: Text(
                '最多添加三张',
                style: TextStyle(fontSize: 12.px, color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  // 预览远程图片
  void _previewNetworkImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                child: Image.network(
                  APIs.imagePrefix + imageUrl,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/GalleryWidget.dart';
import 'package:logistics_app/common_ui/cascade_tree_picker.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:dio/dio.dart' as dio;
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/repair_form_model.dart';
import 'package:logistics_app/http/model/upload_image_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/repair/repair_data_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

Future<List<String>> uploadImages(List<AssetEntity> selectedAssets) async {
  List<String> fileUrl = [];
  List<File> files = [];
  final formData = dio.FormData();
  for (var asset in selectedAssets) {
    final file = await asset.file;
    if (file != null) {
      files.add(file);
    }
  }
  for (var file in files) {
    formData.files.add(MapEntry(
      'files',
      await dio.MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
    ));
  }
  // 使用 Completer 处理异步回调
  final completer = Completer<Map<String, dynamic>>();

  DataUtils.uploadFile(formData, success: (data) {
    completer.complete(data);
  }, fail: (code, msg) {
    completer.completeError('Upload failed with code: $code, message: $msg');
  });
  try {
    final data = await completer.future;
    final response = UploadImageModel.fromJson(data);
    if (response.data != null && response.data!.isNotEmpty) {
      for (var item in response.data!) {
        fileUrl.add(item.url!);
      }
    }
  } catch (e) {
    print(e);
  }
  return fileUrl;
}

class RepairFormPage extends StatefulWidget {
  const RepairFormPage({Key? key}) : super(key: key);

  @override
  _RepairFormPage createState() => _RepairFormPage();
}

class Item {
  String? title;
  String? id;
  String? pid;
  String? remark;
  List<Item>? children;
}

class _RepairFormPage extends State<RepairFormPage>
    with TickerProviderStateMixin {
  Animation<double>? opacityAnimation;
  AnimationController? animationController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _repairPersonController = TextEditingController();
  final TextEditingController _repairMessageController =
      TextEditingController();
  List<String> _uploadedImageUrls = [];
  var model = RepairDataModel();
  String roomValue = '请选择';
  List<dynamic> values = [];
  String repairKey = '';

  bool _isLoading = false;
  // 选择的图片
  List<AssetEntity> selectedAssets = [];
  List<dio.MultipartFile> files = [];

  // 是否开始拖拽
  bool isDragNow = false;

  // 是否将要删除
  bool isWillRemove = false;

  late List<Item> items;

  Future<void> _fetchData() async {
    var userInfo = await SpUtils.getModel('userInfo');
    UserInfoModel userInfoModel = UserInfoModel.fromJson(userInfo);
    // 更新状态
    setState(() {
      repairKey = DateTime.now().millisecondsSinceEpoch.toString() +
          userInfoModel.user!.userId.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
    animationController!.forward();
    model.getBuildingTreeModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: opacityAnimation!,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 50 * (1.0 - opacityAnimation!.value), 0.0),
                    child: Scaffold(
                      backgroundColor: AppTheme.background,
                      appBar: AppBar(
                        title: Text(
                          '在线报修',
                          style: TextStyle(fontSize: 18),
                        ),
                        centerTitle: true,
                      ),
                      body: SafeArea(
                        top: true,
                        child: SingleChildScrollView(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '报修地址',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              height: 3),
                                          textAlign: TextAlign.left,
                                        ),
                                        Container(
                                            height: 40,
                                            width: double.infinity,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (model.list!.isNotEmpty) {
                                                  CascadeTreePicker.show(
                                                      context,
                                                      data: model.list!,
                                                      values: values,
                                                      labelKey: 'title',
                                                      valuesKey: 'id',
                                                      title: '请选择报修位置',
                                                      clickCallBack:
                                                          (selectItem,
                                                              selectArr) {
                                                    setState(() {
                                                      print(selectItem);
                                                      print(selectArr);
                                                      values = selectArr;
                                                      List<Map<String, dynamic>>
                                                          mappedSelectArr =
                                                          List<
                                                                  Map<String,
                                                                      dynamic>>.from(
                                                              selectArr);
                                                      roomValue =
                                                          mappedSelectArr
                                                              .map((item) =>
                                                                  item['title'])
                                                              .join('/');
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      roomValue,
                                                      style: TextStyle(
                                                        color: values.isEmpty
                                                            ? Colors.grey
                                                            : Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.keyboard_arrow_right,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  _buildFormColumn(
                                      '报修人', _repairPersonController,
                                      validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return '报修人不能为空';
                                    }
                                    return null;
                                  }),
                                  _buildFormColumn('联系电话', _telController,
                                      keyboardType: TextInputType.phone,
                                      validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return '联系电话不能为空';
                                    }
                                    return null;
                                  }),
                                  _buildFormColumn(
                                      '报修内容', _repairMessageController,
                                      maxLines: 8, validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return '报修内容不能为空';
                                    }
                                    return null;
                                  }),
                                  SizedBox(height: 16.0),
                                  Row(
                                    children: [
                                      Text('上传报修图片'),
                                      Text(
                                        '(拖动图片可删除)',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  _buildPhotoList(),
                                  Container(
                                    child: _isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                primaryColor),
                                          ))
                                        : RaisedButton(
                                            onPressed: () async {
                                              if (values.isEmpty) {
                                                showToast('请选择报修地址');
                                                return;
                                              }
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              // 校验表单
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                // 上传图片
                                                if (selectedAssets.isNotEmpty) {
                                                  ProgressHUD.showLoadingText(
                                                      '图片上传中...');
                                                  final res =
                                                      await uploadImages(
                                                          selectedAssets);
                                                  setState(() {
                                                    _uploadedImageUrls = res;
                                                  });
                                                }
                                                // 提交表单
                                                _formKey.currentState!.save();
                                                model.repairFormModel =
                                                    RepairFormModel(
                                                  repairPerson:
                                                      _repairPersonController
                                                          .text,
                                                  tel: _telController.text,
                                                  repairArea: values[0]
                                                      ['title'],
                                                  repairAreaId: values[0]['id'],
                                                  repairMessage:
                                                      _repairMessageController
                                                          .text,
                                                  repairPhoto:
                                                      _uploadedImageUrls
                                                          .join(','),
                                                  repairRoomId:
                                                      values[values.length - 1]
                                                          ['id'],
                                                  roomNo:
                                                      values[values.length - 1]
                                                          ['title'],
                                                  repairKey: repairKey,
                                                );
                                                model
                                                    .addRepairModel()
                                                    .then((res) {
                                                  ProgressHUD.hide();
                                                  if (res.success) {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Text(
                                                                '保修单提交成功！'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    '确定',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            primaryColor),
                                                                  )),
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    showToast(
                                                        res.errorMessage ??
                                                            '提交失败');
                                                  }
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                });
                                              }
                                            },
                                            child: Text('提交报修'),
                                            color: primaryColor[700] ??
                                                primaryColor,
                                            textColor: Colors.white,
                                          ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      bottomSheet: isDragNow ? _buildRemoveBar() : null,
                    )));
          }),
    );
  }

  // 删除bar
  Widget _buildRemoveBar() {
    return DragTarget<AssetEntity>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 60,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: isWillRemove ? Colors.red : Colors.red[300],
              borderRadius: BorderRadius.zero),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_forever_sharp,
                color: Colors.white,
              ),
              Text(
                '拖拽到这里删除',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
      },
      onWillAccept: (data) {
        setState(() {
          isWillRemove = true;
        });
        return true;
      },
      onAccept: (data) {
        setState(() {
          selectedAssets.remove(data);
          isWillRemove = false;
        });
      },
      onLeave: (data) {
        setState(() {
          isWillRemove = false;
        });
      },
    );
  }

  // 列表图片
  Widget _buildPhotoList() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constants) {
      final double width = (constants.maxWidth - 10 * 2) / 3;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GalleryWidget(
                        initialIndex: selectedAssets.indexOf(asset),
                        items: selectedAssets);
                  }));
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: AssetEntityImage(asset,
                      isOriginal: true,
                      width: width,
                      height: width,
                      fit: BoxFit.cover),
                ),
              ),
              feedback: Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: AssetEntityImage(asset,
                    isOriginal: true,
                    width: width,
                    height: width,
                    fit: BoxFit.cover),
              ),
              childWhenDragging: Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: GestureDetector(
                onTap: () async {
                  final result =
                      await HJBottomSheet.wxPicker(context, selectedAssets);
                  if (result != null) {
                    selectedAssets = result;
                    setState(() {});
                  }
                },
                child: Container(
                  width: width,
                  height: width,
                  color: Colors.white,
                  child: Icon(
                    Icons.add,
                    size: 24,
                  ),
                ),
              ),
            )
        ],
      );
    });
  }

  Widget _buildFormColumn(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      int maxLines = 1,
      validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.black, height: 3),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: '请输入 $label',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              isCollapsed: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget RaisedButton(
      {required void Function() onPressed,
      required Text child,
      required Color color,
      required Color textColor}) {
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 70, right: 70, top: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(20)),
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
}

void showText(str) {
  ProgressHUD.showText(str.toString());
}

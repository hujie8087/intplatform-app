import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/GalleryWidget.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/repair_form_model.dart';
import 'package:logistics_app/http/model/upload_image_model.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/add_address_page.dart';
import 'package:logistics_app/pages/repair/components/my_address_view.dart';
import 'package:logistics_app/pages/repair/repair_data_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
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
// 上传图片
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
  final TextEditingController _repairMessageController =
      TextEditingController();
  List<String> _uploadedImageUrls = [];
  var model = RepairDataModel();
  String roomValue = S.current.pleaseSelect('');
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

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
    animationController!.forward();
    // 获取用户地址列表数据
    model.getMyAddressList(1, 10000);
    sendMessage();
  }

// 第一个页面
  void _navigateToSecondPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAddressPage()),
    );
    // 处理返回值
    if (result == true) {
      model.getMyAddressList(1, 10000).then((value) {
        // _refreshController.refreshCompleted();
        setState(() {});
      });
    }
  }

// 发送消息通知
  void sendMessage() {
    DataUtils.sendOneMessage(
      {
        'title': '维修通知',
        'body': '您有新的维修订单，请及时处理',
        "address": model.defaultAddress?.detailedAddress ?? '',
        "remark": _repairMessageController.text,
        "type": 1,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<RepairDataModel>(
        builder: (context, repairDataModel, child) {
          return AnimatedBuilder(
              animation: animationController!,
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                    opacity: opacityAnimation!,
                    child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 50.px * (1.0 - opacityAnimation!.value), 0.0),
                        child: Scaffold(
                          backgroundColor: AppTheme.background,
                          appBar: AppBar(
                            title: Text(
                              S.of(context).repairOnline,
                              style: TextStyle(fontSize: 16.px),
                            ),
                            centerTitle: true,
                          ),
                          body: SafeArea(
                            top: true,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(
                                  left: 16.px, right: 16.px, bottom: 16.px),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 8.px,
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.px)),
                                        onTap: () => {
                                          Picker.showModalSheet(
                                            context,
                                            child: ChangeNotifierProvider.value(
                                              value: model,
                                              child: MyAddressView(
                                                addressList: model.addressList,
                                                defaultAddress:
                                                    model.defaultAddress,
                                                onAddressSelected: (address) {
                                                  Navigator.pop(
                                                      context, address);
                                                },
                                                onAddAddress:
                                                    _navigateToSecondPage,
                                              ),
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              model.defaultAddress = value;
                                              setState(() {});
                                            }
                                          })
                                        },
                                        child: Ink(
                                            padding: EdgeInsets.all(8.px),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      8.px)), // 确保边框效果
                                            ),
                                            child: model.defaultAddress != null
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              model.defaultAddress
                                                                      ?.detailedAddress ??
                                                                  '',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.px,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              height: 5.px,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    model.defaultAddress
                                                                            ?.name ??
                                                                        '',
                                                                    style: TextStyle(
                                                                        fontSize: 12
                                                                            .px,
                                                                        color: Colors
                                                                            .grey)),
                                                                SizedBox(
                                                                  width: 8.px,
                                                                ),
                                                                Text(
                                                                    model.defaultAddress
                                                                            ?.tel ??
                                                                        '',
                                                                    style: TextStyle(
                                                                        fontSize: 12
                                                                            .px,
                                                                        color: Colors
                                                                            .grey))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.edit,
                                                        color: primaryColor,
                                                        size: 18.px,
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        S
                                                            .of(context)
                                                            .pleaseSelect(S
                                                                .of(context)
                                                                .address),
                                                        style: TextStyle(
                                                            fontSize: 12.px,
                                                            color:
                                                                primaryColor),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_right,
                                                        color: primaryColor,
                                                      )
                                                    ],
                                                  )),
                                      ),
                                      _buildFormColumn(
                                          S.of(context).repairContent,
                                          _repairMessageController,
                                          maxLines: 8, validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return S
                                              .of(context)
                                              .repairContentNotEmpty;
                                        }
                                        return null;
                                      }),
                                      SizedBox(height: 16.px),
                                      Row(
                                        children: [
                                          Text(
                                            S.of(context).uploadImages,
                                            style: TextStyle(fontSize: 14.px),
                                          ),
                                          Text(
                                            '(' +
                                                S.of(context).dragRemoveImage +
                                                ')',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.px),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8.px),
                                      _buildPhotoList(),
                                      Container(
                                        child: _isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        primaryColor),
                                              ))
                                            : RaisedButton(
                                                onPressed: () async {
                                                  if (model.defaultAddress ==
                                                      null) {
                                                    ProgressHUD.showError(S
                                                        .of(context)
                                                        .repairAddressNotEmpty);
                                                    return;
                                                  }
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  // 校验表单
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    // 上传图片
                                                    if (selectedAssets
                                                        .isNotEmpty) {
                                                      ProgressHUD
                                                          .showLoadingText(S
                                                              .of(context)
                                                              .imageUploading);
                                                      final res =
                                                          await uploadImages(
                                                              selectedAssets);
                                                      if (res.isNotEmpty) {
                                                        setState(() {
                                                          _uploadedImageUrls =
                                                              res;
                                                        });
                                                      } else {
                                                        ProgressHUD.showError(
                                                            '图片上传失败');
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        return;
                                                      }
                                                    }
                                                    // 提交表单
                                                    _formKey.currentState!
                                                        .save();
                                                    model.repairFormModel =
                                                        RepairFormModel(
                                                      repairPerson: model
                                                          .defaultAddress?.name,
                                                      tel: model
                                                          .defaultAddress?.tel,
                                                      repairArea: model
                                                          .defaultAddress?.area,
                                                      repairAreaId: model
                                                          .defaultAddress
                                                          ?.areaId,
                                                      repairMessage:
                                                          _repairMessageController
                                                              .text,
                                                      repairPhoto:
                                                          _uploadedImageUrls
                                                              .join(','),
                                                      repairRoomId: model
                                                          .defaultAddress
                                                          ?.region,
                                                      roomNo: model
                                                          .defaultAddress
                                                          ?.roomNo,
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
                                                                content: Text(S
                                                                    .of(context)
                                                                    .repairSubmitSuccess),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        S
                                                                            .of(context)
                                                                            .confirm,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14.px,
                                                                            color: primaryColor),
                                                                      )),
                                                                ],
                                                              );
                                                            });
                                                      } else {
                                                        ProgressHUD.showError(res
                                                                .errorMessage ??
                                                            S
                                                                .of(context)
                                                                .repairSubmitFailed);
                                                      }
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    });
                                                  }
                                                },
                                                child:
                                                    Text(S.of(context).submit),
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
              });
        },
      ),
    );
  }

  // 删除bar
  Widget _buildRemoveBar() {
    return DragTarget<AssetEntity>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 54.px,
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
                S.of(context).dragHereToRemove,
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
                      await HJBottomSheet.wxPicker(context, selectedAssets, 6);
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
                    size: 22.px,
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
            style:
                TextStyle(fontSize: 14.px, color: Colors.black, height: 3.px),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(fontSize: 12.px),
            decoration: InputDecoration(
              hintText: S.of(context).inputMessage(label),
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              isCollapsed: true,
              // 设置输入时的文字大小
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.px),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 8.px, vertical: 8.px),
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
      height: 32.px,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 64.px, right: 64.px, top: 18.px),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(16.px)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
            fontSize: 14.px,
            color: textColor,
          )),
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
        ),
      ),
    );
  }
}

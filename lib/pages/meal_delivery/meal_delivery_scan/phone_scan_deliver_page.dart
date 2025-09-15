import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/meal_delivery_utils.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/pages/repair/submit_page/repair_form_page.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PhoneScanDeliverPage extends StatefulWidget {
  PhoneScanDeliverPage(this.foodTypeList);
  final List<DictModel> foodTypeList;

  @override
  _PhoneScanDeliverPageState createState() => _PhoneScanDeliverPageState();
}

class _PhoneScanDeliverPageState extends State<PhoneScanDeliverPage> {
  MobileScannerController? controller;
  bool isProcessing = false; // 防止重复调用接口
  DictModel? _selectedFoodNameValue; // 餐次
  String _selectedFoodTypeValue = ''; // 餐种
  List<AssetEntity> selectedAssets = [];
  String languageCode = 'zh';

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    ); // 初始化 controller
    getLanguageCode();
    setState(() {
      _selectedFoodNameValue = widget.foodTypeList.first;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void showToastByCode(BuildContext context, String msg) {
    // 创建 code 和对应翻译文案的映射表
    final Map<String, String> translations = {
      'OrderNotFound': S.of(context).orderNotFound,
      'LeaderStatusError': S.of(context).orderRejected,
      'OrderStatusError': S.of(context).orderNotConfirmed,
      'DuplicateOrderReception': S.of(context).duplicateOrderReception,
      'PermissionDenied': S.of(context).permissionDenied,
      'FoodNameChooseError': S.of(context).foodNameChooseError,
      'PackageTypeError': S.of(context).packageTypeError,
    };

    // 根据 code 获取对应的翻译文案，找不到时使用默认文案
    String localizedMessage = translations[msg] ?? '';

    // 显示 Toast
    ProgressHUD.showError(localizedMessage);
  }

  Future<void> _launchURL(String value) async {
    // Check if the value starts with "tel:" (for phone numbers)
    final Uri url = Uri.parse('tel:$value');
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getLanguageCode() async {
    String language = await SpUtils.getString('locale') ?? 'zh';
    setState(() {
      languageCode = language;
    });
  }

  // 显示订单信息弹窗
  void showOrderInfo(BuildContext context, MealDeliveryOrderModel data) {
    final foodType = {
      '0': S.of(context).chineseFood,
      '1': S.of(context).indonesianFood,
    };
    Map<String, dynamic> msg = {
      S.of(context).delivery_site: data.deliverySite?.toString() ?? '',
      S.of(context).total: data.pNum?.toString() ?? '',
      S.of(context).orderPlacedBy: data.createBy?.toString() ?? '',
      S.of(context).phone: data.phone?.toString() ?? '',
      S.of(context).mealTime:
          languageCode == 'zh'
              ? widget.foodTypeList
                  .firstWhere((element) => element.dictValue == data.foodName)
                  .dictLabel
              : languageCode == 'id'
              ? widget.foodTypeList
                  .firstWhere((element) => element.dictValue == data.foodName)
                  .dictLabelId
              : widget.foodTypeList
                  .firstWhere((element) => element.dictValue == data.foodName)
                  .dictLabelEn,
      S.of(context).mealType: foodType[data.foodType],
    };
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            data.deptName ?? '',
            style: TextStyle(fontSize: 14.px, fontWeight: FontWeight.bold),
          ),
          titlePadding: EdgeInsets.only(top: 10.px, left: 10.px, right: 10.px),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                msg.entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      if (entry.key == 'phone') {
                        _launchURL(entry.value);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.px),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: TextStyle(
                          fontSize: 12.px,
                          color:
                              entry.key == 'phone' ? Colors.blue : Colors.black,
                          decoration:
                              entry.key == 'phone'
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isProcessing = false; // 防止重复调用
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                maximumSize: Size(40.px, 30.px),
                minimumSize: Size(40.px, 30.px),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.px),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                S.of(context).confirm,
                style: TextStyle(fontSize: 12.px),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitBarcode(String barcode) async {
    // 设置接口地址和请求参数
    print('发起请求: $barcode');
    MealDeliveryUtils.getOrderMealDetailQuery(
      barcode,
      success: (data) {
        if (data['code'] == 200 && data['msg'] == 'Success') {
          // _uploadImage(orderNo: orderNo);
          MealDeliveryOrderModel orderDetail = MealDeliveryOrderModel.fromJson(
            data['data'],
          );
          if (orderDetail.orderStatus == '3') {
            _uploadImage(orderNo: orderDetail.orderNo);
          } else if (orderDetail.orderStatus == '4') {
            showOrderInfo(context, orderDetail);
            ProgressHUD.showError(S.of(context).deliveryDelivered);
          }
        }
      },
      fail: (code, msg) {
        print('订单详情获取失败: $code $msg');
      },
    );
  }

  // 上传图片
  Future<void> _uploadImage({orderNo}) async {
    print('orderNo: $orderNo');
    final result = await HJBottomSheet.wxPicker(context, selectedAssets, 1);
    if (result != null) {
      ProgressHUD.showLoadingText(S.of(context).imageUploading);
      try {
        final fileUrl = await uploadImages(result);
        ProgressHUD.hide();
        if (fileUrl.isNotEmpty) {
          final parameters = {'orderNo': orderNo, 'imageUrl': fileUrl[0]};
          // 完成订单
          MealDeliveryUtils.updateOrderMealStatusByOrderNo(
            parameters,
            success: (data) {
              ProgressHUD.showSuccess(S.of(context).deliverySuccess);
              setState(() {
                isProcessing = false; // 防止重复调用
              });
            },
            fail: (code, msg) {
              ProgressHUD.showError(S.of(context).deliveryFail + ': $msg');
              setState(() {
                isProcessing = false; // 防止重复调用
              });
            },
          );
        }
      } catch (e) {
        ProgressHUD.showError(S.of(context).deliveryUploadFailed + ': $e');
      }
    } else {
      setState(() {
        isProcessing = false; // 防止重复调用
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 餐种选项列表
    List<Map<String, dynamic>> _foodTypeOptions = [
      {'label': S.of(context).all, 'value': ''},
      {'label': S.of(context).chineseFood, 'value': "0"},
      {'label': S.of(context).indonesianFood, 'value': "1"},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).deliveryDeliver,
          style: TextStyle(fontSize: 16.px),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flip_camera_ios),
            onPressed: () {
              controller?.switchCamera(); // 切换前后摄像头
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 扫描器
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) {
              Future.delayed(Duration(milliseconds: 100)).then((ignore) {
                final barcode = capture.barcodes.first; // 获取第一个条形码
                print('扫描到的条形码: ${barcode.rawValue}');
                print('isProcessing: $isProcessing');
                if (barcode.rawValue != null && !isProcessing) {
                  controller?.stop();
                  _submitBarcode(barcode.rawValue!)
                      .whenComplete(() {
                        controller?.start();
                      })
                      .then((_) {
                        setState(() {
                          isProcessing = false; // 防止重复调用
                        });
                      }); // 调用接口
                }
              });
            },
          ),
          // 顶部居中的按钮组
          Positioned(
            top: 10.px, // 距离顶部的距离
            left: 10.px,
            right: 10.px,
            child: Column(
              children: [
                Container(
                  height: 40.px,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.px),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.px), // 添加左右边距
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 标签
                      Text(
                        S.of(context).mealTime,
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20.px), // 标签与下拉框之间的间距
                      // 下拉选择框
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<DictModel>(
                            value: _selectedFoodNameValue,
                            isExpanded: true,
                            items:
                                widget.foodTypeList.map((option) {
                                  return DropdownMenuItem<DictModel>(
                                    value: option,
                                    child: Text(
                                      languageCode == 'zh'
                                          ? option.dictLabel ?? ''
                                          : languageCode == 'id'
                                          ? option.dictLabelId ?? ''
                                          : option.dictLabelEn ?? '',
                                      style: TextStyle(fontSize: 12.px),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (DictModel? newValue) {
                              setState(() {
                                _selectedFoodNameValue =
                                    newValue ??
                                    DictModel(
                                      dictLabel: S.of(context).all,
                                      dictValue: '',
                                    );
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.px),
                Container(
                  height: 40.px,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.px),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.px), // 添加左右边距
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 标签
                      Text(
                        S.of(context).mealType,
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20.px), // 标签与下拉框之间的间距
                      // 下拉选择框
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFoodTypeValue,
                            isExpanded: true,
                            items:
                                _foodTypeOptions.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option['value'] as String,
                                    child: Text(
                                      option['label'] as String,
                                      style: TextStyle(fontSize: 12.px),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedFoodTypeValue = newValue ?? '';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.px),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 扫描框
                      Container(
                        width: 300.px,
                        height: 300.px,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      SizedBox(height: 10.px),
                      Center(
                        child: Text(
                          S.of(context).pleaseScanTheBarcode,
                          style: TextStyle(
                            fontSize: 14.px,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.px),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

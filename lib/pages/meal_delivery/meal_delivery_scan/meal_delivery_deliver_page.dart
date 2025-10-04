import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/meal_delivery_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_scan/meal_location_service_model.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_scan/meal_location_manager.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_scan/phone_scan_deliver_page.dart';
import 'package:logistics_app/pages/mine_page/bind_account_page/bind_account_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/mdc_update_image.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MealDeliveryDeliverPage extends StatefulWidget {
  @override
  _MealDeliveryDeliverPageState createState() =>
      _MealDeliveryDeliverPageState();
}

class _MealDeliveryDeliverPageState extends State<MealDeliveryDeliverPage> {
  String _scanResult = ""; // 用于存储扫描结果
  static const platform = MethodChannel('com.iwip.intplatform');
  String languageCode = 'zh';
  bool _isProcessing = false;
  DictModel? _selectedFoodNameValue; // 餐次
  String _selectedFoodTypeValue = ''; // 餐种
  List<DictModel> foodTypeList = [];
  List<AssetEntity> selectedAssets = [];
  UserInfoModel? userInfo;
  bool isBindAccount = false;
  bool isCanScan = false;
  bool isTracking = false;
  MealLocationServiceModel? locationService;
  final MealLocationManager _locationManager = MealLocationManager();

  @override
  void initState() {
    super.initState();
    _onFetchUserInfo();
    _initializeLocationManager();
  }

  // 初始化定位管理器
  Future<void> _initializeLocationManager() async {
    await _locationManager.initialize();
    _locationManager.addListener(_onLocationStateChanged);
    _updateTrackingState();
  }

  // 定位状态变化回调
  void _onLocationStateChanged() {
    _updateTrackingState();
  }

  // 更新追踪状态
  void _updateTrackingState() {
    setState(() {
      isTracking = _locationManager.isTracking;
      locationService = _locationManager.locationService;
    });
  }

  @override
  void dispose() {
    // 移除监听器
    _locationManager.removeListener(_onLocationStateChanged);
    // 确保释放资源
    super.dispose();
    if (Platform.isAndroid) {
      platform.setMethodCallHandler(null);
    }
  }

  void _onFetchUserInfo() async {
    final userInfoData = await SpUtils.getModel('userInfo');
    String language = await SpUtils.getString('locale') ?? 'zh';
    setState(() {
      languageCode = language;
    });
    if (userInfoData != null) {
      getFoodType();
      if (Platform.isAndroid) {
        platform.setMethodCallHandler((call) async {
          if (call.method == "onScanResult") {
            setState(() {
              _processHoneywellScan(call.arguments);
            });
          }
        });
      }
      setState(() {
        userInfo = UserInfoModel.fromJson(userInfoData);
        isBindAccount = userInfo?.mealUser != null;
        if (isBindAccount) {
          isCanScan =
              userInfo?.mealUser?.roles?.any(
                (role) => role.toLowerCase().contains("driver"),
              ) ??
              false;
        }
      });
    }
  }

  // 处理Honeywell手持机扫码结果
  Future<void> _processHoneywellScan(String barcode) async {
    try {
      ProgressHUD.showText(S.of(context).processingScanResult + ': $barcode');
      print('Honeywell扫码结果: $barcode');
      // 调用接口处理条形码
      await _submitBarcode(barcode);
    } catch (e) {
      ProgressHUD.showText(S.of(context).processingScanResultError + ': $e');
      print('处理异常: $e');
    }
  }

  // 获取餐饮名称数据字典
  Future<void> getFoodType() async {
    DataUtils.getDictDataList(
      'food_type',
      success: (data) {
        final result =
            BaseListModel<DictModel>.fromJson(
              data,
              (json) => DictModel.fromJson(json),
            ).data ??
            [];
        setState(() {
          foodTypeList = [
            DictModel(
              dictLabel: S.current.all,
              dictLabelEn: S.current.all,
              dictLabelId: S.current.all,
              dictValue: '',
            ),
            ...result,
          ];
          _selectedFoodNameValue = foodTypeList.first;
        });
      },
    );
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
      S.of(context).foodType:
          foodTypeList
              .firstWhere((element) => element.dictValue == data.foodName)
              .dictLabel,
      S.of(context).mealTime: foodType[data.foodType],
    };
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            data.deptName ?? '',
            style: TextStyle(fontSize: 14.px, fontWeight: FontWeight.bold),
          ),
          titlePadding: EdgeInsets.symmetric(vertical: 5.px, horizontal: 5.px),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                msg.entries.map((entry) {
                  return GestureDetector(
                    onTap: () {
                      if (entry.key == S.of(context).phone) {
                        _launchURL(entry.value);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.px),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: TextStyle(
                          fontSize: 14.px,
                          color:
                              entry.key == S.of(context).phone
                                  ? primaryColor
                                  : Colors.black,
                          decoration:
                              entry.key == S.of(context).phone
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

  // 根据错误码显示提示
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

  // 打开电话链接
  Future<void> _launchURL(String value) async {
    final Uri url = Uri.parse('tel:$value');
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _submitBarcode(String barcode) async {
    // 设置接口地址和请求参数
    print('发起请求111: $barcode');
    // 获取订单详情
    _getOrderMealDetailByOrderNo(barcode);
  }

  // 根据订单编号获取订单详情
  Future<void> _getOrderMealDetailByOrderNo(String orderNo) async {
    MealDeliveryUtils.getOrderMealDetailQuery(
      orderNo,
      success: (data) {
        if (data['code'] == 200 && data['msg'] == 'Success') {
          // _uploadImage(orderNo: orderNo);
          MealDeliveryOrderModel orderDetail = MealDeliveryOrderModel.fromJson(
            data['data'],
          );
          if (orderDetail.orderStatus == '3') {
            _uploadImage(orderNo: orderNo);
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
    final result = await HJBottomSheet.wxPicker(context, selectedAssets, 1);
    if (result != null) {
      ProgressHUD.showLoadingText(S.of(context).deliveryUploading);
      try {
        final fileUrl = await uploadMealDeliveryFile(result);
        ProgressHUD.hide();
        if (fileUrl.isNotEmpty) {
          final parameters = {'orderNo': orderNo, 'imageUrl': fileUrl[0]};
          // 完成订单
          MealDeliveryUtils.updateOrderMealStatusByOrderNo(
            parameters,
            success: (data) {
              ProgressHUD.showSuccess(S.of(context).deliverySuccess);
            },
            fail: (code, msg) {
              ProgressHUD.showError(S.of(context).deliveryFail + ': $msg');
            },
          );
        }
      } catch (e) {
        ProgressHUD.showError(S.of(context).deliveryUploadFailed + ': $e');
      }
    }
  }

  // 处理位置事件
  void _handleLocationEvent() async {
    if (isTracking) {
      // 停止追踪
      await _locationManager.stopTracking();
      ProgressHUD.showSuccess('定位追踪已停止');
    } else {
      if (_selectedFoodNameValue?.dictValue == '') {
        ProgressHUD.showError('请选择餐次');
        return;
      }

      final foodName = _selectedFoodNameValue?.dictValue ?? '';
      // 开始追踪
      final success = await _locationManager.startTracking(foodName);
      if (success) {
        ProgressHUD.showSuccess('定位追踪已启动');
      } else {
        ProgressHUD.showError('启动定位追踪失败');
      }
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
          // 手机摄像头扫码，相机图标
          if (isCanScan)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhoneScanDeliverPage(foodTypeList),
                  ),
                );
              },
              icon: Icon(Icons.camera_alt, size: 24.px),
            ),
          SizedBox(width: 10.px),
        ],
      ),

      // 浮动按钮，根据配送状态显示
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isTracking ? secondaryColor : primaryColor,
        onPressed: () => _handleLocationEvent(),
        icon: Icon(
          isTracking ? Icons.location_on : Icons.location_off,
          color: Colors.white,
        ),
        label: Text(
          isTracking ? S.current.stopLocation : S.current.startLocation,
          style: TextStyle(color: Colors.white),
        ),
        extendedPadding: EdgeInsets.symmetric(
          horizontal: 10.px,
          vertical: 2.px,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        isExtended: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child:
            !isBindAccount
                ? Container(
                  padding: EdgeInsets.only(
                    left: 15.px,
                    right: 15.px,
                    top: 15.px,
                    bottom: 15.px,
                  ),
                  width: double.infinity,
                  height: 110.px,
                  margin: EdgeInsets.symmetric(
                    vertical: 50.px,
                    horizontal: 30.px,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.px),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1.px,
                    ),
                  ),
                  // 未绑定帐号权限，请先绑定帐号
                  child: Column(
                    children: [
                      Text(
                        S.of(context).deliveryOrderNotBindAccount,
                        style: TextStyle(fontSize: 14.px, color: Colors.grey),
                      ),
                      SizedBox(height: 10.px),
                      // 绑定帐号
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.px),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.px,
                              vertical: 5.px,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BindAccountPage(),
                              ),
                            ).then((result) {
                              if (result != null) {
                                _onFetchUserInfo();
                              }
                            });
                          },
                          child: Text(
                            S.of(context).deliveryBindAccount,
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : isCanScan
                ? Padding(
                  padding: EdgeInsets.all(10.px),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 扫码信息卡片
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.px),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.px),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8.px),
                                    ),
                                    child: Icon(
                                      Icons.scanner,
                                      color: Theme.of(context).primaryColor,
                                      size: 24.px,
                                    ),
                                  ),
                                  SizedBox(width: 16.px),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).scanStatus,
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4.px),
                                        _isProcessing
                                            ? Row(
                                              children: [
                                                SizedBox(
                                                  width: 16.px,
                                                  height: 16.px,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(
                                                          Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(width: 6.px),
                                                Text(
                                                  S.of(context).processing,
                                                  style: TextStyle(
                                                    fontSize: 10.px,
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                  ),
                                                ),
                                              ],
                                            )
                                            : (_scanResult.isNotEmpty
                                                ? Text(
                                                  S
                                                          .of(context)
                                                          .recentlyScanned +
                                                      ': $_scanResult',
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 10.px,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                                : Text(
                                                  S.of(context).waitingForScan,
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.grey,
                                                    fontSize: 10.px,
                                                  ),
                                                )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 15.px),

                      // 扫码设置
                      Text(
                        S.of(context).scanSettings,
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.px),

                      // 餐次选择卡片
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.px),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).mealTime,
                                style: TextStyle(
                                  fontSize: 12.px,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.px),
                              Container(
                                height: 40.px,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.px,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.px),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<DictModel>(
                                    value: _selectedFoodNameValue,
                                    isExpanded: true,
                                    items:
                                        foodTypeList.map((option) {
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
                      ),

                      SizedBox(height: 10.px),

                      // 餐种选择卡片
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.px),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).foodType,
                                style: TextStyle(
                                  fontSize: 12.px,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.px),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.px,
                                ),
                                height: 40.px,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.px),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
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
                      ),

                      SizedBox(height: 15.px),
                      // 使用说明
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.px),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: primaryColor,
                                    size: 20.px,
                                  ),
                                  SizedBox(width: 6.px),
                                  Text(
                                    S.of(context).usageInstructions,
                                    style: TextStyle(
                                      fontSize: 12.px,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.px),
                              Text(
                                S.of(context).selectMealTimeAndFoodType,
                                style: TextStyle(fontSize: 10.px),
                              ),
                              SizedBox(height: 4.px),
                              Text(
                                S.of(context).useHandheldScannerToScanBarcode,
                                style: TextStyle(fontSize: 10.px),
                              ),
                              SizedBox(height: 4.px),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : Container(
                  padding: EdgeInsets.only(
                    left: 15.px,
                    right: 15.px,
                    top: 15.px,
                    bottom: 15.px,
                  ),
                  width: double.infinity,
                  height: 110.px,
                  margin: EdgeInsets.symmetric(
                    vertical: 50.px,
                    horizontal: 30.px,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.px),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1.px,
                    ),
                  ),
                  // 未绑定帐号权限，请先绑定帐号
                  child: Center(
                    child: Text(
                      S.of(context).deliveryOrderNoPermission,
                      style: TextStyle(fontSize: 14.px, color: Colors.grey),
                    ),
                  ),
                ),
      ),
    );
  }
}

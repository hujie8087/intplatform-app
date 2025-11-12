import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/meal_delivery_utils.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/mine_page/bind_account_page/bind_account_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer audioPlayer = AudioPlayer();

class MealDeliveryPhoneScanPage extends StatefulWidget {
  MealDeliveryPhoneScanPage(this.foodTypeList);
  final List<DictModel> foodTypeList;

  @override
  _MealDeliveryPhoneScanPageState createState() =>
      _MealDeliveryPhoneScanPageState();
}

class _MealDeliveryPhoneScanPageState extends State<MealDeliveryPhoneScanPage> {
  MobileScannerController? controller;
  bool isProcessing = false; // 防止重复调用接口
  DictModel? _selectedFoodNameValue; // 餐次
  String _selectedFoodTypeValue = ''; // 餐种
  UserInfoModel? userInfo;
  bool isBindAccount = false;
  bool isCanScan = false;
  String languageCode = 'zh';

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    ); // 初始化 controller
    _onFetchUserInfo();
  }

  Future<void> getLanguageCode() async {
    String language = await SpUtils.getString('locale') ?? 'zh';
    setState(() {
      languageCode = language;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onFetchUserInfo() async {
    final userInfoData = await SpUtils.getModel('userInfo');
    getLanguageCode();
    if (userInfoData != null) {
      setState(() {
        userInfo = UserInfoModel.fromJson(userInfoData);
        _selectedFoodNameValue = widget.foodTypeList.first;
        isBindAccount = userInfo?.mealUser != null;
        if (isBindAccount) {
          isCanScan =
              userInfo?.mealUser?.roles?.any(
                (role) => role.toLowerCase().contains("driver"),
              ) ??
              false;
          print('isCanScan: $isCanScan');
        }
      });
    }
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

  void showOrderInfo(BuildContext context, Map<String, dynamic> data) {
    final foodType = {
      '0': S.of(context).chineseFood,
      '1': S.of(context).indonesianFood,
    };
    Map<String, dynamic> msg = {
      S.of(context).delivery_site: data["deliverySite"]?.toString() ?? '',
      S.of(context).total: data["pNum"]?.toString() ?? '',
      S.of(context).orderPlacedBy: data["createBy"]?.toString() ?? '',
      S.of(context).phone: data["phone"]?.toString() ?? '',
      S.of(context).mealTime:
          widget.foodTypeList
              .firstWhere((element) => element.dictValue == data["foodName"])
              .dictLabel,
      S.of(context).mealType: foodType[data["foodType"]],
    };
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data["deptName"], style: TextStyle(fontSize: 14.px)),
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
              child: Text(
                S.of(context).close,
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
    MealDeliveryUtils.receiveOrderMeal(
      {
        "foodName": _selectedFoodNameValue?.dictValue ?? '',
        "foodType": _selectedFoodTypeValue,
        'orderNo': barcode,
      },
      success: (data) {
        print('接收订单成功: $data');
        if (data['code'] == 200 && data['msg'] == 'Success') {
          ProgressHUD.showSuccess(
            S.of(context).mealDeliverySuccess(data['data']),
          );
          setState(() {
            // 间隔 1 秒后恢复
            Future.delayed(Duration(seconds: 1)).then((_) {
              isProcessing = false; // 防止重复调用
            });
          });
        } else if (data['code'] == 200 && data['msg'] == 'DisplayOrderInfo') {
          if (context.mounted) {
            Map<String, dynamic> dataInfo = Map<String, dynamic>.from(
              data['data'] ?? {},
            );
            showOrderInfo(context, dataInfo);
          }
        } else {
          showToastByCode(context, data['msg']);
        }
      },
      fail: (error, msg) {
        ProgressHUD.showError(error.toString());
      },
    );
  }

  // 查询未接收订单
  Future<void> _confirmOrder() async {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth * 1;
    MealDeliveryUtils.queryUnreceivedOrders(
      {
        "foodName": _selectedFoodNameValue?.dictValue ?? '',
        "foodType": _selectedFoodTypeValue,
      },
      success: (data) {
        if (data['code'] == 200 && data['msg'] == 'Success') {
          final List<Map<String, dynamic>> dataList =
              List<Map<String, dynamic>>.from(data['data'] ?? []);
          if (dataList.isEmpty) {
            ProgressHUD.showSuccess('订单已全部装车');
            return;
          }
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return UnconstrainedBox(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: dialogWidth),
                    child: AlertDialog(
                      // 设置最大宽度
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.px),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.px,
                        vertical: 12.px,
                      ),
                      titlePadding: EdgeInsets.symmetric(
                        horizontal: 16.px,
                        vertical: 12.px,
                      ),
                      title: Text(
                        '未取订单',
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Container(
                        width: double.maxFinite,
                        constraints: BoxConstraints(
                          maxHeight: 300.px, // 设置最大高度
                          maxWidth: 600.px, // 设置最大宽度
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // 添加表头
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          '配送站点',
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 5,
                                      child: Center(
                                        child: Text(
                                          '订餐人',
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          '总数',
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          '未收',
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(), // 在表头下添加分割线
                              // 动态数据行
                              ...dataList.map((data) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 0,
                                      ),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Center(
                                                child: Text(
                                                  data['deliverySite']
                                                          ?.toString() ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 12.px,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 5,
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Center(
                                                child: Text(
                                                  data['createBy']
                                                          ?.toString() ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 12.px,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Center(
                                                child: Text(
                                                  data['pNum']?.toString() ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 12.px,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Center(
                                                child: Text(
                                                  data['unreceivedNum']
                                                          ?.toString() ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 12.px,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(), // 每行下方添加分割线
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // 关闭弹窗
                          },

                          style: ElevatedButton.styleFrom(
                            maximumSize: Size(40.px, 30.px),
                            minimumSize: Size(40.px, 30.px),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.px),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text('确认', style: TextStyle(fontSize: 12.px)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      },
      fail: (error, msg) {
        ProgressHUD.showError('${error.toString()} $msg');
      },
    );
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
          S.of(context).mealDeliveryAccept,
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
      body:
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
              ? Stack(
                children: [
                  // 扫描器
                  MobileScanner(
                    controller: controller,
                    onDetect: (BarcodeCapture capture) {
                      Future.delayed(Duration(milliseconds: 100)).then((
                        ignore,
                      ) async {
                        final barcode = capture.barcodes.first; // 获取第一个条形码
                        print('扫描到的条形码: ${barcode.rawValue}');
                        print('isProcessing: $isProcessing');
                        // 播放提示音
                        await audioPlayer.play(AssetSource('qrcode.mp3'));
                        if (barcode.rawValue != null && !isProcessing) {
                          controller?.stop();
                          setState(() {
                            isProcessing = true; // 防止重复调用
                          });
                          _submitBarcode(barcode.rawValue!).whenComplete(() {
                            controller?.start();
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.px,
                          ), // 添加左右边距
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.px,
                          ), // 添加左右边距
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
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
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
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _confirmOrder();
                                  },
                                  child: Text(
                                    S.of(context).confirm,
                                    style: TextStyle(fontSize: 14.px),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    );
  }
}

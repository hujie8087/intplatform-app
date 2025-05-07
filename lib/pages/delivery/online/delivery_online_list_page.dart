import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/delivery_order_detail_model.dart';
import 'package:logistics_app/http/model/delivery_order_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/delivery/order/delivery_order_detail_page.dart';
import 'package:logistics_app/pages/repair/submit_page/repair_form_page.dart';
import 'package:logistics_app/pages/shopping/payment/qr_scanner_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/date_utils.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'location_service_model.dart';

class DeliveryOnlineListPage extends StatefulWidget {
  const DeliveryOnlineListPage({Key? key}) : super(key: key);

  @override
  State<DeliveryOnlineListPage> createState() => _DeliveryOnlineListPageState();
}

class _DeliveryOnlineListPageState extends State<DeliveryOnlineListPage> {
  LocationServiceModel? locationService;
  // 订单列表数据
  List<DeliveryOrderModel> _orders = [];
  bool _isLoading = false;
  List<DictModel> statusList = [];
  int currentIndex = 0;
  int status = 0;
  // 选择的图片
  List<AssetEntity> selectedAssets = [];
  String fileUrl = '';

  String userName = '';
  int pageNum = 1;
  int total = 0;
  bool isTracking = false;
  late RefreshController _refreshController;
  UserInfoModel? userInfo;
  static const platform = MethodChannel('com.iwip.intplatform');
  // 状态选项
  final List<SwitchType> statusOptions = [
    SwitchType(S.current.toBeDelivered, 0),
    SwitchType(S.current.delivering, 1),
    SwitchType(S.current.delivered, 2),
    SwitchType(S.current.exception, 5),
  ];
  // 时间选择选项，默认是今天
  int _selectedDate = 0;
  // 时间选择选项，今天，一周，一个月，三个月，一年
  List<Map<String, String>> _timeOptions = [
    {
      'title': S.current.today,
      'startTime': DateTime.now().startOfDay,
      'endTime': DateTime.now().endOfDay,
    },
    {
      'title': S.current.oneWeek,
      'startTime': DateTime.now().startOfWeek,
      'endTime': DateTime.now().endOfWeek,
    },
    {
      'title': S.current.oneMonth,
      'startTime': DateTime.now().startOfMonth,
      'endTime': DateTime.now().endOfMonth,
    },
    {
      'title': S.current.threeMonths,
      'startTime': DateTime.now().startOfQuarter,
      'endTime': DateTime.now().endOfQuarter,
    },
    {
      'title': S.current.oneYear,
      'startTime': DateTime.now().startOfYear,
      'endTime': DateTime.now().endOfYear,
    },
  ];
  String _orderName = '';
  String _orderNo = '';

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
    _fetchOrderStatus();
    if (Platform.isAndroid) {
      platform.setMethodCallHandler((call) async {
        print(call.method);
        if (call.method == "onScanResult") {
          setState(() {
            _acceptOrder(call.arguments);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // 获取订单详情
  Future<void> getOrderDetail(String sourceNo) async {
    DataUtils.getDeliveryOrderDetail(
      {'orderNo': sourceNo},
      success: (data) {
        DeliveryOrderDetailModel _orderDetail =
            DeliveryOrderDetailModel.fromJson(data['data']);
        setState(() {
          if (_orderDetail.orderDelivery?.deliveryStatus == 0 ||
              _orderDetail.orderDelivery?.deliveryStatus == 99) {
            _acceptOrder(sourceNo);
          } else if (_orderDetail.orderDelivery?.deliveryStatus == 1) {
            _uploadImage(
              id: _orderDetail.orderDelivery?.id,
              deliveryAddress: _orderDetail.orderDelivery?.deliveryAddress,
              nick: _orderDetail.orderDelivery?.nick,
            );
          }
        });
      },
      fail: (error, message) {
        ProgressHUD.showError(message);
      },
    );
  }

  // 加载订单数据
  Future<void> _loadOrders(bool isRefresh) async {
    _isLoading = true;
    if (isRefresh) {
      pageNum = 1;
      _orders = [];
    }

    DataUtils.getMyOrderList(
      {
        'pageNum': pageNum,
        'pageSize': 10,
        'deliveryStatus': status,
        'deliveryName': _orderName,
        'orderNo': _orderNo,
        'beginTime': _timeOptions[_selectedDate]['startTime'],
        'endTime': _timeOptions[_selectedDate]['endTime'],
      },
      success: (data) {
        var rowsModel = RowsModel<DeliveryOrderModel>.fromJson(
          data,
          (json) => DeliveryOrderModel.fromJson(json),
        );

        if (rowsModel.rows != null) {
          setState(() {
            if (isRefresh) {
              _orders = rowsModel.rows ?? [];
            } else {
              _orders = [..._orders, ...rowsModel.rows ?? []];
            }
            total = rowsModel.total ?? 0;
          });
        }

        setState(() {
          if (_orders.length >= total) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
          _refreshController.refreshCompleted();
          _isLoading = false;
          if (_orders.isNotEmpty) {
            locationService = LocationServiceModel(
              deliveryNo: _orders[0].deliveryNo ?? '',
            );
          }
        });
      },
    );
  }

  // 接单处理
  Future<void> _acceptOrder(String sourceNo) async {
    try {
      // TODO: 调用接单API
      DataUtils.acceptOrder(
        {'sourceNo': sourceNo},
        success: (data) {
          ProgressHUD.showSuccess(S.current.acceptOrderSuccess);
          _loadOrders(true); // 重新加载订单列表
        },
      );
    } catch (e) {
      ProgressHUD.showError(S.current.acceptOrderFailed + ':' + e.toString());
      _loadOrders(true); // 重新加载订单列表
    }
  }

  // 获取订单类型
  Future<void> _fetchOrderStatus() async {
    var userInfo = await SpUtils.getModel('userInfo');
    userName = userInfo != null ? userInfo['user']['userName'] : '';
    DataUtils.getDictDataList(
      'delivery_staff_type',
      success: (data) {
        statusList =
            BaseListModel<DictModel>.fromJson(
              data,
              (json) => DictModel.fromJson(json),
            ).data ??
            [];
        setState(() {
          _loadOrders(true);
        });
      },
    );
    isTracking = await SpUtils.getBool('isTracking') ?? false;
  }

  // 扫码按钮点击事件
  Future<void> _scanCode() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (status.isDenied) {
        print("相机权限被拒绝");
      } else if (status.isPermanentlyDenied) {
        print("相机权限被永久拒绝，请前往设置开启");
        openAppSettings(); // 引导用户去手动开启权限
      }
    } else {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QRScannerPage()),
      );

      if (result != null) {
        // 处理扫码结果
        getOrderDetail(result);
      }
    }
  }

  // 处理定位事件
  void _handleLocationEvent() {
    if (isTracking) {
      // if (_orders.isNotEmpty) {
      //   ProgressHUD.showError('请先完成所有订单或取消订单');
      //   return;
      // }
      locationService?.stopTracking();
      SpUtils.saveBool('isTracking', false);
      isTracking = false;
    } else {
      if (_orders.isEmpty) {
        ProgressHUD.showError(S.current.pleaseAcceptOrder);
        return;
      }
      locationService?.startTracking();
      SpUtils.saveBool('isTracking', true);
      isTracking = true;
    }
    setState(() {});
  }

  // 上传图片
  Future<void> _uploadImage({id, deliveryAddress, nick}) async {
    final result = await HJBottomSheet.wxPicker(context, selectedAssets, 1);
    if (result != null) {
      final fileUrl = await uploadImages(result);
      if (fileUrl.isNotEmpty) {
        final parameters = {'id': id.toString(), 'msg': fileUrl[0]};
        DataUtils.deliverOrder(
          parameters,
          success: (data) {
            ProgressHUD.showSuccess(S.current.deliverSuccess);
            DataUtils.getUserInfoByUsername(
              nick,
              success: (data) {
                if (data['msg'] != null) {
                  DataUtils.sendOneMessage(
                    {
                      'title': S.current.deliverSuccessTips,
                      'body': deliveryAddress,
                      'type': "1",
                      'payload': '',
                      'userName': nick,
                      'equipmentToken': data['msg'],
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
              },
            );
            _loadOrders(true);
          },
          fail: (code, msg) {
            ProgressHUD.showError(S.current.deliverFailed);
          },
        );
      }
    }
  }

  // 筛选
  Future<void> _filter() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filter',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        int _tempSelectedDate = _selectedDate; // 临时保存
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
            Container(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 400,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 8),
                    ],
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        S.current.selectByTime,
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 14.px),
                      // ⭐ 这里用 StatefulBuilder
                      StatefulBuilder(
                        builder: (context, innerSetState) {
                          return Row(
                            children:
                                _timeOptions.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Map<String, String> option = entry.value;
                                  bool isSelected = _tempSelectedDate == index;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            isSelected
                                                ? primaryColor
                                                : Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          side: BorderSide(
                                            color:
                                                isSelected
                                                    ? primaryColor
                                                    : Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        innerSetState(() {
                                          _tempSelectedDate = index;
                                        });
                                      },
                                      child: Text(
                                        option['title'] ?? '',
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),
                      SizedBox(height: 16.px),
                      Row(
                        children: [
                          // 订单编号
                          Text(
                            S.current.orderNo,
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 12.px),
                          Expanded(
                            child:
                            // 订单编号输入框
                            TextField(
                              textAlign: TextAlign.right,
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                hintText: S.current.inputOrderNo,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontSize: 12.px,
                                color: primaryColor,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _orderNo = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // 订单姓名
                          Text(
                            S.current.orderName,
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 12.px),
                          Expanded(
                            child:
                            // 订单姓名输入框
                            TextField(
                              textAlign: TextAlign.right,
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                hintText: S.current.inputOrderName,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontSize: 12.px,
                                color: primaryColor,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _orderName = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      // 底部确认按钮
                      Row(
                        children: [
                          // 取消
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(S.current.cancel),
                            ),
                          ),
                          SizedBox(width: 10),
                          // 确定
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedDate = _tempSelectedDate; // 保存选中的
                                  _loadOrders(true);
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text(S.current.confirm),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -0.1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.onlineDelivery,
          style: TextStyle(fontSize: 16.px),
        ),
        actions: [
          // 筛选,带图标和文字
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _filter(),
          ),
          // 扫码
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () => _scanCode(),
          ),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          Column(
            children: [
              // 状态筛选栏
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.px),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      statusOptions.asMap().entries.map((entry) {
                        int index = entry.key;
                        SwitchType item = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                              status = item.value;
                              _loadOrders(true);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.px,
                              vertical: 6.px,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  currentIndex == index
                                      ? primaryColor.withOpacity(0.1)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(20.px),
                            ),
                            child: Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 14.px,
                                color:
                                    currentIndex == index
                                        ? primaryColor
                                        : Colors.grey[600],
                                fontWeight:
                                    currentIndex == index
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _orders.isEmpty
                        ? EmptyView(text: S.current.noOrder)
                        : SmartRefreshWidget(
                          controller: _refreshController,
                          enablePullDown: true,
                          enablePullUp: true,
                          onRefresh: () async {
                            await _loadOrders(true);
                          },
                          onLoading: () async {
                            await _loadOrders(false);
                          },
                          child: ListView.builder(
                            itemCount: _orders.length,
                            itemBuilder: (context, index) {
                              return OrderCard(
                                order: _orders[index],
                                onAccept:
                                    () => _uploadImage(
                                      id: _orders[index].id,
                                      deliveryAddress:
                                          _orders[index].deliveryAddress,
                                      nick: _orders[index].nick,
                                    ),
                                refresh: () => _loadOrders(true),
                                statusList: statusList,
                                acceptOrder:
                                    () => _acceptOrder(
                                      _orders[index].sourceNo.toString(),
                                    ),
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 订单卡片组件
class OrderCard extends StatelessWidget {
  final DeliveryOrderModel order;
  final VoidCallback onAccept;
  final VoidCallback refresh;
  final VoidCallback acceptOrder;
  final List<DictModel> statusList;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onAccept,
    required this.statusList,
    required this.refresh,
    required this.acceptOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dictLabel =
        statusList.isNotEmpty
            ? statusList
                    .firstWhere(
                      (element) =>
                          element.dictValue == order.orderType.toString(),
                      orElse: () => DictModel(),
                    )
                    .dictLabel ??
                ''
            : '';
    return Card(
      margin: const EdgeInsets.all(8.0),
      // 圆角
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.px)),
      shadowColor: Colors.grey,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.px,
          left: 16.px,
          right: 16.px,
          bottom: 4.px,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).orderNo + ':' + order.sourceNo),
                Text(
                  dictLabel,
                  style: TextStyle(color: primaryColor, fontSize: 12.px),
                ),
              ],
            ),
            SizedBox(height: 8.px),
            // 姓名
            Row(
              children: [
                Text(
                  S.of(context).name + ':',
                  style: TextStyle(fontSize: 12.px, color: Colors.grey[600]),
                ),
                Text(order.deliveryName),
              ],
            ),
            SizedBox(height: 4.px),
            Row(
              children: [
                Text(
                  S.of(context).phone + ':',
                  style: TextStyle(fontSize: 12.px, color: Colors.grey[600]),
                ),
                Text(order.deliveryTel),
              ],
            ),
            SizedBox(height: 4.px),
            Row(
              children: [
                Text(
                  S.of(context).deliveryAddress + ':',
                  style: TextStyle(fontSize: 12.px, color: Colors.grey[600]),
                ),
                Text(
                  order.deliveryAddress,
                  style: TextStyle(fontSize: 14.px, color: secondaryColor),
                ),
              ],
            ),
            SizedBox(height: 4.px),
            // 配送时间
            Row(
              children: [
                Text(
                  S.of(context).deliveryTime + ':',
                  style: TextStyle(fontSize: 12.px, color: Colors.grey[600]),
                ),
                Text(order.deliveryTime, style: TextStyle(fontSize: 12.px)),
              ],
            ),
            SizedBox(height: 4.px),
            // 配送异常信息
            if (order.deliveryStatus == 5)
              Row(
                children: [
                  Text(
                    S.of(context).exception + ':',
                    style: TextStyle(fontSize: 12.px, color: Colors.grey[600]),
                  ),
                  Text(
                    order.errorMsg ?? '',
                    style: TextStyle(fontSize: 12.px, color: secondaryColor),
                  ),
                ],
              ),
            SizedBox(height: 8.px),
            Divider(height: 1.px, color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.deliveryStatus == 1)
                  // 取消订单
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.px,
                        horizontal: 8.px,
                      ),
                      minimumSize: Size(42.px, 20.px),
                    ),
                    onPressed: () {
                      DataUtils.cancelOrder(
                        order.id.toString(),
                        success: (data) {
                          ProgressHUD.showSuccess(
                            S.of(context).cancelOrderSuccess,
                          );
                          refresh();
                        },
                        fail: (code, msg) {
                          ProgressHUD.showError(
                            S.of(context).cancelOrderFailed,
                          );
                        },
                      );
                    },
                    child: Text(
                      S.of(context).cancelOrder,
                      style: TextStyle(fontSize: 12.px, color: Colors.white),
                    ),
                  ),
                SizedBox(width: 10.px),
                if (order.deliveryStatus == 1)
                  // 送达
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.px,
                        horizontal: 8.px,
                      ),
                      minimumSize: Size(42.px, 20.px),
                    ),
                    onPressed: onAccept,
                    child: Text(
                      S.of(context).deliver,
                      style: TextStyle(fontSize: 12.px, color: Colors.white),
                    ),
                  ),
                if (order.deliveryStatus > 1)
                  // 查看订单
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.px,
                        horizontal: 8.px,
                      ),
                      minimumSize: Size(42.px, 20.px),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DeliveryOrderDetailPage(
                                orderNo: order.sourceNo,
                              ),
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).viewOrder,
                      style: TextStyle(fontSize: 12.px),
                    ),
                  ),
                // 接单
                if (order.deliveryStatus == 0)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.px,
                        horizontal: 8.px,
                      ),
                      minimumSize: Size(42.px, 20.px),
                    ),
                    onPressed: acceptOrder,
                    child: Text(
                      S.current.acceptOrder,
                      style: TextStyle(fontSize: 12.px),
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

// 订单数据模型
class DeliveryOrder {
  final String id;
  final double amount;
  final String pickupAddress;
  final String deliveryAddress;
  final double distance;

  DeliveryOrder({
    required this.id,
    required this.amount,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.distance,
  });
}

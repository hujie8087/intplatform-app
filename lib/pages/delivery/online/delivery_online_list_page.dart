import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';

import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/delivery_order_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/delivery/order/delivery_order_detail_page.dart';
import 'package:logistics_app/pages/repair/submit_page/repair_form_page.dart';
import 'package:logistics_app/pages/shopping/payment/qr_scanner_page.dart';
import 'package:logistics_app/utils/color.dart';
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
  int status = 1;
  // 选择的图片
  List<AssetEntity> selectedAssets = [];
  String fileUrl = '';

  String userName = '';
  int pageNum = 1;
  int total = 0;
  bool isTracking = false;
  late RefreshController _refreshController;
  UserInfoModel? userInfo;

// 状态选项
  final List<SwitchType> statusOptions = [
    SwitchType('配送中', 1),
    SwitchType('已送达', 2),
  ];

  Future<void> _getUserInfo() async {
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    }
  }

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
    _fetchOrderStatus();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // 加载订单数据
  Future<void> _loadOrders(bool isRefresh) async {
    _isLoading = true;
    if (isRefresh) {
      pageNum = 1;
      _orders = [];
    }

    DataUtils.getMyOrderList({
      'pageNum': pageNum,
      'pageSize': 10,
      'deliveryStatus': status,
    }, success: (data) {
      var rowsModel = RowsModel<DeliveryOrderModel>.fromJson(
          data, (json) => DeliveryOrderModel.fromJson(json));

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
          locationService =
              LocationServiceModel(deliveryNo: _orders[0].deliveryNo ?? '');
        }
      });
    });
  }

  // 接单处理
  Future<void> _acceptOrder(String sourceNo) async {
    try {
      // TODO: 调用接单API
      DataUtils.acceptOrder({
        'sourceNo': sourceNo,
      }, success: (data) {
        ProgressHUD.showSuccess('接单成功');
        _loadOrders(true); // 重新加载订单列表
      });
    } catch (e) {
      ProgressHUD.showError('接单失败${e.toString()}');
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
        statusList = BaseListModel<DictModel>.fromJson(
                data, (json) => DictModel.fromJson(json)).data ??
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
    if (status.isGranted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRScannerPage(),
        ),
      );

      if (result != null) {
        // 处理扫码结果
        _acceptOrder(result);
      }
    } else if (status.isDenied) {
      // 检查相机权限
      var requestStatus = await Permission.camera.request();
      if (requestStatus.isGranted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerPage(),
          ),
        );

        if (result != null) {
          // 处理扫码结果
          _acceptOrder(result);
        } else {
          ProgressHUD.showError(S.current.needCameraPermission);
        }
      }
    } else if (status.isPermanentlyDenied) {
      ProgressHUD.showError('相机权限被永久拒绝，打开设置页面');
      openAppSettings();
    } else {
      ProgressHUD.showError(S.current.needCameraPermission);
      return;
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
        ProgressHUD.showError('请先接单');
        return;
      }
      locationService?.startTracking();
      SpUtils.saveBool('isTracking', true);
      isTracking = true;
    }
    setState(() {});
  }

  // 上传图片
  Future<void> _uploadImage() async {
    final result = await HJBottomSheet.wxPicker(context, selectedAssets, 1);
    if (result != null) {
      final fileUrl = await uploadImages(result);
      if (fileUrl.isNotEmpty) {
        final parameters = {
          'id': _orders[0].id.toString(),
          'msg': fileUrl[0],
        };
        var deliveryAddress = _orders[0].deliveryAddress;
        var nick = _orders[0].nick;
        DataUtils.deliverOrder(
          parameters,
          success: (data) {
            ProgressHUD.showSuccess('送达成功');
            DataUtils.getUserInfoByUsername(_orders[0].nick, success: (data) {
              if (data['msg'] != null) {
                DataUtils.sendOneMessage(
                  {
                    'title': '您的订单已送达',
                    'body': deliveryAddress,
                    'type': "1",
                    'payload': '',
                    'userName': nick,
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
            _loadOrders(true);
          },
          fail: (code, msg) {
            ProgressHUD.showError('送达失败');
          },
        );
      }
    }
  }

  static InkWell _buildButton(Widget child, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 36.px,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('在线接单', style: TextStyle(fontSize: 16.px)),
          actions: [
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
          icon: Icon(isTracking ? Icons.location_on : Icons.location_off),
          label: Text(isTracking ? '停止定位' : '开始定位'),
          extendedPadding:
              EdgeInsets.symmetric(horizontal: 10.px, vertical: 2.px),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(children: [
          Column(children: [
            // 状态筛选栏
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: statusOptions.asMap().entries.map((entry) {
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
                        horizontal: 16.px,
                        vertical: 6.px,
                      ),
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.px),
                      ),
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14.px,
                          color: currentIndex == index
                              ? primaryColor
                              : Colors.grey[600],
                          fontWeight: currentIndex == index
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _orders.isEmpty
                      ? EmptyView(
                          text: '暂无订单',
                        )
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
                                onAccept: () => _uploadImage(),
                                refresh: () => _loadOrders(true),
                                statusList: statusList,
                              );
                            },
                          ),
                        ),
            )
          ]),
        ]));
  }
}

// 订单卡片组件
class OrderCard extends StatelessWidget {
  final DeliveryOrderModel order;
  final VoidCallback onAccept;
  final VoidCallback refresh;
  final List<DictModel> statusList;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onAccept,
    required this.statusList,
    required this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dictLabel = statusList.isNotEmpty
        ? statusList
                .firstWhere(
                  (element) => element.dictValue == order.orderType.toString(),
                  orElse: () => DictModel(),
                )
                .dictLabel ??
            ''
        : '';
    return Card(
      margin: const EdgeInsets.all(8.0),
      // 圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.px),
      ),
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
                Text('订单号：${order.sourceNo}'),
                Text(
                  dictLabel,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12.px,
                  ),
                )
              ],
            ),
            SizedBox(height: 8.px),
            // 姓名
            Row(
              children: [
                Text(
                  '姓名：',
                  style: TextStyle(fontSize: 12.px, color: Colors.grey[600]),
                ),
                Text(order.deliveryName),
              ],
            ),
            SizedBox(height: 4.px),
            Row(
              children: [
                Text(
                  '电话：',
                  style: TextStyle(fontSize: 12.px, color: Colors.grey[600]),
                ),
                Text(order.deliveryTel),
              ],
            ),
            SizedBox(height: 4.px),
            Row(
              children: [
                Text(
                  '送货地址：',
                  style: TextStyle(
                    fontSize: 12.px,
                    color: Colors.grey[600],
                  ),
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
                  '下单时间：',
                  style: TextStyle(
                    fontSize: 12.px,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  order.deliveryTime,
                  style: TextStyle(fontSize: 12.px),
                ),
              ],
            ),
            SizedBox(height: 8.px),
            Divider(
              height: 1.px,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.deliveryStatus == 1)
                  // 取消订单
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 4.px, horizontal: 8.px),
                      minimumSize: Size(42.px, 20.px),
                    ),
                    onPressed: () {
                      DataUtils.cancelOrder(order.id.toString(),
                          success: (data) {
                        ProgressHUD.showSuccess('取消订单成功');
                        refresh();
                      }, fail: (code, msg) {
                        ProgressHUD.showError('取消订单失败');
                      });
                    },
                    child: Text(
                      '取消订单',
                      style: TextStyle(fontSize: 12.px),
                    ),
                  ),
                SizedBox(
                  width: 10.px,
                ),
                if (order.deliveryStatus == 1)
                  // 送达
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 4.px, horizontal: 8.px),
                      minimumSize: Size(42.px, 20.px),
                    ),
                    onPressed: onAccept,
                    child: Text(
                      '送达',
                      style: TextStyle(fontSize: 12.px),
                    ),
                  ),
                if (order.deliveryStatus > 1)
                  // 查看订单
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 4.px, horizontal: 8.px),
                      minimumSize: Size(42.px, 20.px),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliveryOrderDetailPage(
                                  orderNo: order.sourceNo)));
                    },
                    child: Text(
                      '查看订单',
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

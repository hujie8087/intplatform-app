import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/delivery_order_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/pages/delivery/order/delivery_order_detail_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

// 将 DashedLinePainter 类移到外部
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 4, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DeliveryOrderListPage extends StatefulWidget {
  const DeliveryOrderListPage({Key? key}) : super(key: key);

  @override
  _DeliveryOrderListPageState createState() => _DeliveryOrderListPageState();
}

class _DeliveryOrderListPageState extends State<DeliveryOrderListPage> {
  int selectedStatus = -1;
  List<DeliveryOrderModel> orders = [];
  bool isLoading = false;
  int pageNum = 1;
  int pageSize = 10;
  int total = 0;
  String searchText = '';
  TextEditingController searchController = TextEditingController();
  List<DictModel> statusList = [];
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _fetchOrderStatus();
  }

// 获取订单类型
  Future<void> _fetchOrderStatus() async {
    DataUtils.getDictDataList(
      'delivery_staff_type',
      success: (data) {
        statusList = BaseListModel<DictModel>.fromJson(
                data, (json) => DictModel.fromJson(json)).data ??
            [];
        setState(() {
          _loadOrders(isRefresh: true);
        });
      },
    );
  }

  Future<void> _loadOrders({bool isRefresh = false}) async {
    setState(() {
      isLoading = true;
    });
    var userInfo = await SpUtils.getModel('userInfo');
    var userName = userInfo != null ? userInfo['user']['userName'] : '';
    if (isRefresh) {
      pageNum = 1;
    } else {
      pageNum = pageNum + 1;
    }
    var params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'nick': userName,
    };
    if (selectedStatus != -1) {
      params['deliveryStatus'] = selectedStatus;
    }
    if (searchText != '') {
      params['orderNo'] = searchText;
    }
    DataUtils.getPageList(APIs.getDeliveryOrderList, params, success: (data) {
      var rowsModel =
          RowsModel.fromJson(data, (json) => DeliveryOrderModel.fromJson(json));
      if (rowsModel.rows != null) {
        setState(() {
          orders = rowsModel.rows!;
          total = rowsModel.total ?? 0;
          if (isRefresh) {
            orders = rowsModel.rows!;
          } else {
            orders.addAll(rowsModel.rows!);
          }
        });
      }
      setState(() {
        if (orders.length >= total) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
        _refreshController.refreshCompleted();
        isLoading = false;
      });
    });
  }

  // 确认收货
  Future<void> _confirmDelivery(DeliveryOrderModel order) async {
    DataUtils.confirmDelivery(order.id, success: (data) {
      _loadOrders(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 搜索框
        title: Container(
          width: double.infinity,
          height: 36.px,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20.px),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    // 行高
                    isDense: true,
                    // 文字缩进
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.px),
                    hintText: '请输入订单号',
                    hintStyle: TextStyle(fontSize: 12.px),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  searchText = searchController.text;
                  _loadOrders(isRefresh: true);
                },
                icon: Icon(Icons.search, size: 20.px),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.px),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTabItem(
                      icon: Icons.list_alt,
                      text: '全部',
                      isSelected: selectedStatus == -1,
                      onTap: () {
                        _onTabSelected(-1);
                      }),
                  _buildTabItem(
                    icon: Icons.access_time,
                    text: '待接单',
                    isSelected: selectedStatus == 0,
                    onTap: () => _onTabSelected(0),
                  ),
                  _buildTabItem(
                    icon: Icons.delivery_dining,
                    text: '配送中',
                    isSelected: selectedStatus == 1,
                    onTap: () => _onTabSelected(1),
                  ),
                  _buildTabItem(
                    icon: Icons.check_circle_outline,
                    text: '已送达',
                    isSelected: selectedStatus == 2,
                    onTap: () => _onTabSelected(2),
                  ),
                  _buildTabItem(
                    icon: Icons.done_all,
                    text: '已收货',
                    isSelected: selectedStatus == 3,
                    onTap: () => _onTabSelected(3),
                  ),
                ],
              ),
              Expanded(
                child: orders.isEmpty
                    ? Center(
                        child: EmptyView(),
                      )
                    : SmartRefreshWidget(
                        controller: _refreshController,
                        enablePullDown: true,
                        enablePullUp: true,
                        onRefresh: () async {
                          await _loadOrders(isRefresh: true);
                        },
                        onLoading: () async {
                          await _loadOrders();
                        },
                        child: ListView.builder(
                          itemCount: orders.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.px, vertical: 8.px),
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryOrderDetailPage(
                                            orderNo: order.sourceNo),
                                  ),
                                );
                              },
                              child: _buildOrderCard(order),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(DeliveryOrderModel order) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12.px),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.px),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单号和状态
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.px,
                        vertical: 4.px,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.px),
                      ),
                      child: Text(
                        statusList
                                .firstWhere(
                                    (element) =>
                                        element.dictValue ==
                                        order.orderType.toString(),
                                    orElse: () => DictModel())
                                .dictLabel ??
                            '',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12.px,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.px),
                    Text(
                      '订单号: ${order.orderNo}',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.px),
                Divider(height: 1.px),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.px,
                    vertical: 4.px,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _getStatusColor(order.deliveryStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.px),
                  ),
                  child: Text(
                    _getStatusText(order.deliveryStatus.toString()),
                    style: TextStyle(
                      color: _getStatusColor(order.deliveryStatus),
                      fontSize: 12.px,
                    ),
                  ),
                ),
              ],
            ),
            // 配送地址信息
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 8.px),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.px,
                        color: secondaryColor,
                      ),
                      Text(
                        '${order.deliveryAddress}',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.px),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16.px,
                        color: primaryColor,
                      ),
                      SizedBox(width: 8.px),
                      Text(
                        '${order.deliveryName}',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.px),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 16.px,
                        color: primaryColor,
                      ),
                      SizedBox(width: 8.px),
                      Text(
                        '${order.deliveryTel}',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.px),
            Divider(height: 1.px),
            SizedBox(height: 8.px),
            // 订单信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '下单时间: ${order.createTime}',
                  style: TextStyle(
                    fontSize: 12.px,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (order.deliveryStatus > 0)
              Container(
                  child: Column(
                children: [
                  SizedBox(height: 8.px),
                  // 配送信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 配送员信息
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14.px,
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.delivery_dining,
                              size: 20.px,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(width: 8.px),
                          Text(
                            order.deliveryStaff?.nickName ?? '',
                            style: TextStyle(
                              fontSize: 10.px,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // 联系按钮
                          if (order.deliveryStaff?.tel != '')
                            GestureDetector(
                              onTap: () => {
                                print(order.deliveryStaff?.tel),
                                launchUrl(Uri.parse(
                                    'tel:${order.deliveryStaff?.tel}'))
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.px,
                                  vertical: 4.px,
                                ),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10.px),
                                  border: Border.all(
                                    color: secondaryColor,
                                  ),
                                ),
                                child: Icon(Icons.phone,
                                    size: 16.px, color: Colors.white),
                              ),
                            ),
                          SizedBox(width: 8.px),
                          // 确认收货
                          if (order.deliveryStatus == 2)
                            GestureDetector(
                              onTap: () {
                                // 弹出确认框
                                DialogFactory.instance.showConfirmDialog(
                                  context: context,
                                  title: '确认收货',
                                  content: '确定收货吗？',
                                  confirmClick: () {
                                    _confirmDelivery(order);
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.px,
                                  vertical: 4.px,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10.px),
                                  border: Border.all(
                                    color: primaryColor,
                                  ),
                                ),
                                child: Text('确认收货',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.px)),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.px, vertical: 8.px),
        margin: EdgeInsets.only(right: 8.px),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(10.px),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20.px,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            SizedBox(width: 4.px),
            Text(
              text,
              style: TextStyle(
                fontSize: 12.px,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedStatus = index;
      // 这里可以添加切换状态后的数据刷新逻辑
      pageNum = 1;
      _loadOrders(isRefresh: true);
    });
  }

  // 获取状态颜色
  Color _getStatusColor(int? status) {
    switch (status) {
      case 0:
        return Colors.orange; // 待接单
      case 1:
        return Colors.blue; // 配送中
      case 2:
        return Colors.green; // 已送达
      case 3:
        return secondaryColor; // 已收货
      case 4:
        return primaryColor; // 已完成
      default:
        return Colors.grey;
    }
  }

  // 获取状态文本
  String _getStatusText(String? status) {
    switch (status) {
      case '0':
        return '待接单';
      case '1':
        return '配送中';
      case '2':
        return '已送达';
      case '3':
        return '已收货';
      case '4':
        return '已评价';
      default:
        return '未知状态';
    }
  }
}

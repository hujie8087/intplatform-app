import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/order_model.dart';
import 'package:logistics_app/pages/delivery/order/delivery_order_detail_page.dart';
import 'package:logistics_app/pages/shopping/order/components/order_detail.dart';
import 'package:logistics_app/pages/shopping/order/order_detail_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<OrderModel> orders = [];
  bool isLoading = true;
  List<DictModel> statusList = [];
  late RefreshController _refreshController;
  late ScrollController _scrollController;
  int pageNum = 1;
  int pageSize = 5;
  bool hasMore = true;
  String status = '';
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
    _fetchOrders();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Future<void> _fetchOrders() async {
    // 模拟异步数据获取
    DataUtils.getDictDataList(
      'order_type_status',
      success: (data) {
        BaseListModel<DictModel> response = BaseListModel.fromJson(
          data,
          (json) => DictModel.fromJson(json),
        );

        setState(() {
          statusList = [
            DictModel(dictLabel: S.of(context).all, dictValue: ''),
            ...response.data ?? [],
          ];
          _getOrders();
        });
      },
    );
  }

  Future<void> _getOrders() async {
    var params = {'pageNum': pageNum, 'pageSize': pageSize, 'status': status};
    DataUtils.getPageList(
      APIs.getOrderList,
      params,
      success: (data) {
        setState(() {
          List<OrderModel> newOrders =
              (data['rows'] as List)
                  .map((order) => OrderModel.fromJson(order))
                  .toList();
          if (pageNum == 1) {
            orders = newOrders;
          } else {
            orders.addAll(newOrders);
          }
          hasMore = orders.length < data['total'];
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
          isLoading = false;
        });
      },
      fail: (code, msg) {
        setState(() {});
        _refreshController.refreshFailed();
        // 处理错误
        print('Error fetching orders: $msg');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapterHelper.init(context);
    return Scaffold(
      appBar: AppBar(
        // 间隔设置
        title: Row(
          children: [
            // 输入框搜索我的订单
            Expanded(
              child: Container(
                height: 32.px,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: S.of(context).searchMyOrder,
                    isDense: true, // 使整个输入框更加紧凑
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 6.px,
                      horizontal: 10.px,
                    ), // 减小内边距
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 18.px, // 减小图标大小
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.px),
                      ), // 减小圆角半径
                    ),
                  ),
                  style: TextStyle(fontSize: 12.px), // 减小字体大小
                  onChanged: (value) {
                    print('value: $value');
                  },
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        // 根据订单状态筛选
        actions: [
          PopupMenuButton<String>(
            // 筛选按钮
            icon: Icon(Icons.filter_list),
            // 焦点设置
            initialValue: status,
            itemBuilder:
                (context) =>
                    statusList
                        .map(
                          (e) => PopupMenuItem<String>(
                            child: Text(
                              e.dictLabel ?? '',
                              style: TextStyle(fontSize: 12.px),
                            ),
                            value: e.dictValue,
                          ),
                        )
                        .toList(),
            onSelected: (value) {
              pageNum = 1;
              status = value;
              _getOrders();
            },
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : orders.isEmpty
              ? EmptyView()
              : SmartRefreshWidget(
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: () {
                  pageNum = 1;
                  _getOrders();
                },
                controller: _refreshController,
                onLoading: () {
                  if (hasMore) {
                    pageNum++;
                    _getOrders();
                  } else {
                    _refreshController.loadNoData();
                  }
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderItem(order);
                  },
                ),
              ),
    );
  }

  Widget _buildOrderItem(OrderModel order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailPage(orderId: order.no.toString()),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10.px, vertical: 5.px),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.px),
        ),
        // 阴影
        elevation: 4.px,
        child: Padding(
          padding: EdgeInsets.all(10.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          order.canteenName ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.px,
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 16.px),
                      ],
                    ),
                  ),
                  Text(
                    statusList
                            .firstWhere(
                              (e) => e.dictValue == order.status.toString(),
                            )
                            .dictLabel ??
                        '',
                    style: TextStyle(
                      color:
                          order.status == 4 || order.status == 2
                              ? secondaryColor
                              : Colors.grey,
                      fontSize: 14.px,
                    ),
                  ),
                ],
              ),
              // 下划线
              SizedBox(height: 4.px),
              Divider(height: 2.px, color: Colors.grey[300]),
              SizedBox(height: 4.px),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.px),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OrderDetail(order: order),
                    Column(
                      children: [
                        Text(
                          order.totalPrice.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.px,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (order.orderDetailsList != null)
                          Text(
                            '${S.of(context).total} ${order.orderDetailsList!.fold<int>(0, (sum, detail) {
                              final num = detail.num;
                              return sum + (num ?? 0);
                            })} ${S.of(context).items}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.px,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.px),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 查看配送信息,圆角带边框按钮
                  if (order.pickupType == 3)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        side: BorderSide(color: primaryColor),
                        padding: EdgeInsets.symmetric(
                          vertical: 5.px,
                          horizontal: 8.px,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.px),
                        ),
                        // 实际大小
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        // 查看配送信息
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DeliveryOrderDetailPage(
                                  orderNo: order.no.toString(),
                                ),
                          ),
                        );
                      },
                      child: Text(
                        S.of(context).deliveryInfo,
                        style: TextStyle(color: primaryColor, fontSize: 10.px),
                      ),
                    ),
                  // 删除订单,圆角带边框按钮
                  // OutlinedButton(
                  //   style: OutlinedButton.styleFrom(
                  //     minimumSize: Size.zero,
                  //     side: BorderSide(color: secondaryColor),
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: 5.px, horizontal: 8.px),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8.px),
                  //     ),
                  //     // 实际大小
                  //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //   ),
                  //   onPressed: () {
                  //     // 弹窗删除订单
                  //     DialogFactory.instance.showConfirmDialog(
                  //         context: context,
                  //         title: S.of(context).deleteOrder,
                  //         content: '',
                  //         confirmClick: () {
                  //           // 删除订单
                  //           ShoppingUtils.deleteOrder(order.id.toString(),
                  //               success: (data) async {
                  //             pageNum = 1;
                  //             await _getOrders();
                  //             ProgressHUD.showSuccess(S
                  //                 .of(context)
                  //                 .deleteSuccess(S.of(context).orderInfo));
                  //           }, fail: (code, msg) {
                  //             ProgressHUD.showError(msg);
                  //           });
                  //         });
                  //   },
                  //   child: Text(
                  //     S.of(context).deleteOrder,
                  //     style: TextStyle(color: secondaryColor, fontSize: 10.px),
                  //   ),
                  // ),
                  // SizedBox(width: 10),
                  // // 查看评价,圆角带边框按钮
                  // OutlinedButton(
                  //   style: OutlinedButton.styleFrom(
                  //     minimumSize: Size.zero,
                  //     side: BorderSide(color: primaryColor),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  //   onPressed: () {},
                  //   child: Text(
                  //     '评价',
                  //     style: TextStyle(color: primaryColor),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

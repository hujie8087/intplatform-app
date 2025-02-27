import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/data/repair_utils.dart';
import 'package:logistics_app/http/model/repair_view_model.dart';
import 'package:logistics_app/pages/repair/repair_order_page/repair_order_detail_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RepairItemModel {
  String label;
  int value;
  int badgeCount;

  RepairItemModel(
      {required this.label, required this.value, this.badgeCount = 0});
}

class RepairOrderPage extends StatefulWidget {
  const RepairOrderPage({Key? key}) : super(key: key);

  @override
  _RepairOrderPageState createState() => _RepairOrderPageState();
}

class _RepairOrderPageState extends State<RepairOrderPage> {
  List<RepairViewModel> orders = [];
  bool isLoading = true;
  late RefreshController _refreshController;
  int pageNum = 1;
  int pageSize = 10;
  bool hasMore = true;
  String status = '0'; // 筛选状态
  int currentIndex = 0;
  int waitRepairCount = 0;
  int againRepairCount = 0;

  // 状态选项
  List<RepairItemModel> statusOptions = [
    RepairItemModel(label: '待处理', value: 0, badgeCount: 0),
    RepairItemModel(label: '已维修', value: 1, badgeCount: 0),
    RepairItemModel(label: '待返修', value: 2, badgeCount: 0),
    RepairItemModel(label: '已完结', value: 3, badgeCount: 0),
  ];

  // 获取维修订单未完成数量
  void getRepairUnfinishedCount() async {
    RepairUtils.getRepairUnfinishedCount(
      success: (data) {
        setState(() {
          statusOptions[0].badgeCount = data['data']['waitRepairCount'];
          statusOptions[2].badgeCount = data['data']['againRepairCount'];
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _getOrders();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // 获取订单列表
  Future<void> _getOrders({bool isRefresh = true}) async {
    if (isRefresh) {
      pageNum = 1;
    }

    var params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'repairState': status,
    };

    getRepairUnfinishedCount();
    RepairUtils.getRepairList(params, success: (data) {
      setState(() {
        List<RepairViewModel> newOrders = (data['rows'] as List)
            .map((order) => RepairViewModel.fromJson(order))
            .toList();

        if (isRefresh) {
          orders = newOrders;
        } else {
          orders.addAll(newOrders);
        }

        hasMore = orders.length < (data['total'] ?? 0);
        pageNum++;

        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
        isLoading = false;
      });
    }, fail: (code, msg) {
      _refreshController.refreshFailed();
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('维修订单管理', style: TextStyle(fontSize: 16.px)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 状态筛选栏
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: statusOptions.asMap().entries.map((entry) {
                int index = entry.key;
                RepairItemModel item = entry.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                      status = item.value.toString();
                      _getOrders();
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
                    child: Badge(
                      isLabelVisible: item.badgeCount == 0 ? false : true,
                      label: Text(
                        item.badgeCount.toString(),
                        style: TextStyle(color: Colors.white),
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
                  ),
                );
              }).toList(),
            ),
          ),

          // 列表内容
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : orders.isEmpty
                    ? EmptyView()
                    : SmartRefreshWidget(
                        controller: _refreshController,
                        enablePullDown: true,
                        enablePullUp: hasMore,
                        onRefresh: () async {
                          await _getOrders();
                        },
                        onLoading: () async {
                          await _getOrders(isRefresh: false);
                        },
                        child: orders.length > 0
                            ? ListView.builder(
                                padding: EdgeInsets.all(16.px),
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  final order = orders[index];
                                  return _buildOrderCard(order);
                                },
                              )
                            : Container(),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(RepairViewModel order) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.px),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.px),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            left: 16.px, right: 16.px, top: 16.px, bottom: 8.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单编号和状态
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '订单编号: ${order.repairNo}',
                  style: TextStyle(
                    fontSize: 14.px,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.px,
                    vertical: 4.px,
                  ),
                  decoration: BoxDecoration(
                    color: order.repairState == 0 || order.repairState == 2
                        ? secondaryColor.withOpacity(0.1)
                        : primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.px),
                  ),
                  child: Text(
                    statusOptions[order.repairState ?? 0].label,
                    style: TextStyle(
                      fontSize: 12.px,
                      color: order.repairState == 0 || order.repairState == 2
                          ? secondaryColor
                          : primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.px),

            // 维修信息
            _buildInfoRow(label: '报修区域:', value: order.repairArea),
            _buildInfoRow(label: '房间号:', value: order.roomNo),
            _buildInfoRow(label: '联系人:', value: order.repairPerson),
            _buildInfoRow(label: '联系电话:', value: order.tel),
            _buildInfoRow(label: '报修时间:', value: order.createTime),
            _buildInfoRow(label: '报修信息:', value: order.repairMessage),
            if (order.repairState == 2)
              _buildInfoRow(
                  label: '返修信息:',
                  value: order.ratingMessage,
                  labelColor: secondaryColor),
            if (order.repairState == 1) ...[
              SizedBox(height: 8.px),
              Divider(),
              SizedBox(height: 8.px),
              _buildInfoRow(label: '处理时间:', value: order.updateTime),
              _buildInfoRow(label: '处理结果:', value: order.repairNote),
            ],
            if (order.repairState == 0 || order.repairState == 2) ...[
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.px),
                    ),
                    backgroundColor: primaryColor,
                    minimumSize: Size(double.infinity, 30.px),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepairOrderDetailPage(
                          order: order,
                        ),
                      ),
                    );
                    if (result != null) {
                      _getOrders();
                    }
                  },
                  child: Text('处理'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    String? value,
    MaterialColor labelColor = Colors.grey,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16.px,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.px,
                color: labelColor,
              ),
            ),
          ),
          SizedBox(width: 8.px),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: 12.px,
                color: labelColor == Colors.grey ? Colors.black87 : labelColor,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/cleaning_view_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/pages/accommodation/cleaning/cleaning_data_model.dart';
import 'package:logistics_app/route/auto_route_generator.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:logistics_app/pages/accommodation/cleaning/cleaning_detail_page.dart';

class CleaningOrderPage extends StatefulWidget {
  @override
  _CleaningOrderPageState createState() => _CleaningOrderPageState();
}

class _CleaningOrderPageState extends State<CleaningOrderPage> {
  // 订单状态筛选
  CleaningDataModel model = CleaningDataModel();

  // 搜索控制器
  TextEditingController _searchController = TextEditingController();
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    model.getCleaningTypeList();
    model.getOrderStatus();
    _refreshController = RefreshController();
    model.getCleaningOrderList(true).then((value) {
      _refreshController.refreshCompleted();
      if (model.isLoadMore) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // 加载订单列表
  Future<void> _loadOrderList(bool isRefresh) async {
    model.getCleaningOrderList(isRefresh).then((value) {
      _refreshController.refreshCompleted();
      if (model.isLoadMore) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    });
  }

  // 获取状态颜色
  Color _getStatusColor(String status) {
    switch (status) {
      case '0':
        return Colors.blue;
      case '1':
        return Colors.green;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.red;
      case '4':
        return Colors.deepOrange;
      case '5':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).cleaning_order,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        onPressed: () async {
          // 跳转到创建订单页面
          final result = await Navigator.pushNamed(
            context,
            RoutePath.CleaningSubmitPage,
          );
          if (result == true) {
            _loadOrderList(true);
          }
        },
        child: Icon(Icons.add, size: 24.px),
      ),
      body: ChangeNotifierProvider.value(
        value: model,
        child: Consumer<CleaningDataModel>(
          builder: (context, cleaningDataModel, child) {
            return Column(
              children: [
                // 搜索框
                Padding(
                  padding: EdgeInsets.fromLTRB(8.px, 8.px, 8.px, 0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.px,
                      vertical: 2.px,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.px),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: Colors.grey, size: 16.px),
                        SizedBox(width: 4.px),
                        Expanded(
                          child: SizedBox(
                            height: 32.px,
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(fontSize: 12.px),
                              textAlignVertical: TextAlignVertical.center, // 关键
                              decoration: InputDecoration(
                                hintText: S.of(context).cleaning_order_search,
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.px),
                        SizedBox(
                          height: 32.px,
                          child: ElevatedButton(
                            onPressed: () => _loadOrderList(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 10.px),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.px),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              S.of(context).cleaning_search,
                              style: TextStyle(
                                fontSize: 12.px,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 状态筛选
                Padding(
                  padding: EdgeInsets.only(top: 10.px, left: 8.px, right: 8.px),
                  child: Row(
                    children: List.generate(
                      model.statusList.length,
                      (i) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              model.selectedStatus =
                                  model.statusList[i].dictValue ?? '-1';
                              _loadOrderList(true);
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                model.statusList[i].dictLabel ?? '',
                                style: TextStyle(
                                  fontSize: 14.px,
                                  color:
                                      model.selectedStatus ==
                                              model.statusList[i].dictValue
                                          ? primaryColor
                                          : Colors.grey.shade600,
                                  fontWeight:
                                      model.selectedStatus ==
                                              model.statusList[i].dictValue
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 2.px),
                              if (model.selectedStatus ==
                                  model.statusList[i].dictValue)
                                Container(
                                  height: 3.px,
                                  width: 24.px,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(2.px),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.px),

                // 订单列表
                Expanded(
                  child:
                      model.isShowButton
                          ? Center(child: CircularProgressIndicator())
                          : model.cleaningOrderList.isEmpty
                          ? EmptyView()
                          : SmartRefreshWidget(
                            controller: _refreshController,
                            enablePullDown: true,
                            enablePullUp: true,
                            onRefresh: () => _loadOrderList(true),
                            onLoading: () => _loadOrderList(false),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 8.px),
                              itemCount: model.cleaningOrderList.length,
                              itemBuilder: (context, index) {
                                final order = model.cleaningOrderList[index];
                                return _buildOrderCard(order, model);
                              },
                            ),
                          ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 订单卡片
  Widget _buildOrderCard(CleaningViewModel order, CleaningDataModel model) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单头部信息
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.px),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.px),
                  ),
                  child: Icon(
                    Icons.cleaning_services,
                    color: primaryColor,
                    size: 14.px,
                  ),
                ),
                SizedBox(width: 8.px),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).cleaning_order_number,
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 2.px),
                      Text(
                        order.clNo ?? '',
                        style: TextStyle(
                          fontSize: 14.px,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.px,
                    vertical: 4.px,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      order.orderStatus.toString(),
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.px),
                    border: Border.all(
                      color: _getStatusColor(
                        order.orderStatus.toString(),
                      ).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusText(order.orderStatus.toString()),
                    style: TextStyle(
                      fontSize: 10.px,
                      color: _getStatusColor(order.orderStatus.toString()),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.px),

            // 主要信息
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompactInfoRow(
                        S.of(context).cleaning_contacts,
                        order.contacts ?? '',
                        Icons.person,
                      ),
                      _buildCompactInfoRow(
                        S.of(context).cleaning_tel,
                        order.tel ?? '',
                        Icons.phone,
                      ),
                      _buildCompactInfoRow(
                        S.of(context).cleaning_area,
                        order.clArea ?? '',
                        Icons.location_on,
                      ),
                      _buildCompactInfoRow(
                        S.of(context).cleaning_room_number,
                        order.roomNo ?? '',
                        Icons.home,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.px),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.px,
                        vertical: 4.px,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.px),
                      ),
                      child: Text(
                        '${order.cleanPrice?.toStringAsFixed(2) ?? '0.00'}KRP',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.px),
                    Text(
                      S.of(context).cleaning_price,
                      style: TextStyle(
                        fontSize: 10.px,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 6.px),

            // 保洁项目
            Container(
              padding: EdgeInsets.all(5.px),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.blue.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.px),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cleaning_services,
                    color: Colors.blue,
                    size: 12.px,
                  ),
                  SizedBox(width: 6.px),
                  Expanded(
                    child: Text(
                      _getCleaningProjectText(order),
                      style: TextStyle(
                        fontSize: 11.px,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 6.px),

            // 时间信息
            Row(
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    S.of(context).cleaning_order_create,
                    order.createTime ?? '',
                    Icons.access_time,
                  ),
                ),
                SizedBox(width: 12.px),
                Expanded(
                  child: _buildTimeInfo(
                    S.of(context).cleaning_order_handle,
                    order.handleTime ?? '',
                    Icons.check_circle,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.px),

            // 操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.orderStatus == 1) // 待接单
                  Container(
                    height: 28.px,
                    child: ElevatedButton(
                      onPressed: () {
                        _showRatingDialog(order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12.px),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.px),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        S.of(context).cleaning_evaluate,
                        style: TextStyle(fontSize: 11.px),
                      ),
                    ),
                  ),
                SizedBox(width: 8.px),
                // 取消订单
                if (order.orderStatus == 0) // 待接单
                  Container(
                    height: 28.px,
                    child: ElevatedButton(
                      onPressed: () {
                        DialogFactory.instance.showFieldDialog(
                          context: context,
                          title: S.of(context).inputMessage(S.of(context).name),
                          confirmClick: () async {
                            final result = await model.cancelCleaningOrder(
                              order.id,
                            );
                            if (result) {
                              ProgressHUD.showSuccess('取消订单成功');
                              model.getCleaningOrderList(true);
                            }
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12.px),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.px),
                        ),
                        elevation: 0,
                      ),
                      child: Text('取消订单', style: TextStyle(fontSize: 11.px)),
                    ),
                  ),
                SizedBox(width: 10.px),
                Container(
                  height: 28.px,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CleaningDetailPage(order: order),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                      padding: EdgeInsets.symmetric(horizontal: 12.px),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.px),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      S.of(context).cleaning_order_view,
                      style: TextStyle(fontSize: 11.px),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 获取状态文字
  String _getStatusText(String status) {
    if (model.statusList.isEmpty) {
      return S.of(context).loading;
    }

    try {
      final statusItem = model.statusList.firstWhere(
        (element) => element.dictValue == status,
        orElse:
            () => DictModel(
              dictValue: status,
              dictLabel: S.of(context).unknown_status,
            ),
      );
      return statusItem.dictLabel ?? S.of(context).unknown_status;
    } catch (e) {
      return S.of(context).unknown_status;
    }
  }

  // 获取保洁项目文字
  String _getCleaningProjectText(CleaningViewModel order) {
    if (model.cleaningTypeList.isEmpty) {
      return S.of(context).no_more_info;
    }

    try {
      final project = model.cleaningTypeList.firstWhere(
        (element) => element.id == order.cpId,
        orElse:
            () => CleaningTypeModel(
              id: 0,
              projectDetails: S.of(context).no_more_info,
            ),
      );
      return project.projectDetails ?? S.of(context).no_more_info;
    } catch (e) {
      return S.of(context).no_more_info;
    }
  }

  // 紧凑信息行组件
  Widget _buildCompactInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.px),
      child: Row(
        children: [
          Icon(icon, size: 12.px, color: Colors.grey[500]),
          SizedBox(width: 4.px),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.grey[600], fontSize: 10.px),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? S.of(context).no_more_info : value,
              style: TextStyle(
                fontSize: 10.px,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 时间信息组件
  Widget _buildTimeInfo(String label, String time, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 10.px, color: Colors.grey[500]),
            SizedBox(width: 4.px),
            Text(
              label,
              style: TextStyle(fontSize: 9.px, color: Colors.grey[500]),
            ),
          ],
        ),
        SizedBox(height: 2.px),
        Text(
          time.isEmpty ? S.of(context).cleaning_order_pending : time,
          style: TextStyle(
            fontSize: 10.px,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 评价弹窗
  void _showRatingDialog(CleaningViewModel order) {
    int rating = 0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.px),
              ),
              child: Container(
                padding: EdgeInsets.all(16.px),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.px),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题
                    Row(
                      children: [
                        Icon(
                          Icons.rate_review,
                          color: primaryColor,
                          size: 20.px,
                        ),
                        SizedBox(width: 8.px),
                        Text(
                          S.of(context).cleaning_order_evaluate,
                          style: TextStyle(
                            fontSize: 14.px,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6.px),

                    // 订单信息
                    Container(
                      padding: EdgeInsets.all(8.px),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8.px),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cleaning_services,
                            color: primaryColor,
                            size: 12.px,
                          ),
                          SizedBox(width: 8.px),
                          Expanded(
                            child: Text(
                              '${S.of(context).cleaning_order_number}: ${order.clNo}',
                              style: TextStyle(fontSize: 12.px),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5.px),

                    // 评分
                    Text(
                      '${S.of(context).cleaning_order_evaluate_title}',
                      style: TextStyle(
                        fontSize: 12.px,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8.px),

                    // 星级评分
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              rating = index + 1;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.px),
                            child: Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color:
                                  index < rating
                                      ? Colors.amber
                                      : Colors.grey[400],
                              size: 24.px,
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 8.px),

                    // 评分文字
                    Text(
                      _getRatingText(rating),
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 10.px),

                    // 评价内容
                    Text(
                      '${S.of(context).cleaning_order_evaluate_content}',
                      style: TextStyle(
                        fontSize: 12.px,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),

                    SizedBox(height: 8.px),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8.px),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: commentController,
                        maxLines: 4,
                        style: TextStyle(fontSize: 10.px),
                        decoration: InputDecoration(
                          hintText:
                              '${S.of(context).cleaning_order_evaluate_content_hint}',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.px),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.px),

                    // 按钮
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 8.px),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.px),
                              ),
                            ),
                            child: Text(
                              '${S.of(context).cancel}',
                              style: TextStyle(fontSize: 12.px),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.px),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                rating > 0
                                    ? () {
                                      // 提交评价逻辑
                                      _submitRating(
                                        order,
                                        rating,
                                        commentController.text,
                                      );
                                      Navigator.of(context).pop();
                                    }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 8.px),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.px),
                              ),
                            ),
                            child: Text(
                              '${S.of(context).cleaning_order_evaluate_submit}',
                              style: TextStyle(
                                fontSize: 12.px,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 获取评分文字
  String _getRatingText(int rating) {
    if (rating == 0)
      return '${S.of(context).cleaning_order_evaluate_select_rating}';
    if (rating <= 1)
      return '${S.of(context).cleaning_order_evaluate_very_dissatisfied}';
    if (rating <= 2)
      return '${S.of(context).cleaning_order_evaluate_dissatisfied}';
    if (rating <= 3) return '${S.of(context).cleaning_order_evaluate_average}';
    if (rating <= 4)
      return '${S.of(context).cleaning_order_evaluate_satisfied}';
    return '${S.of(context).cleaning_order_evaluate_very_satisfied}';
  }

  // 提交评价
  Future<void> _submitRating(
    CleaningViewModel order,
    int rating,
    String comment,
  ) async {
    // TODO: 实现评价提交逻辑
    final result = await model.evaluateCleaningOrder(order.id, rating, comment);
    if (result) {
      ProgressHUD.showSuccess(
        '${S.of(context).cleaning_order_evaluate_success}',
      );
      model.getCleaningOrderList(true);
    } else {
      ProgressHUD.showError('${S.of(context).cleaning_order_evaluate_fail}');
    }

    // 这里可以调用API提交评价
  }
}

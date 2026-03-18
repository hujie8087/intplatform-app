import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/cleaning_view_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/pages/accommodation/cleaning/cleaning_data_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class CleaningDetailPage extends StatefulWidget {
  final CleaningViewModel order;

  const CleaningDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  _CleaningDetailPageState createState() => _CleaningDetailPageState();
}

class _CleaningDetailPageState extends State<CleaningDetailPage> {
  CleaningDataModel model = CleaningDataModel();
  Color statusColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    model.getOrderStatus();
    model.getCleaningTypeList();
    _getStatusColor(widget.order.orderStatus.toString());
  }

  // 获取状态颜色
  void _getStatusColor(String status) {
    setState(() {
      switch (status) {
        case '0':
          statusColor = Colors.blue;
        case '1':
          statusColor = Colors.green;
        case '2':
          statusColor = Colors.orange;
        case '3':
          statusColor = Colors.red;
        case '4':
          statusColor = Colors.deepOrange;
        case '5':
          statusColor = Colors.red;
        default:
          statusColor = Colors.grey;
      }
    });
  }

  // 动态获取状态文字
  String _getCurrentStatusText() {
    if (model.statusList.isEmpty) {
      return S.current.cleaning_loading;
    }

    try {
      final statusItem = model.statusList.firstWhere(
        (element) => element.dictValue == widget.order.orderStatus.toString(),
        orElse:
            () => DictModel(
              dictValue: widget.order.orderStatus.toString(),
              dictLabel: S.current.unknown_status,
            ),
      );
      return statusItem.dictLabel ?? S.current.unknown_status;
    } catch (e) {
      return S.current.unknown_status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          S.of(context).cleaning_order_detail,
          style: TextStyle(fontSize: 14.px, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.px),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ChangeNotifierProvider.value(
        value: model,
        child: Consumer<CleaningDataModel>(
          builder: (context, cleaningDataModel, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(8.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 订单状态卡片
                  _buildStatusCard(),

                  SizedBox(height: 8.px),

                  // 基本信息卡片
                  _buildBasicInfoCard(),

                  SizedBox(height: 8.px),

                  // 服务详情卡片
                  _buildServiceDetailCard(),

                  SizedBox(height: 8.px),

                  // 时间线卡片
                  _buildTimelineCard(),

                  SizedBox(height: 8.px),

                  // 其他信息卡片
                  if (widget.order.remark != null &&
                      widget.order.remark!.isNotEmpty)
                    _buildOtherInfoCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 订单状态卡片
  Widget _buildStatusCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor.withOpacity(0.1), statusColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.px),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.px),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.px),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6.px),
              ),
              child: Icon(
                Icons.cleaning_services,
                color: statusColor,
                size: 16.px,
              ),
            ),
            SizedBox(width: 8.px),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).cleaning_order_status,
                    style: TextStyle(fontSize: 10.px, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 2.px),
                  Text(
                    _getCurrentStatusText(),
                    style: TextStyle(
                      fontSize: 12.px,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12.px),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.3),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                _getCurrentStatusText(),
                style: TextStyle(
                  fontSize: 10.px,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 基本信息卡片
  Widget _buildBasicInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.px),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.px),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: primaryColor,
                    size: 14.px,
                  ),
                ),
                SizedBox(width: 8.px),
                Text(
                  S.of(context).cleaning_basic_info,
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.px),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildInfoRow(
                        S.of(context).cleaning_order_number,
                        widget.order.clNo ?? '',
                        Icons.receipt,
                      ),
                      _buildInfoRow(
                        S.of(context).cleaning_contacts,
                        widget.order.contacts ?? '',
                        Icons.person,
                      ),
                      _buildInfoRow(
                        S.of(context).cleaning_tel,
                        widget.order.tel ?? '',
                        Icons.phone,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.px),
                Expanded(
                  child: Column(
                    children: [
                      _buildInfoRow(
                        S.of(context).cleaning_area,
                        widget.order.clArea ?? '',
                        Icons.location_on,
                      ),
                      _buildInfoRow(
                        S.of(context).cleaning_room_number,
                        widget.order.roomNo ?? '',
                        Icons.home,
                      ),
                      _buildInfoRow(
                        S.of(context).cleaning_price,
                        '${widget.order.cleanPrice?.toStringAsFixed(2) ?? '0.00'}KRP',
                        Icons.attach_money,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 服务详情卡片
  Widget _buildServiceDetailCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.px),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.px),
                  ),
                  child: Icon(
                    Icons.cleaning_services,
                    color: Colors.blue,
                    size: 14.px,
                  ),
                ),
                SizedBox(width: 8.px),
                Text(
                  S.of(context).cleaning_service_detail,
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.px),
            Container(
              padding: EdgeInsets.all(10.px),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.blue.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(6.px),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cleaning_services,
                        color: Colors.blue,
                        size: 12.px,
                      ),
                      SizedBox(width: 6.px),
                      Text(
                        S.of(context).cleaning_project,
                        style: TextStyle(
                          fontSize: 10.px,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.px),
                  Text(
                    model.cleaningTypeList
                            .firstWhere(
                              (element) => element.id == widget.order.cpId,
                              orElse:
                                  () => CleaningTypeModel(
                                    id: 0,
                                    projectDetails: S.current.no_more_info,
                                  ),
                            )
                            .projectDetails ??
                        S.current.no_more_info,
                    style: TextStyle(
                      fontSize: 10.px,
                      color: Colors.blue[700],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 时间线卡片
  Widget _buildTimelineCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.px),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.px),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: Colors.orange,
                    size: 14.px,
                  ),
                ),
                SizedBox(width: 8.px),
                Text(
                  S.of(context).cleaning_order_progress,
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.px),
            _buildTimelineItem(
              icon: Icons.shopping_cart,
              title: S.of(context).cleaning_order_create,
              time: widget.order.createTime ?? '',
              isCompleted: true,
              color: Colors.green,
            ),
            if (widget.order.orderStatus == 5)
              _buildTimelineItem(
                icon: Icons.cancel,
                title: '已取消',
                time: widget.order.updateTime ?? '',
                isCompleted: widget.order.orderStatus == 5,
                color: Colors.red,
              ),
            if (widget.order.orderStatus == 2)
              _buildTimelineItem(
                icon: Icons.cancel,
                title: '已退款',
                time: widget.order.updateTime ?? '',
                isCompleted: widget.order.orderStatus == 2,
                color: Colors.red,
              ),
            _buildTimelineItem(
              icon: Icons.check_circle,
              title: '已接单',
              time: widget.order.handleTime ?? '',
              isCompleted:
                  widget.order.orderStatus == 4 ||
                  widget.order.orderStatus == 1 ||
                  widget.order.orderStatus == 3,
              color: Colors.deepOrange,
            ),
            _buildTimelineItem(
              icon: Icons.check_circle,
              title: S.of(context).cleaning_order_handle,
              time: widget.order.handleTime ?? '',
              isCompleted:
                  widget.order.orderStatus == 1 ||
                  widget.order.orderStatus == 3,
              color: Colors.blue,
            ),
            _buildTimelineItem(
              icon: Icons.star,
              title: S.of(context).cleaning_order_evaluate,
              time:
                  widget.order.orderStatus == 3
                      ? widget.order.updateTime ?? ''
                      : '',
              isCompleted: widget.order.orderStatus == 3,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  // 其他信息卡片
  Widget _buildOtherInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.px),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.px),
                  ),
                  child: Icon(Icons.note, color: Colors.purple, size: 14.px),
                ),
                SizedBox(width: 8.px),
                Text(
                  S.of(context).cleaning_other_info,
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.px),
            Row(
              children: [
                Container(
                  width: 60.px,
                  child: Text(
                    S.of(context).cleaning_evaluate,
                    style: TextStyle(color: Colors.grey[600], fontSize: 10.px),
                  ),
                ),
                SmoothStarRating(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: widget.order.score?.toDouble() ?? 0.0,
                  size: 16.px,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  spacing: 0.0,
                ),
                SizedBox(width: 6.px),
                Text(
                  '${widget.order.score?.toString() ?? '0'}.0',
                  style: TextStyle(
                    fontSize: 10.px,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.px),
            _buildInfoRow(
              S.of(context).cleaning_order_evaluate_content,
              widget.order.evaluate ?? '',
              Icons.rate_review,
            ),
            _buildInfoRow(
              S.of(context).cleaning_remark,
              widget.order.remark ?? '',
              Icons.note,
            ),
          ],
        ),
      ),
    );
  }

  // 信息行组件
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16.px,
            height: 16.px,
            child: Icon(icon, size: 12.px, color: Colors.grey[500]),
          ),
          SizedBox(width: 6.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 10.px),
                ),
                SizedBox(height: 1.px),
                Text(
                  value.isEmpty ? S.current.no_more_info : value,
                  style: TextStyle(
                    fontSize: 12.px,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 时间线项目组件
  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String time,
    required bool isCompleted,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.px),
      child: Row(
        children: [
          Container(
            width: 24.px,
            height: 24.px,
            decoration: BoxDecoration(
              color: isCompleted ? color : Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow:
                  isCompleted
                      ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ]
                      : null,
            ),
            child: Icon(
              icon,
              color: isCompleted ? Colors.white : Colors.grey[600],
              size: 12.px,
            ),
          ),
          SizedBox(width: 8.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight:
                        isCompleted ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Colors.black87 : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2.px),
                Text(
                  time.isEmpty ? S.current.cleaning_order_pending : time,
                  style: TextStyle(fontSize: 10.px, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

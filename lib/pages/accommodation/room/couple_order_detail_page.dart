import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/el_steps_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/couple_room_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class CoupleOrderDetailPage extends StatefulWidget {
  const CoupleOrderDetailPage({Key? key, required this.orderId})
    : super(key: key);

  final String orderId;
  @override
  _CoupleOrderDetailPageState createState() => _CoupleOrderDetailPageState();
}

class _CoupleOrderDetailPageState extends State<CoupleOrderDetailPage> {
  CoupleOrderModel? coupleOrder;

  // 加载中
  bool isLoading = true;
  int currentStep = 0;

  List<Map<String, String>> steps = [];

  // 获取订单详情
  Future<void> getCoupleOrderDetail() async {
    setState(() {
      isLoading = true;
    });
    DataUtils.getCoupleOrderDetail(
      widget.orderId,
      success: (data) {
        setState(() {
          coupleOrder = CoupleOrderModel.fromJson(data['data']);
          steps = [
            {
              'title': '新订单',
              'date': coupleOrder?.createTime?.substring(0, 10) ?? '',
            },
            {
              'title': '确认订单',
              'date': coupleOrder?.confirmTime?.substring(0, 10) ?? '',
            },
            {'title': '宿管审核', 'date': ''},
            {'title': '已完成', 'date': ''},
          ];
          if (coupleOrder?.status == 1) {
            currentStep = 1;
          } else if (coupleOrder?.status == 10 || coupleOrder?.status == 5) {
            currentStep = 3;
            steps[3]['date'] =
                coupleOrder?.auditList?[0].createTime?.substring(0, 10) ?? '';
            steps[2]['date'] =
                coupleOrder?.auditList?[0].createTime?.substring(0, 10) ?? '';
          } else if (coupleOrder?.status == 11) {
            currentStep = 2;
            steps[2]['date'] =
                coupleOrder?.auditList?[0].createTime?.substring(0, 10) ?? '';
          }

          isLoading = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCoupleOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).coupleRoom_room_order_detail,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.px,
                    vertical: 6.px,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 步骤进度条
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.px,
                          horizontal: 6.px,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.px),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4.px),
                          ],
                        ),
                        child: Column(
                          children: [
                            ElSteps(
                              steps:
                                  steps
                                      .map(
                                        (e) => StepData(
                                          icon: Icons.check,
                                          label: e['title']!,
                                          description: e['date'] ?? '',
                                        ),
                                      )
                                      .toList(),
                              currentStep: currentStep,
                              activeColor: primaryColor,
                              completedColor: primaryColor,
                              inactiveColor: Colors.grey[400]!,
                              stepRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.px),
                      // 客房信息
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(10.px),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4.px,
                                    height: 16.px,
                                    color: primaryColor,
                                    margin: EdgeInsets.only(right: 6.px),
                                  ),
                                  Text(
                                    S.of(context).coupleRoom_room_info,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.px,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.px),
                                child: Divider(
                                  height: 1.px,
                                  color: Colors.grey,
                                ),
                              ),
                              _infoRow(
                                S.of(context).coupleRoom_room_number,
                                coupleOrder?.chamberName ?? '',
                                highlight: true,
                                highlightColor: primaryColor,
                              ),
                              _infoRow(
                                S.of(context).coupleRoom_room_order_create_time,
                                coupleOrder?.startTime ?? '',
                              ),
                              _infoRow(
                                S.of(context).coupleRoom_room_order_start_time,
                                coupleOrder?.startTime?.substring(0, 10) ?? '',
                              ),
                              _infoRow(
                                S.of(context).coupleRoom_room_order_end_time,
                                coupleOrder?.endTime?.substring(0, 10) ?? '',
                              ),
                              _infoRow(
                                S.of(context).coupleRoom_room_order_price,
                                '${coupleOrder?.price?.toString() ?? '0'}KRP',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      // 用户信息
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(10.px),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4.px,
                                    height: 16.px,
                                    color: primaryColor,
                                    margin: EdgeInsets.only(right: 6.px),
                                  ),
                                  Text(
                                    S.of(context).coupleRoom_room_staff_info,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.px,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              if (coupleOrder?.staffList != null)
                                ...coupleOrder!.staffList!.map(
                                  (user) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                user.sex == '男'
                                                    ? primaryColor
                                                    : secondaryColor,
                                            radius: 12.px,
                                            child: Icon(
                                              user.sex == '男'
                                                  ? Icons.male
                                                  : Icons.female,
                                              color: Colors.white,
                                              size: 16.px,
                                            ),
                                          ),
                                          SizedBox(width: 6.px),
                                          Text(
                                            user.name ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _infoRow(
                                        S
                                            .of(context)
                                            .coupleRoom_room_staff_username,
                                        user.username ?? '',
                                      ),
                                      _infoRow(
                                        S.of(context).coupleRoom_room_staff_tel,
                                        user.tel ?? '',
                                      ),
                                      _infoRow(
                                        S
                                            .of(context)
                                            .coupleRoom_room_staff_dept,
                                        user.dept ?? '',
                                      ),
                                      _infoRow(
                                        S.of(context).coupleRoom_room_staff_job,
                                        user.job ?? '',
                                      ),
                                      SizedBox(height: 4.px),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8.px),
                      // 审核信息
                      if (coupleOrder?.auditList?.isNotEmpty ?? false)
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.px),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(10.px),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 4.px,
                                      height: 16.px,
                                      color: primaryColor,
                                      margin: EdgeInsets.only(right: 6.px),
                                    ),
                                    Text(
                                      S.of(context).coupleRoom_room_audit_info,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.px,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: secondaryColor,
                                      radius: 12.px,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16.px,
                                      ),
                                    ),
                                    SizedBox(width: 6.px),
                                    Text(
                                      coupleOrder?.auditList?[0].title ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                _infoRow(
                                  S.of(context).coupleRoom_room_audit_staff,
                                  coupleOrder?.auditList?[0].name ?? '',
                                ),
                                _infoRow(
                                  S.of(context).coupleRoom_room_audit_time,
                                  coupleOrder?.auditList?[0].createTime ?? '',
                                ),
                                _infoRow(
                                  S.of(context).coupleRoom_room_audit_status,
                                  coupleOrder?.auditList?[0].status == '1'
                                      ? S
                                          .of(context)
                                          .coupleRoom_room_audit_status_pass
                                      : S
                                          .of(context)
                                          .coupleRoom_room_audit_status_reject,
                                  highlight: true,
                                  highlightColor:
                                      coupleOrder?.auditList?[0].status == '1'
                                          ? primaryColor
                                          : secondaryColor,
                                ),
                                if ((coupleOrder?.auditList?[0].content ?? '')
                                    .isNotEmpty)
                                  _infoRow(
                                    S.of(context).coupleRoom_room_audit_remark,
                                    coupleOrder?.auditList?[0].content ?? '',
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }

  // 信息行组件
  Widget _infoRow(
    String label,
    String value, {
    bool highlight = false,
    Color? highlightColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.px),
      margin: EdgeInsets.symmetric(vertical: 4.px),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.px),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700], fontSize: 12.px),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.px,
                color:
                    highlight ? (highlightColor ?? Colors.pink) : Colors.black,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

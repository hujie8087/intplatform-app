import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/couple_room_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/accommodation/room/couple_order_detail_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CoupleOrderPage extends StatefulWidget {
  @override
  _CoupleOrderPageState createState() => _CoupleOrderPageState();
}

class _CoupleOrderPageState extends State<CoupleOrderPage> {
  // 总Tab和订单数据
  List<DictModel> statusList = [];
  String userName = '';

  // 当前登录用户
  CoupleStaffListModel? currentUser;

  Future<void> _fetchCurrentUser() async {
    DataUtils.getCoupleStaffList(
      {'username': userName},
      success: (data) {
        setState(() {
          if (data['rows'].isNotEmpty) {
            currentUser = CoupleStaffListModel.fromJson(data['rows'][0]);
          }
        });
      },
    );
  }

  // 当前选中的Tab
  String selectedTab = '0';
  // 夫妻房订单列表
  List<CoupleOrderModel> coupleOrderList = [];

  int pageNum = 1;
  int pageSize = 10;
  int total = 0;

  // 是否加载中
  bool _isLoading = false;

  // 搜索框控制器
  TextEditingController _searchController = TextEditingController();

  late RefreshController _refreshController;

  // 获取订单列表
  Future<void> getCoupleOrderList(bool isRefresh) async {
    if (isRefresh) {
      setState(() {
        _isLoading = true;
        pageNum = 1;
        coupleOrderList = [];
      });
    } else {
      setState(() {
        pageNum++;
      });
    }

    String searchStatus = '';
    if (selectedTab == '0') {
      searchStatus = '';
    } else if (selectedTab == '1') {
      searchStatus = '1';
    } else if (selectedTab == '2') {
      searchStatus = '10';
    } else if (selectedTab == '3') {
      searchStatus = '11';
    } else if (selectedTab == '4') {
      searchStatus = '9';
    }

    final param = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'chamberName': _searchController.text,
    };
    if (searchStatus != '') {
      param['status'] = searchStatus;
    }

    try {
      DataUtils.getCoupleOrderList(
        param,
        success: (data) {
          if (data != null) {
            var coupleOrder = data['rows'] as List;
            List<CoupleOrderModel> rows =
                coupleOrder.map((i) => CoupleOrderModel.fromJson(i)).toList();

            setState(() {
              if (isRefresh) {
                coupleOrderList = rows;
              } else {
                coupleOrderList = [...coupleOrderList, ...rows];
              }
              total = data['total'] ?? 0;
              print('coupleOrderList: ${coupleOrderList.length}');
              if (coupleOrderList.length >= total) {
                _refreshController.loadNoData();
              } else {
                _refreshController.loadComplete();
              }
              _isLoading = false;
            });
          }
          ;
        },
        fail: (code, msg) {
          setState(() {
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 获取订单类型
  Future<void> _fetchOrderStatus() async {
    var userInfoData = await SpUtils.getModel('thirdUserInfo');
    if (userInfoData != null) {
      setState(() {
        userName = ThirdUserInfoModel.fromJson(userInfoData).account ?? '';
        _fetchCurrentUser();
      });
    }

    DataUtils.getDictDataList(
      'couple_order_status',
      success: (data) {
        final result =
            BaseListModel<DictModel>.fromJson(
              data,
              (json) => DictModel.fromJson(json),
            ).data ??
            [];
        setState(() {
          statusList = result;
          getCoupleOrderList(true);
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _fetchOrderStatus();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 筛选
    List<DictModel> filterStatusList = [
      DictModel(dictValue: '0', dictLabel: S.of(context).coupleRoom_room_all),
      DictModel(
        dictValue: '1',
        dictLabel: S.of(context).coupleRoom_room_pending,
      ),
      DictModel(
        dictValue: '2',
        dictLabel: S.of(context).coupleRoom_room_approved,
      ),
      DictModel(
        dictValue: '3',
        dictLabel: S.of(context).coupleRoom_room_rejected,
      ),
      DictModel(
        dictValue: '4',
        dictLabel: S.of(context).coupleRoom_room_canceled,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).coupleRoom_room_order,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.px, 8.px, 8.px, 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.px, vertical: 2.px),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.px),
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
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
                      onPressed: () => getCoupleOrderList(true),
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
                        style: TextStyle(fontSize: 12.px, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tab筛选
          Padding(
            padding: EdgeInsets.only(top: 10.px, left: 10.px, right: 10.px),
            child: Row(
              children: List.generate(
                filterStatusList.length,
                (i) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      /* 这里可实现切换Tab逻辑 */
                      setState(() {
                        selectedTab = filterStatusList[i].dictValue ?? '0';
                        getCoupleOrderList(true);
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          filterStatusList[i].dictLabel ?? '',
                          style: TextStyle(
                            fontSize: 14.px,
                            color:
                                selectedTab == filterStatusList[i].dictValue
                                    ? primaryColor
                                    : Colors.grey.shade600,
                            fontWeight:
                                selectedTab == filterStatusList[i].dictValue
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 2),
                        if (selectedTab == filterStatusList[i].dictValue)
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
          // 订单卡片列表
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
              child:
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : coupleOrderList.isNotEmpty
                      ? SmartRefreshWidget(
                        enablePullDown: true,
                        enablePullUp: true,
                        onRefresh: () {
                          getCoupleOrderList(true).then((value) {
                            _refreshController.refreshCompleted();
                          });
                        },
                        onLoading: () {
                          getCoupleOrderList(false);
                        },
                        controller: _refreshController,
                        child: ListView.builder(
                          itemCount: coupleOrderList.length,
                          itemBuilder: (context, index) {
                            final order = coupleOrderList[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 16.px),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.px),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 14.px,
                                  right: 14.px,
                                  top: 14.px,
                                  bottom: 0.px,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.home,
                                          color: primaryColor,
                                          size: 20.px,
                                        ),
                                        SizedBox(width: 6.px),
                                        Text(
                                          S.of(context).coupleRoom_room_number,
                                          style: TextStyle(fontSize: 15.px),
                                        ),
                                        Text(
                                          order.chamberName ?? '',
                                          style: TextStyle(
                                            fontSize: 15.px,
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          (statusList
                                                  .firstWhere(
                                                    (e) =>
                                                        e.dictValue ==
                                                        order.status.toString(),
                                                    orElse:
                                                        () => DictModel(
                                                          dictValue: '',
                                                          dictLabel: '',
                                                        ),
                                                  )
                                                  .dictLabel) ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 4.px,
                                      ),
                                      child: Divider(
                                        height: 1.px,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          S
                                              .of(context)
                                              .coupleRoom_room_order_create_time,
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          order.createTime ?? '',
                                          style: TextStyle(fontSize: 12.px),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          S
                                              .of(context)
                                              .coupleRoom_room_order_start_time,
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          order.startTime ?? '',
                                          style: TextStyle(fontSize: 12.px),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          S
                                              .of(context)
                                              .coupleRoom_room_order_end_time,
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          order.endTime ?? '',
                                          style: TextStyle(fontSize: 12.px),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          S
                                              .of(context)
                                              .coupleRoom_room_order_price,
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          '${order.price?.toString() ?? '0'}KRP',
                                          style: TextStyle(fontSize: 12.px),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 4.px,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (order.status == 0 ||
                                            order.status == 1)
                                          // 取消
                                          ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                      title: Text(
                                                        S
                                                            .of(context)
                                                            .coupleRoom_room_cancel_order,
                                                      ),
                                                      content: Text(
                                                        S
                                                            .of(context)
                                                            .coupleRoom_room_cancel_order_confirm,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Text(
                                                            S
                                                                .of(context)
                                                                .coupleRoom_room_cancel,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            DataUtils.cancelBookCoupleRoom(
                                                              {
                                                                'id':
                                                                    order.id
                                                                        .toString(),
                                                              },
                                                              success: (data) {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                                ProgressHUD.showSuccess(
                                                                  S
                                                                      .of(
                                                                        context,
                                                                      )
                                                                      .coupleRoom_room_cancel_order_success,
                                                                );
                                                                // 发送通知

                                                                // 发送通知
                                                                DataUtils.getUserInfoByUsername(
                                                                  currentUser
                                                                      ?.bind,
                                                                  success: (
                                                                    data,
                                                                  ) {
                                                                    if (data['msg'] !=
                                                                        null) {
                                                                      DataUtils.sendOneMessage({
                                                                        'title':
                                                                            S
                                                                                .of(
                                                                                  context,
                                                                                )
                                                                                .coupleRoom_room_booking,
                                                                        'body':
                                                                            S
                                                                                .of(
                                                                                  context,
                                                                                )
                                                                                .coupleRoom_room_order_cancel_success,
                                                                        'type':
                                                                            "1",
                                                                        'payload':
                                                                            '',
                                                                        'userName':
                                                                            currentUser?.bind,
                                                                        'equipmentToken':
                                                                            data['msg'],
                                                                      });
                                                                    }
                                                                  },
                                                                );
                                                                getCoupleOrderList(
                                                                  true,
                                                                );
                                                              },
                                                              fail: (
                                                                code,
                                                                msg,
                                                              ) {
                                                                ProgressHUD.showError(
                                                                  '$msg',
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Text(
                                                            S
                                                                .of(context)
                                                                .coupleRoom_room_booking_confirm,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.all(4.px),
                                              minimumSize: Size(40.px, 20.px),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.px),
                                              ),
                                            ),
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .coupleRoom_room_cancel,
                                              style: TextStyle(fontSize: 12.px),
                                            ),
                                          ),
                                        SizedBox(width: 10.px),
                                        // 确认
                                        if (order.status == 0 &&
                                            currentUser?.bind?.toLowerCase() ==
                                                order.nick?.toLowerCase())
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (
                                                          context,
                                                        ) => AlertDialog(
                                                          title: Text(
                                                            S
                                                                .of(context)
                                                                .coupleRoom_room_confirm_order,
                                                          ),
                                                          content: Text(
                                                            S
                                                                .of(context)
                                                                .coupleRoom_room_confirm_content,
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Text(
                                                                S
                                                                    .of(context)
                                                                    .coupleRoom_room_cancel,
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                DataUtils.confirmCoupleOrder(
                                                                  {
                                                                    'orderId':
                                                                        order.id
                                                                            .toString(),
                                                                    'status': 1,
                                                                  },
                                                                  success: (
                                                                    data,
                                                                  ) {
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                    ProgressHUD.showSuccess(
                                                                      S
                                                                          .of(
                                                                            context,
                                                                          )
                                                                          .coupleRoom_room_confirm_success,
                                                                    );

                                                                    // 发送通知
                                                                    DataUtils.getUserInfoByUsername(
                                                                      currentUser
                                                                          ?.bind,
                                                                      success: (
                                                                        data,
                                                                      ) {
                                                                        if (data['msg'] !=
                                                                            null) {
                                                                          DataUtils.sendOneMessage({
                                                                            'title':
                                                                                S
                                                                                    .of(
                                                                                      context,
                                                                                    )
                                                                                    .coupleRoom_room_booking,
                                                                            'body':
                                                                                S
                                                                                    .of(
                                                                                      context,
                                                                                    )
                                                                                    .coupleRoom_room_booking_body,
                                                                            'type':
                                                                                "1",
                                                                            'payload':
                                                                                '',
                                                                            'userName':
                                                                                currentUser?.bind,
                                                                            'equipmentToken':
                                                                                data['msg'],
                                                                          });
                                                                        }
                                                                      },
                                                                    );
                                                                    getCoupleOrderList(
                                                                      true,
                                                                    );
                                                                  },
                                                                  fail: (
                                                                    code,
                                                                    msg,
                                                                  ) {
                                                                    ProgressHUD.showError(
                                                                      S.of(context).coupleRoom_room_confirm_fail +
                                                                          ' $msg',
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Text(
                                                                S
                                                                    .of(context)
                                                                    .coupleRoom_room_confirm_order,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      secondaryColor,
                                                  foregroundColor: Colors.white,
                                                  padding: EdgeInsets.all(4.px),
                                                  minimumSize: Size(
                                                    40.px,
                                                    20.px,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8.px,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  S
                                                      .of(context)
                                                      .coupleRoom_room_confirm_order,
                                                  style: TextStyle(
                                                    fontSize: 12.px,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.px),
                                            ],
                                          ),
                                        // 查看
                                        ElevatedButton(
                                          onPressed: () {
                                            RouteUtils.push(
                                              context,
                                              CoupleOrderDetailPage(
                                                orderId: order.id.toString(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.all(4.px),
                                            minimumSize: Size(40.px, 20.px),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.px),
                                            ),
                                          ),
                                          child: Text(
                                            S.of(context).coupleRoom_room_view,
                                            style: TextStyle(fontSize: 12.px),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      : EmptyView(),
            ),
          ),
        ],
      ),
    );
  }
}

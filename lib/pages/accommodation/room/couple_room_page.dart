import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/couple_room_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// 夫妻房提交订单
class CoupleRoomPage extends StatefulWidget {
  @override
  _CoupleRoomPageState createState() => _CoupleRoomPageState();
}

class _CoupleRoomPageState extends State<CoupleRoomPage> {
  // 夫妻房订单列表
  List<CoupleRoomModel> coupleRoomList = [];
  // 搜索框控制器
  TextEditingController _searchController = TextEditingController();

  // 刷新控制器
  late RefreshController _refreshController;

  // 是否加载中
  bool _isLoading = false;
  // 可入住日期,默认明天,格式为yyyy-MM-dd
  String _checkInDate =
      DateTime.now().add(Duration(days: 1)).toLocal().toString().split(' ')[0];

  // 当前登录用户
  CoupleStaffListModel? currentUser;
  UserInfoModel? userInfo;

  Future<void> _fetchData() async {
    // 模拟异步数据获取
    var userInfoData = await SpUtils.getModel('userInfo');
    // 更新状态
    setState(() {
      if (userInfoData != null) {
        userInfo = UserInfoModel.fromJson(userInfoData);
        _fetchCurrentUser(userInfo?.user?.userName ?? '');
      }
    });
  }

  Future<void> _fetchCurrentUser(String userName) async {
    var userInfoData = await SpUtils.getModel('userInfo');
    userInfo = UserInfoModel.fromJson(userInfoData);
    if (userInfoData != null) {
      userName = userInfo?.user?.userName ?? '';
    }

    DataUtils.getCoupleStaffList(
      {'username': userName},
      success: (data) {
        setState(() {
          currentUser = CoupleStaffListModel.fromJson(data['rows'][0]);
        });
      },
    );
  }

  // 过滤掉退房日期大于明天的房间
  List<CoupleRoomModel> filterCoupleRoomList(List<CoupleRoomModel> list) {
    final now = DateTime.now();
    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1)); // 明天 00:00

    return list.where((e) {
      if (e.lastTime == null) return false;
      final lastTimeDate = DateTime.parse(e.lastTime!); // 转成 DateTime
      // lastTime 在 明天后 的，不能预定
      return !lastTimeDate.isAfter(tomorrow) &&
          e.isSubmit == false; // 保留 明天及更早退房的
    }).toList();
  }

  // 获取房间列表
  Future<void> getCoupleRoomList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DataUtils.getCoupleRoomList(
        {
          'pageNum': 1,
          'pageSize': 1000,
          'status': 0,
          'name': _searchController.text,
        },
        success: (data) {
          setState(() {
            var coupleRoomList = data['rows'] as List;
            if (coupleRoomList.isNotEmpty) {
              List<CoupleRoomModel> rows =
                  coupleRoomList
                      .map((i) => CoupleRoomModel.fromJson(i))
                      .toList();

              if (rows.isNotEmpty) {
                // 过滤掉退房日期大于明天的房间
                this.coupleRoomList = filterCoupleRoomList(rows);
              } else {
                this.coupleRoomList = [];
              }
            } else {
              this.coupleRoomList = [];
            }
            _refreshController.loadNoData();
            _isLoading = false;
          });
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

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _fetchData();
    getCoupleRoomList();
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
        title: Text(
          S.of(context).coupleRoom_room_booking,
          style: TextStyle(fontSize: 16.px),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
        child: Column(
          children: [
            // 搜索框
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
                        onPressed: () => getCoupleRoomList(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 10.px),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.px),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          S.of(context).coupleRoom_room_search,
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
            SizedBox(height: 12.px),
            // 房间卡片列表
            Expanded(
              child:
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : coupleRoomList.isNotEmpty
                      ? SmartRefreshWidget(
                        enablePullDown: true,
                        enablePullUp: true,
                        onRefresh: () {
                          getCoupleRoomList().then((value) {
                            _refreshController.refreshCompleted();
                          });
                        },
                        onLoading: () {
                          getCoupleRoomList();
                        },
                        controller: _refreshController,
                        child: ListView.builder(
                          itemCount: coupleRoomList.length,
                          itemBuilder: (context, index) {
                            final room = coupleRoomList[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 16.px),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.px),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.px,
                                  vertical: 4.px,
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
                                          room.name ?? '',
                                          style: TextStyle(
                                            fontSize: 15.px,
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(),
                                        TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.blue,
                                            textStyle: TextStyle(
                                              fontSize: 14.px,
                                            ),
                                          ),
                                          child: Text(
                                            S.current.coupleRoom_room_available,
                                            style: TextStyle(
                                              fontSize: 14.px,
                                              color: secondaryColor,
                                            ),
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
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    Text(
                                      '${S.current.coupleRoom_room_check_out_time}:${room.lastTime ?? ''}',
                                      style: TextStyle(
                                        fontSize: 13.px,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      '${S.current.coupleRoom_room_check_in_time}:${_checkInDate}',
                                      style: TextStyle(
                                        fontSize: 13.px,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      '${S.current.coupleRoom_room_available_days}:3${S.current.coupleRoom_room_days}',
                                      style: TextStyle(
                                        fontSize: 13.px,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      '${S.current.coupleRoom_room_price}:200${S.current.coupleRoom_room_price_unit}',
                                      style: TextStyle(
                                        fontSize: 13.px,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      '${S.current.coupleRoom_room_booking_remark}:${room.remark ?? ''}',
                                      style: TextStyle(
                                        fontSize: 13.px,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 4.px,
                                      ),
                                      child: Divider(
                                        height: 1.px,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            showBookRoomDialog(
                                              context,
                                              room.name ?? '',
                                              _checkInDate,
                                              room.areaType ?? 1,
                                              getCoupleRoomList,
                                              currentUser?.bind ?? '',
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
                                            S
                                                .current
                                                .coupleRoom_room_booking_book,
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
          ],
        ),
      ),
    );
  }
}

// 预订房间弹窗
void showBookRoomDialog(
  BuildContext context,
  String roomNo,
  String defaultDate,
  int areaType,
  Function getCoupleRoomList,
  String nick,
) {
  final _formKey = GlobalKey<FormState>();
  TextEditingController roomController = TextEditingController(text: roomNo);
  // 明天、后天、大后天日期
  DateTime tomorrow = DateTime.now().add(Duration(days: 1));
  DateTime day2 = tomorrow.add(Duration(days: 1));
  DateTime day3 = tomorrow.add(Duration(days: 2));
  String tomorrowStr =
      "${tomorrow.year.toString().padLeft(4, '0')}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}";
  String day2Str =
      "${day2.year.toString().padLeft(4, '0')}-${day2.month.toString().padLeft(2, '0')}-${day2.day.toString().padLeft(2, '0')}";
  String day3Str =
      "${day3.year.toString().padLeft(4, '0')}-${day3.month.toString().padLeft(2, '0')}-${day3.day.toString().padLeft(2, '0')}";
  List<String> dateOptions = [tomorrowStr, day2Str, day3Str];
  List<bool> selected = [true, false, false]; // 默认选中明天
  TextEditingController checkInController = TextEditingController(
    text: tomorrowStr,
  );
  TextEditingController checkOutController = TextEditingController(
    text: tomorrowStr,
  );
  TextEditingController remarkController = TextEditingController();

  // 多选弹窗
  Future<void> showMultiDatePicker() async {
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.current.coupleRoom_room_booking_select_date,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (i) {
                  return ChoiceChip(
                    label: Text(dateOptions[i]),
                    selected: selected[i],
                    selectedColor: primaryColor,
                    labelStyle: TextStyle(
                      color: selected[i] ? Colors.white : Colors.black,
                    ),
                    onSelected: (v) {
                      // 只能从明天起连续选1~3天
                      if (i == 0) {
                        // 明天被取消，全部取消
                        if (!selected[0]) {
                          selected[0] = true;
                        } else {
                          selected[0] = false;
                          selected[1] = false;
                          selected[2] = false;
                        }
                      } else if (i == 1) {
                        if (!selected[1]) {
                          // 只能在明天已选时选后天
                          if (selected[0]) selected[1] = true;
                        } else {
                          // 取消后天则大后天也取消
                          selected[1] = false;
                          selected[2] = false;
                        }
                      } else if (i == 2) {
                        // 只能在明天和后天都选时选大后天
                        if (!selected[2]) {
                          if (selected[0] && selected[1]) selected[2] = true;
                        } else {
                          selected[2] = false;
                        }
                      }
                      // 更新UI
                      (ctx as Element).markNeedsBuild();
                    },
                  );
                }),
              ),
              SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    // 至少选中明天
                    if (!selected[0]) return;
                    // 更新输入框内容
                    List<String> chosen = [];
                    for (int i = 0; i < 3; i++) {
                      if (selected[i]) chosen.add(dateOptions[i]);
                    }
                    checkOutController.text = chosen.join('、');
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(S.current.coupleRoom_room_booking_confirm),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.px,
          right: 16.px,
          top: 16.px,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 房间编号
                Row(
                  children: [
                    Text('*', style: TextStyle(color: primaryColor)),
                    Text(
                      S.of(context).coupleRoom_room_number,
                      style: TextStyle(fontSize: 14.px),
                    ),
                  ],
                ),
                SizedBox(height: 6.px),
                TextFormField(
                  controller: roomController,
                  enabled: false,
                  style: TextStyle(fontSize: 12.px),
                  decoration: InputDecoration(
                    hintText: S.of(context).coupleRoom_room_number,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.px,
                      vertical: 10.px,
                    ),
                  ),
                ),
                SizedBox(height: 12.px),
                // 入住时间（请示日期）
                Row(
                  children: [
                    Text('*', style: TextStyle(color: primaryColor)),
                    Text(
                      S.current.coupleRoom_room_check_in_time,
                      style: TextStyle(fontSize: 14.px),
                    ),
                  ],
                ),
                SizedBox(height: 6.px),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  controller: checkInController,
                  style: TextStyle(fontSize: 12.px),
                  decoration: InputDecoration(
                    hintText: S.current.coupleRoom_room_check_in_time,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.px,
                      vertical: 10.px,
                    ),
                  ),
                  validator:
                      (v) =>
                          v == null || v.isEmpty
                              ? S.current.coupleRoom_room_check_in_time
                              : null,
                ),
                SizedBox(height: 12.px),
                // 入住日期（实际入住）
                Row(
                  children: [
                    Text('*', style: TextStyle(color: primaryColor)),
                    Text(
                      S.current.coupleRoom_room_check_in_date,
                      style: TextStyle(fontSize: 14.px),
                    ),
                  ],
                ),
                SizedBox(height: 6.px),
                GestureDetector(
                  onTap: showMultiDatePicker,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: checkOutController,
                      readOnly: true,
                      style: TextStyle(fontSize: 12.px),
                      decoration: InputDecoration(
                        hintText: S.current.coupleRoom_room_check_in_date,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.px,
                          vertical: 10.px,
                        ),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? S.current.coupleRoom_room_check_in_date
                                  : null,
                    ),
                  ),
                ),
                SizedBox(height: 12.px),
                // 备注信息
                Row(
                  children: [
                    Text(
                      S.current.coupleRoom_room_booking_remark,
                      style: TextStyle(fontSize: 14.px),
                    ),
                  ],
                ),
                SizedBox(height: 6.px),
                TextFormField(
                  controller: remarkController,
                  maxLines: 5,
                  style: TextStyle(fontSize: 12.px),
                  decoration: InputDecoration(
                    hintText: S.current.coupleRoom_room_booking_remark,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.px,
                      vertical: 10.px,
                    ),
                  ),
                ),
                SizedBox(height: 20.px),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final checkOutDate = checkOutController.text.split('、');
                        // 调用接口
                        DataUtils.bookCoupleRoom(
                          {
                            'chamberName': roomNo,
                            'day': checkOutDate.length,
                            'startTime': checkInController.text,
                            'endTime': DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(
                                checkOutDate.last,
                              ).add(Duration(days: 1)),
                            ),
                            'remark': remarkController.text,
                            'areaType': areaType,
                          },
                          success: (data) {
                            // 提交逻辑
                            Navigator.pop(context);
                            ProgressHUD.showSuccess(
                              S.current.coupleRoom_room_booking_submit_success,
                            );
                            // 发送通知
                            DataUtils.getUserInfoByUsername(
                              nick,
                              success: (data) {
                                if (data['msg'] != null) {
                                  DataUtils.sendOneMessage({
                                    'title': S.current.coupleRoom_room_booking,
                                    'body':
                                        S.current.coupleRoom_room_booking_body,
                                    'type': "1",
                                    'payload': '',
                                    'userName': nick,
                                    'equipmentToken': data['msg'],
                                  });
                                }
                              },
                            );
                            // 刷新列表
                            getCoupleRoomList();
                          },
                          fail: (code, msg) {
                            print(code);
                            print(msg);
                            Navigator.pop(context);
                            ProgressHUD.showError(msg);
                          },
                        );
                      }
                    },

                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        primaryColor[500],
                      ),
                      minimumSize: MaterialStateProperty.all(
                        Size(double.infinity, 40.px),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.px),
                        ),
                      ),
                    ),
                    child: Text(
                      S.current.coupleRoom_room_booking_submit,
                      style: TextStyle(fontSize: 16.px, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16.px),
              ],
            ),
          ),
        ),
      );
    },
  );
}

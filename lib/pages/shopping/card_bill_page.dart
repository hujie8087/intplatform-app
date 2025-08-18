import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/http_utils.dart';
import 'package:logistics_app/http/model/card_info_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class CardBillPage extends StatefulWidget {
  const CardBillPage({Key? key}) : super(key: key);

  @override
  _CardBillPageState createState() => _CardBillPageState();
}

class _CardBillPageState extends State<CardBillPage> {
  DateTime _startDate = DateTime.now().subtract(Duration(days: 1));
  DateTime _endDate = DateTime.now();
  List<BillModel> _bills = [];
  bool _isLoading = false;
  UserInfoModel? userInfo;

  @override
  void initState() {
    super.initState();
    _fetchBills();
  }

  Future<void> _fetchData() async {
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    }
  }

  Future<void> _fetchBills() async {
    await _fetchData();
    setState(() {
      _isLoading = true;
    });

    try {
      final startDateStr = DateFormat('yyyy-MM-dd').format(_startDate);
      final endDateStr = DateFormat('yyyy-MM-dd').format(_endDate);
      HttpUtils.post(
        APIs.getBill,
        {
          'startDealTime': startDateStr,
          'endDealTime': endDateStr,
          'start': 1,
          'limit': 100,
          'uniqueId': userInfo?.user?.userName,
        },
        success: (data) {
          if (data['data']['list'] != null) {
            _bills = (data['data']['list'] as List)
                .map((item) => BillModel.fromJson(item))
                .toList();
          } else {
            _bills = [];
          }

          setState(() {});
        },
        fail: (code, msg) {
          print('Error fetching bills: $msg');
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).cardBill, style: TextStyle(fontSize: 16.px)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 日期选择区域
          Container(
            padding: EdgeInsets.only(left: 14.px, right: 14.px, bottom: 14.px),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.px),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4.px),
                      ),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(_startDate),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.px),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.px),
                  child: Text(
                    S.of(context).to,
                    style: TextStyle(fontSize: 12.px),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.px),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4.px),
                      ),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(_endDate),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.px),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.px),
                ElevatedButton(
                  onPressed: _fetchBills,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text(
                    S.of(context).search,
                    style: TextStyle(fontSize: 12.px),
                  ),
                ),
              ],
            ),
          ),

          // 账单列表
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _bills.isEmpty
                    ? Center(child: Text(S.of(context).noData))
                    : GroupedListView<BillModel, String>(
                        elements: _bills,
                        groupBy: (bill) => DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(bill.dealTime ?? '')),
                        groupSeparatorBuilder: (String date) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.px, vertical: 6.px),
                          color: Colors.grey[100],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                date,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.px,
                                ),
                              ),
                              Text(
                                S.of(context).expenditure +
                                    ':${_calculateDailyTotal(date)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.px,
                                ),
                              ),
                            ],
                          ),
                        ),
                        itemBuilder: (context, BillModel bill) {
                          return Container(
                            padding: EdgeInsets.all(14.px),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[200]!,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bill.deviceName ?? '',
                                        style: TextStyle(
                                          fontSize: 12.px,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4.px),
                                      Text(
                                        bill.businessName ?? '',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10.px,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        DateFormat('HH:mm').format(
                                            DateTime.parse(
                                                bill.dealTime ?? '')),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10.px,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${bill.monDeal ?? '0'}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16.px,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        order: GroupedListOrder.DESC,
                      ),
          ),
        ],
      ),
    );
  }

  void _selectDate(bool isStart) {
    DatePicker.showDatePicker(
      context,
      currentTime: isStart ? _startDate : _endDate,
      maxTime: DateTime.now(),
      locale: LocaleType.zh,
      onConfirm: (date) {
        setState(() {
          if (isStart) {
            _startDate = date;
            if (_startDate.isAfter(_endDate)) {
              _endDate = _startDate;
            }
          } else {
            _endDate = date;
            if (_endDate.isBefore(_startDate)) {
              _startDate = _endDate;
            }
          }
        });
      },
    );
  }

  double _calculateDailyTotal(String date) {
    return _bills
        .where((bill) =>
            DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(bill.dealTime ?? '')) ==
            date)
        .fold(0, (sum, bill) => sum + (double.parse(bill.monDeal ?? '0')));
  }
}

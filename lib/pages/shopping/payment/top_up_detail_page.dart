import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/top_up_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class TopUpDetailPage extends StatefulWidget {
  final TopUpMonthModel topUpMonthModel;
  const TopUpDetailPage({Key? key, required this.topUpMonthModel})
    : super(key: key);

  @override
  _TopUpDetailPageState createState() => _TopUpDetailPageState();
}

class _TopUpDetailPageState extends State<TopUpDetailPage> {
  final RefreshController _refreshController = RefreshController();
  int _pageNum = 1;
  final int _pageSize = 10;
  List<TopUpDetailModel> _dataList = [];

  @override
  void initState() {
    super.initState();
    _requestData(isLoadMore: false);
  }

  void _requestData({bool isLoadMore = false}) {
    if (!isLoadMore) {
      _pageNum = 1;
    } else {
      _pageNum++;
    }

    DataUtils.getData(
      APIs.getUserRechargeRecordDetail,
      {
        'current': _pageNum,
        'size': _pageSize,
        'yearMonth': widget.topUpMonthModel.yearMonth,
      },
      success: (data) {
        var rows = data['data']['list'];
        List<TopUpDetailModel> list = [];
        if (rows != null) {
          list =
              (rows as List).map((e) => TopUpDetailModel.fromJson(e)).toList();
        }

        if (mounted) {
          setState(() {
            if (!isLoadMore) {
              _dataList = list;
              _refreshController.refreshCompleted();
              if (list.length < _pageSize) {
                _refreshController.loadNoData();
              } else {
                _refreshController.resetNoData();
              }
            } else {
              _dataList.addAll(list);
              if (list.length < _pageSize) {
                _refreshController.loadNoData();
              } else {
                _refreshController.loadComplete();
              }
            }
          });
        }
      },
      fail: (code, msg) {
        if (mounted) {
          if (!isLoadMore) {
            _refreshController.refreshFailed();
          } else {
            _refreshController.loadFailed();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).recharge_record,
          style: TextStyle(fontSize: 16.px, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.px),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SmartRefreshWidget(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () => _requestData(isLoadMore: false),
        onLoading: () => _requestData(isLoadMore: true),
        child:
            _dataList.isEmpty
                ? EmptyView()
                : ListView.builder(
                  padding: EdgeInsets.all(12.px),
                  itemCount: _dataList.length,
                  itemBuilder: (context, index) {
                    return _buildItem(_dataList[index]);
                  },
                ),
      ),
    );
  }

  Widget _buildItem(TopUpDetailModel item) {
    // 建议加上 null 检查和 0 检查
    final rawAmount = item.amount ?? 0;
    final rate = widget.topUpMonthModel.exchangeRate ?? 0;

    // 计算结果
    double amount = (rate != 0) ? (rawAmount * 1000 / rate) : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.px),
      child: InkWell(
        onTap: () {
          print(item);
        },
        borderRadius: BorderRadius.circular(8.px),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.px),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(16.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name ?? '',
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '充值积分：',
                      style: TextStyle(
                        fontSize: 10.px,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    Text(
                      '${item.amount ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.px),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            S.of(context).account,
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            item.account?.toString() ?? '',
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '人民币：',
                      style: TextStyle(
                        fontSize: 10.px,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      amount.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                        color: primaryColor[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.px),
                Row(
                  children: [
                    Text(
                      S.of(context).month + ':',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      item.yearMonth ?? '',
                      style: TextStyle(fontSize: 12.px, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 4.px),
                Row(
                  children: [
                    Text(
                      S.of(context).time + ':',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      item.createTime?.replaceAll('T', ' ') ?? '',
                      style: TextStyle(fontSize: 12.px, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 4.px),
                Row(
                  children: [
                    Text(
                      '单号：',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      item.no ?? '',
                      style: TextStyle(fontSize: 12.px, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 4.px),
                Row(
                  children: [
                    Text(
                      '薪资扣除月份：',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      item.deductedMonths ?? '',
                      style: TextStyle(fontSize: 12.px, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 4.px),
                Row(
                  children: [
                    Text(
                      '当月汇率：',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      widget.topUpMonthModel.exchangeRate.toString(),
                      style: TextStyle(fontSize: 12.px, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/top_up_model.dart';
import 'package:logistics_app/pages/shopping/payment/top_up_detail_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class TopUpListPage extends StatefulWidget {
  const TopUpListPage({Key? key}) : super(key: key);

  @override
  _TopUpListPageState createState() => _TopUpListPageState();
}

class _TopUpListPageState extends State<TopUpListPage> {
  final RefreshController _refreshController = RefreshController();
  int _pageNum = 1;
  final int _pageSize = 10;
  List<TopUpMonthModel> _dataList = [];

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
      APIs.getUserRechargeRecord,
      {'current': _pageNum, 'size': _pageSize},
      success: (data) {
        var rows = data['data']['list'];
        List<TopUpMonthModel> list = [];
        if (rows != null) {
          list =
              (rows as List).map((e) => TopUpMonthModel.fromJson(e)).toList();
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

  Widget _buildItem(TopUpMonthModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.px),
      child: InkWell(
        onTap: () {
          RouteUtils.push(
            context,
            TopUpDetailPage(yearMonth: item.yearMonth ?? ''),
          );
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
            margin: EdgeInsets.only(bottom: 12.px),
            padding: EdgeInsets.all(16.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.yearMonth ?? '',
                      style: TextStyle(
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.px,
                        vertical: 2.px,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.px),
                      ),
                      child: Text(
                        item.currency ?? '',
                        style: TextStyle(fontSize: 12.px, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.px),
                Row(
                  children: [
                    Text(
                      S.of(context).exchange_rate + ':',
                      style: TextStyle(
                        fontSize: 14.px,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      item.exchangeRate.toString(),
                      style: TextStyle(
                        fontSize: 14.px,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
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

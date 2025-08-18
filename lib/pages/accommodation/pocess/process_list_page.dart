import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:logistics_app/http/model/accommodation_process_model.dart';
import 'package:logistics_app/pages/accommodation/pocess/process_detail_page.dart';

class ProcessListPage extends StatefulWidget {
  @override
  _ProcessListPageState createState() => _ProcessListPageState();
}

class _ProcessListPageState extends State<ProcessListPage> {
  List<AccommodationProcessModel> _dataList = [];
  bool isLoading = true;
  late RefreshController _refreshController;
  int pageNum = 1;
  final int pageSize = 10;
  int totalItems = 0;
  String imagePrefix = APIs.imagePrefix;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _fetchData();
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    if (isLoadMore && _dataList.length >= totalItems) {
      _refreshController.loadNoData();
      return;
    }

    pageNum = isLoadMore ? pageNum + 1 : 1;
    var params = {'pageNum': pageNum, 'pageSize': pageSize, 'status': '2'};

    DataUtils.getAccommodationProcessList(
      params,
      success: (data) {
        setState(() {
          if (isLoadMore) {
            _dataList.addAll(
              (data['rows'] as List)
                  .map((item) => AccommodationProcessModel.fromJson(item))
                  .toList(),
            );
            _refreshController.loadComplete();
          } else {
            _dataList =
                (data['rows'] as List)
                    .map((item) => AccommodationProcessModel.fromJson(item))
                    .toList();
            totalItems = data['total'] ?? 0;
            _refreshController.refreshCompleted();
          }
          isLoading = false;
        });
      },
      fail: (code, msg) {
        if (isLoadMore) {
          _refreshController.loadFailed();
        } else {
          _refreshController.refreshFailed();
        }
        setState(() {
          isLoading = false;
        });
      },
    );
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
          S.of(context).accommodationProcess,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SmartRefreshWidget(
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: () => _fetchData(isLoadMore: false),
                onLoading: () => _fetchData(isLoadMore: true),
                controller: _refreshController,
                child:
                    _dataList.isEmpty
                        ? EmptyView()
                        : ListView.builder(
                          padding: EdgeInsets.all(16.px),
                          itemCount: _dataList.length,
                          itemBuilder: (context, index) {
                            final item = _dataList[index];
                            return _buildAccommodationItem(item);
                          },
                        ),
              ),
    );
  }

  Widget _buildAccommodationItem(AccommodationProcessModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.px),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProcessDetailPage(model: item),
              ),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.px),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 图片
                if (item.img != null)
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.px),
                    ),
                    child: Image.network(
                      imagePrefix + item.img!,
                      width: double.infinity,
                      height: 180.px,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Image.asset('assets/images/empty/空.png'),
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.all(16.px),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      Text(
                        item.title ?? '',
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.px),

                      // 内容
                      Text(
                        item.content ?? '',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // 时间和阅读量
                      SizedBox(height: 12.px),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14.px,
                            color: Colors.grey[400],
                          ),
                          SizedBox(width: 4.px),
                          Text(
                            item.createTime ?? '',
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.grey[400],
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.remove_red_eye,
                            size: 14.px,
                            color: Colors.grey[400],
                          ),
                          SizedBox(width: 4.px),
                          Text(
                            '${item.views ?? 0}',
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

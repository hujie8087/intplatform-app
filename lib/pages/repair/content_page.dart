import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/repair_utils.dart';
import 'package:logistics_app/http/model/repair_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key, this.repairState}) : super(key: key);

  final int? repairState;

  @override
  State<ContentPage> createState() => _HttpPageTestHeaderFollowPageState();
}

class _HttpPageTestHeaderFollowPageState extends State<ContentPage>
    with TickerProviderStateMixin {
  bool get wantKeepAlive => true;
  AnimationController? animationController;

  List<RepairViewModel> _dataArr = [];
  int _pageNum = 1;
  final int _pageSize = 5;
  int _totalItems = 0;

  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _refreshController = RefreshController();
    _requestData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _requestData({isLoadMore = false}) {
    if (isLoadMore && _dataArr.length == _totalItems) {
      _refreshController.loadNoData();
      return;
    }
    _pageNum = isLoadMore ? _pageNum + 1 : 1;
    var params = {
      'pageNum': _pageNum,
      'pageSize': _pageSize,
      'repairState': widget.repairState ?? null,
      'appDelFlag': 0
    };
    RepairUtils.getMyRepairList(
      params,
      success: (data) {
        RowsModel<RepairViewModel> response =
            RowsModel.fromJson(data, (json) => RepairViewModel.fromJson(json));
        if (isLoadMore) {
          setState(() {
            _dataArr = _dataArr + response.rows!;
          });
          _refreshController.loadComplete();
        } else {
          setState(() {
            _dataArr = response.rows ?? [];
            _totalItems = response.total ?? 0;
          });
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        }
      },
      fail: (code, msg) {
        if (isLoadMore) {
          _refreshController.loadComplete();
        } else {
          _refreshController.refreshCompleted();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
        child: SmartRefreshWidget(
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () {
              //关闭刷新
              print('刷新完成');
              _requestData(isLoadMore: false);
            },
            onLoading: () {
              print('加载完成');
              _requestData(isLoadMore: true);
            },
            controller: _refreshController,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: _repairView(),
            )));
  }

  Widget _repairView() {
    return Consumer(
      builder: (context, model, child) {
        if (_dataArr.isEmpty == true) {
          return Center(
            child: Text("暂无数据"),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _dataArr.length,
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            final int count = _dataArr.length;
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController!,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn)));
            animationController?.forward();
            return _repairItem(
              listData: _dataArr[index],
              callBack: () async {
                // 跳转到详情页
                final result = await RouteUtils.pushNamed(
                    context, RoutePath.RepairRatingPage,
                    arguments: {
                      'repairId': _dataArr[index].id,
                      'title': '报修单详情',
                      'isShowButton': _dataArr[index].repairState == 1
                    });
                setState(() {
                  if (result != null && result == 'submit') {
                    _requestData();
                  }
                });
              },
              deleteCallBack: () => {_requestData()},
              animation: animation,
              animationController: animationController,
            );
          },
        );
      },
    );
  }
}

String getRepairStateText(int? repairState) {
  switch (repairState) {
    case 0:
      return '待维修';
    case 1:
      return '已维修';
    case 2:
      return '待返修';
    case 3:
      return '已完结';
    default:
      return '未知状态';
  }
}

Color getRepairStateColor(int? repairState) {
  if (repairState == 1 || repairState == 3) {
    return primaryColor;
  } else {
    return secondaryColor;
  }
}

class _repairItem extends StatelessWidget {
  const _repairItem(
      {Key? key,
      this.listData,
      this.callBack,
      this.deleteCallBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final RepairViewModel? listData;
  final VoidCallback? callBack;
  final VoidCallback? deleteCallBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    List<String> images = [];
    if (listData?.repairPhoto != '') {
      images = listData!.repairPhoto!.split(',');
    }
    return AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 50 * (1.0 - animation!.value), 0.0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: callBack,
                          child: Ink(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: badges.Badge(
                                showBadge: listData?.readStatus == '1',
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(listData?.repairArea ?? '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text('/',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(listData?.roomNo ?? '',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(listData?.createTime ?? '',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey))
                                          ],
                                        )),
                                        SizedBox(width: 10),
                                        // 维修状态
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          child: Text(
                                            getRepairStateText(
                                                listData?.repairState),
                                            style: TextStyle(
                                              color: getRepairStateColor(
                                                  listData?.repairState),
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    HtmlLineLimit(
                                        htmlContent:
                                            listData?.repairMessage ?? ''),
                                    if (images.length > 0)
                                      GridView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6, // 每行显示6张图片
                                          crossAxisSpacing: 8.0,
                                          mainAxisSpacing: 8.0,
                                        ),
                                        itemCount: images.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Image.network(
                                              APIs.imagePrefix + images[index],
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    _dialogWidget(
                                                        context, listData!, () {
                                                      deleteCallBack!();
                                                    }));
                                          },
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                left: Radius.circular(15),
                                                right: Radius.circular(15),
                                              ),
                                            ),
                                            minimumSize: Size(100, 24),
                                            side: BorderSide(
                                                color: secondaryColor,
                                                width: 1),
                                            // 设置边框颜色和宽度
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0,
                                                vertical: 0), // 设置内边距
                                          ),
                                          child: Text(
                                            '删除报修单',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: secondaryColor),
                                          ),
                                        ),
                                        if (listData?.repairState != 0 &&
                                            listData?.rating == null)
                                          SizedBox(
                                            width: 10,
                                          ),
                                        if (listData?.repairState != 0 &&
                                            listData?.rating == null)
                                          // 按钮调整到评价
                                          OutlinedButton(
                                            onPressed: () {
                                              RouteUtils.pushNamed(context,
                                                  RoutePath.RepairRatingPage,
                                                  arguments: {
                                                    'repairId': listData?.id,
                                                    'title': '报修评价',
                                                    'isShowButton': true,
                                                  });
                                            },
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.horizontal(
                                                  left: Radius.circular(15),
                                                  right: Radius.circular(15),
                                                ),
                                              ),
                                              minimumSize: Size(60, 24),
                                              side: BorderSide(
                                                  color: primaryColor,
                                                  width: 1),
                                              // 设置边框颜色和宽度
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0), // 设置内边距
                                            ),
                                            child: Text(
                                              '评价',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: primaryColor),
                                            ),
                                          ),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        )),
                  )));
        });
  }

  Widget _dialogWidget(context, RepairViewModel listData, callback) {
    final RepairViewModel data = listData;
    data.appDelFlag = '1';
    return AlertDialog(
      title: Text('提示'),
      content: Text('确认删除该报修单吗?'),
      actions: <Widget>[
        TextButton(
          child: Text(
            '取消',
            style: TextStyle(color: secondaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            '确定',
            style: TextStyle(color: primaryColor),
          ),
          onPressed: () {
            RepairUtils.editRepairDetail(
              data,
              success: (data) {
                callback();
                Navigator.of(context).pop();
                showToast('删除订单成功');
              },
              fail: (code, msg) {
                showToast(msg);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ],
    );
  }
}

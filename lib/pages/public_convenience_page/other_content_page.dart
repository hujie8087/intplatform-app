import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/other_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OtherContentPage extends StatefulWidget {
  const OtherContentPage({Key? key, this.souceType}) : super(key: key);

  final String? souceType;

  @override
  State<OtherContentPage> createState() => _OtherContentPageState();
}

class _OtherContentPageState extends State<OtherContentPage>
    with TickerProviderStateMixin {
  bool get wantKeepAlive => true;
  AnimationController? animationController;

  List<OtherViewModel> _dataArr = [];
  int _pageNum = 1;
  final int _pageSize = 5;
  int _totalItems = 0;

  late RefreshController _refreshController;
  String imagePrefix = APIs.imagePrefix;

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
      'souceType': widget.souceType ?? null,
    };
    DataUtils.getOtherDataList(
      params,
      success: (data) {
        RowsModel<OtherViewModel> response =
            RowsModel.fromJson(data, (json) => OtherViewModel.fromJson(json));
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
              _requestData(isLoadMore: false);
            },
            onLoading: () {
              _requestData(isLoadMore: true);
            },
            controller: _refreshController,
            child: Padding(
              padding: EdgeInsets.all(10.px),
              child: _otherView(),
            )));
  }

  Widget _otherView() {
    return Consumer(
      builder: (context, model, child) {
        if (_dataArr.isEmpty == true) {
          return EmptyView();
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
            return _otherItem(
                listData: _dataArr[index],
                callBack: () async {
                  // 跳转到详情页
                  final result = await RouteUtils.pushNamed(
                      context, RoutePath.RepairRatingPage,
                      arguments: {
                        'otherId': _dataArr[index].id,
                        'title': '报修单详情',
                        'isShowButton': _dataArr[index].souceType == 1
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
                imagePrefix: imagePrefix);
          },
        );
      },
    );
  }
}

class _otherItem extends StatelessWidget {
  const _otherItem(
      {Key? key,
      this.listData,
      this.callBack,
      this.deleteCallBack,
      this.animationController,
      required this.imagePrefix,
      this.animation})
      : super(key: key);

  final OtherViewModel? listData;
  final VoidCallback? callBack;
  final VoidCallback? deleteCallBack;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String imagePrefix;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 50.px * (1.0 - animation!.value), 0.0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.px),
                    child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.px),
                        child: InkWell(
                          onTap: callBack,
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // 超出隐藏
                              borderRadius: BorderRadius.circular(10.px),
                            ),
                            child: Row(
                              children: [
                                if (listData?.image != null)
                                  Container(
                                    width: 100.px,
                                    height: 100.px,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.px),
                                          bottomLeft: Radius.circular(10.px)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            imagePrefix + listData!.image!),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  width: 10.px,
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(listData?.showTitle ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.px,
                                            fontWeight: FontWeight.bold)),
                                    Text(listData?.region ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.px,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 5.px,
                                    ),
                                    Text(listData?.createTime ?? '',
                                        style: TextStyle(
                                            fontSize: 10.px,
                                            color: Colors.grey))
                                  ],
                                )),
                              ],
                            ),
                          ),
                        )),
                  )));
        });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/other_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/pages/public_convenience_page/public_detail_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicListPage extends StatefulWidget {
  const PublicListPage({Key? key, this.souceType, this.title})
      : super(key: key);

  final String? souceType;
  final String? title;

  @override
  State<PublicListPage> createState() => _PublicListPageState();
}

class _PublicListPageState extends State<PublicListPage>
    with TickerProviderStateMixin {
  bool get wantKeepAlive => true;
  AnimationController? animationController;

  List<OtherViewModel> _dataArr = [];
  int _pageNum = 1;
  final int _pageSize = 10;
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
      appBar: AppBar(
        title: Text(widget.title ?? '', style: TextStyle(fontSize: 16.px)),
      ),
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
                typeName: widget.title,
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
      this.typeName,
      this.animationController,
      required this.imagePrefix,
      this.animation})
      : super(key: key);

  final OtherViewModel? listData;
  final String? typeName;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String imagePrefix;

  void launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch phone call';
      }
    } catch (e) {
      print('Error launching phone call: $e');
      // 可以在这里添加错误提示
      ProgressHUD.showError('无法拨打电话：$phoneNumber');
    }
  }

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
                          onTap: () {
                            RouteUtils.push(
                                context,
                                PublicDetailPage(
                                    listData: listData ?? OtherViewModel()));
                          },
                          child: Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // 标题
                                        Text(
                                          listData?.showTitle ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.px,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.px, vertical: 2.px),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius:
                                                BorderRadius.circular(4.px),
                                          ),
                                          child: Text(
                                            listData?.region ?? '',
                                            style: TextStyle(
                                              fontSize: 12.px,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.px),

                                    // 类型和负责人
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Text('负责人：',
                                                style: TextStyle(
                                                    fontSize: 10.px,
                                                    color: Colors.grey[600])),
                                            Text(listData?.head ?? '',
                                                style: TextStyle(
                                                    fontSize: 12.px,
                                                    color: primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.px),
                                    // 联系电话
                                    Row(
                                      children: [
                                        Icon(Icons.phone,
                                            size: 14.px,
                                            color: Colors.grey[600]),
                                        SizedBox(width: 4.px),
                                        // 点击拨打电话
                                        InkWell(
                                          onTap: () => {
                                            // 拨打电话
                                            launchPhone(
                                                listData?.telephone ?? '')
                                          },
                                          child: Text(
                                            listData?.telephone ?? '',
                                            style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.px),
                                    // 营业时间
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 14.px,
                                            color: Colors.grey[600]),
                                        SizedBox(width: 4.px),
                                        Expanded(
                                          child: Text(
                                            listData?.businessHours ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.px,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.px),

                                    // 所在区域
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 14.px,
                                            color: Colors.grey[600]),
                                        SizedBox(width: 4.px),
                                        Text(
                                          listData?.address ?? '',
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.px),
                                  ],
                                )),
                              ],
                            ),
                          )),
                    ),
                  )));
        });
  }
}

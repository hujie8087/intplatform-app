import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/bus_line_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/pages/route_query_page/route_query_detail.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RouteQueryPage extends StatefulWidget {
  const RouteQueryPage({Key? key}) : super(key: key);

  @override
  _RouteQueryPage createState() => _RouteQueryPage();
}

class _RouteQueryPage extends State<RouteQueryPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<BusLineModel> busLineList = [];

  int pageNum = 1;
  int pageSize = 10;
  late RefreshController _refreshController;
  String imagePath = 'assets/images/generalMap.webp';
  String imageNetworkPath = '';

  @override
  void initState() {
    _refreshController = RefreshController();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    super.initState();
    // 初始化时加载数据
    getBusLineList(true);
  }

  @override
  void dispose() {
    animationController?.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  void _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: PhotoView(
              imageProvider:
                  imageNetworkPath != ''
                      ? NetworkImage(APIs.imagePrefix + imageNetworkPath)
                      : AssetImage(imagePath),
              backgroundDecoration: BoxDecoration(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('线路查询', style: TextStyle(fontSize: 16.px)),
              centerTitle: true,
              backgroundColor: Colors.white,
              pinned: true, // 保持AppBar始终可见
              expandedHeight: 200.0, // 展开高度，根据图片需要调整
              flexibleSpace: FlexibleSpaceBar(
                background: GestureDetector(
                  onTap: () {
                    _showFullScreenImage(context);
                  },
                  child:
                      imageNetworkPath != ''
                          ? Image.network(
                            APIs.imagePrefix + imageNetworkPath,
                            fit: BoxFit.cover,
                          )
                          : Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false, // 因为SliverAppBar已经提供了安全区域，所以这里不需要顶部安全区域
          child: Container(
            margin: EdgeInsets.only(top: 15.px),
            child:
                busLineList.length == 0
                    ? EmptyView()
                    : SmartRefreshWidget(
                      enablePullDown: true,
                      enablePullUp: true,
                      onRefresh: () {
                        //关闭刷新
                        getBusLineList(true).then((value) {
                          _refreshController.refreshCompleted();
                          // 刷新完成
                          animationController?.forward();
                        });
                      },
                      onLoading: () async {
                        await getBusLineList(false);
                      },
                      controller: _refreshController,
                      child: BusLineListView(),
                    ),
          ),
        ),
      ),
    );
  }

  Widget BusLineListView() {
    if (busLineList.isEmpty) {
      return EmptyView();
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: busLineList.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        if (index >= busLineList.length) {
          return SizedBox.shrink();
        }

        final int count = busLineList.length;
        final Animation<double> animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController!,
            curve: Interval(
              (1 / count) * index,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        );

        return BusLineView(
          animation: animation,
          animationController: animationController,
          listData: busLineList[index],
          callBack: (busSite) {
            RouteUtils.push(
              context,
              RouteQueryDetail(listData: busLineList[index], busSite: busSite),
            );
          },
        );
      },
    );
  }

  Future<void> getBusLineList(bool isRefresh) async {
    if (isRefresh) {
      setState(() {
        busLineList = [];
        pageNum = 1;
      });
      // 重置动画控制器
      if (animationController?.isAnimating ?? false) {
        animationController?.stop();
      }
      animationController?.reset();
    } else {
      pageNum++;
    }

    var params = {'pageNum': pageNum, 'pageSize': pageSize};
    Loading.showLoading();
    DataUtils.getPageList(
      '/other/line/list',
      params,
      success: (data) {
        RowsModel rowsModel = RowsModel.fromJson(
          data,
          (json) => BusLineModel.fromJson(json),
        );
        if (rowsModel.rows != null) {
          var foundList = data['rows'] as List;
          List<BusLineModel> rows =
              foundList.map((i) => BusLineModel.fromJson(i)).toList();
          setState(() {
            if (busLineList.isEmpty) {
              busLineList = rows;
              if (rows[0].allPath != null) {
                imageNetworkPath = rows[0].allPath ?? '';
              }
            } else {
              busLineList.addAll(rows);
            }

            if (rowsModel.total == busLineList.length) {
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
          });

          // 在数据加载完成后启动动画
          if (busLineList.isNotEmpty) {
            // 使用 Future.microtask 确保在下一帧执行动画
            Future.microtask(() {
              if (mounted) {
                animationController?.forward();
              }
            });
          }
        }
        Loading.dismissAll();
      },
      fail: (code, msg) {
        Loading.dismissAll();
      },
    );
  }
}

class BusLineView extends StatelessWidget {
  const BusLineView({
    Key? key,
    this.listData,
    this.callBack,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final BusLineModel? listData;
  final Function(List<CarSiteList>)? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    // 复制一份新的 list，避免直接在原 list 上操作
    List<CarSiteList> busSite = List.from(listData!.carSiteList ?? []);

    if (listData!.lineType == 2) {
      // 往返，增加倒叙的原数组（重新复制后添加，删除第一个）
      final reversedList = listData!.carSiteList!.reversed.toList();
      if (reversedList.isNotEmpty) {
        reversedList.removeAt(0); // 删除倒序的第一个，即原数组最后一个
      }
      busSite.addAll(reversedList);
    } else if (listData!.lineType == 3) {
      if (listData!.carSiteList!.isNotEmpty) {
        // 环线
        busSite.add(listData!.carSiteList!.first);
      }
    }

    String lastItem = busSite.isNotEmpty ? busSite.last.name ?? '' : '';
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              50 * (1.0 - animation!.value),
              0.0,
            ),
            child: Card(
              margin: EdgeInsets.only(bottom: 10.px, left: 10.px, right: 10.px),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.px),
              ),

              child: AspectRatio(
                aspectRatio: 2,
                child: ClipRRect(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  top: 5,
                                  left: 10,
                                  right: 10,
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(color: primaryColor),
                                child: Row(
                                  children: [
                                    Text(
                                      listData!.lineName ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.px,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    if (listData!.carSiteList!.isNotEmpty)
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              listData!.carSiteList![0].name ??
                                                  '',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.px,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              // 单箭头
                                              Icons.arrow_forward_rounded,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              lastItem,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.px,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              if (listData!.carDepartureTimeList!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/firstStation.png',
                                            width: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            listData!
                                                    .carDepartureTimeList![0]
                                                    .departureTime ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Image.asset(
                                            'assets/images/endStation.png',
                                            width: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            listData!
                                                    .carDepartureTimeList![listData!
                                                            .carDepartureTimeList!
                                                            .length -
                                                        1]
                                                    .departureTime ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom: 20,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: primaryColor,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(busSite.length, (
                                    index,
                                  ) {
                                    // 生成固定数量的项目
                                    return SizedBox(
                                      width: 20.px, // 固定宽度，避免旋转后溢出
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        // 超出不隐藏
                                        clipBehavior: Clip.none,
                                        children: [
                                          // 中文竖排（默认从上往下）
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 10.px,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children:
                                                  busSite[index].name!
                                                      .split('')
                                                      .map(
                                                        (char) => Text(
                                                          char,
                                                          style: TextStyle(
                                                            fontSize: 10.px,
                                                            height: 1,
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ),

                                          // 旋转后的印尼文，固定底部对齐
                                          Positioned(
                                            top: 0.px,
                                            left: 10.px,
                                            child: Transform(
                                              alignment: Alignment.topLeft,
                                              transform:
                                                  Matrix4.identity()..rotateZ(
                                                    90 * 3.1415926535 / 180,
                                                  ),
                                              child: Text(
                                                busSite[index].indonesianName ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 8.px,
                                                ),
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.grey.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                          onTap: () => callBack?.call(busSite),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

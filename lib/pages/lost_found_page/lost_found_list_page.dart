import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/found_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_view_model.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@AppRoute(path: 'lost_found_list_page', name: '失物招领列表页')
class LostFoundListPage extends StatefulWidget {
  const LostFoundListPage({super.key});
  @override
  _LostFoundListPageState createState() => _LostFoundListPageState();
}

class _LostFoundListPageState extends State<LostFoundListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? switchAnimation;
  var model = LostFoundViewModel();
  late RefreshController _refreshController;
  int current = 0;
  String userName = '';
  String createBy = '';

  final List<SwitchType> buttonLabels = [
    SwitchType(S.current.all, 0),
    SwitchType(S.current.lost, 1),
    SwitchType(S.current.found, 2),
    SwitchType(S.current.myRelease, 3),
  ];

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _refreshController = RefreshController();

    switchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 0.3, curve: Curves.fastOutSlowIn),
      ),
    );

    super.initState();
    getUserInfo();
  }

  // 获取用户信息
  void getUserInfo() async {
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      setState(() {
        userName = UserInfoModel.fromJson(userInfoData).user?.userName ?? '';
        createBy = userName;
      });
    }

    // 等待获取列表完成
    model
        .getLostFoundModelList(true)
        .then((value) {
          setState(() {
            if (model.isLoadComplete == true) {
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
          });
        })
        .catchError((error) {
          print('加载失败1111111: $error');
          ProgressHUD.showError(error.toString());
          _refreshController.loadFailed();
        });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  //更新焦点的事件名
  void updateCurrent(int value) {
    setState(() {
      current = value;
      switch (current) {
        case 0:
          model.type = '';
          model.reviewStatus = 1;
          model.createBy = '';
          break;
        case 1:
          model.type = '0';
          model.reviewStatus = 1;
          model.createBy = '';
          break;
        case 2:
          model.type = '1';
          model.reviewStatus = 1;
          model.createBy = '';
          break;
        case 3:
          model.type = '';
          model.reviewStatus = null;
          model.createBy = createBy;
          break;
      }
      model
          .getLostFoundModelList(true)
          .then((value) {
            setState(() {
              if (model.isLoadComplete == true) {
                _refreshController.loadNoData();
              } else {
                _refreshController.loadComplete();
              }
            });
          })
          .catchError((error) {
            print('加载失败1111111: $error');
            ProgressHUD.showError(error.toString());
            _refreshController.loadFailed();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    animationController?.forward();
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            S.current.lostAndFound,
            style: TextStyle(fontSize: 16.px),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // 筛选
                  SwitchTypeView(
                    listData: buttonLabels,
                    callBack: (int value) {
                      updateCurrent(value);
                    },
                    animationController: animationController,
                    animation: switchAnimation,
                    current: current,
                  ),
                  // 添加Expanded让SmartRefreshWidget只在剩余空间内工作
                  Expanded(
                    child: Consumer<LostFoundViewModel>(
                      builder: (context, model, child) {
                        return model.list == null || model.list?.length == 0
                            ? EmptyView()
                            : SmartRefreshWidget(
                              enablePullDown: true,
                              enablePullUp: true,
                              onRefresh: () {
                                //关闭刷新
                                model
                                    .getLostFoundModelList(true)
                                    .then((value) {
                                      _refreshController.refreshCompleted();
                                      if (model.isLoadComplete == true) {
                                        _refreshController.loadNoData();
                                      } else {
                                        _refreshController.loadComplete();
                                      }
                                      // 刷新完成
                                      animationController?.forward();
                                    })
                                    .catchError((error) {
                                      ProgressHUD.showError(error.toString());
                                      _refreshController.refreshFailed();
                                    });
                              },
                              onLoading: () {
                                model
                                    .getLostFoundModelList(false)
                                    .then((value) {
                                      if (model.isLoadComplete == true) {
                                        _refreshController.loadNoData();
                                      } else {
                                        _refreshController.loadComplete();
                                      }
                                    })
                                    .catchError((error) {
                                      ProgressHUD.showError(error.toString());
                                      _refreshController.loadFailed();
                                    });
                              },
                              controller: _refreshController,
                              child: LostFountListView(),
                            );
                      },
                    ),
                  ),
                ],
              ),
              // 固定屏幕的发布按钮
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    final result = await RouteUtils.pushNamed(
                      context,
                      'lost_found_detail_page',
                    );
                    if (result != null && result['success'] == true) {
                      setState(() {
                        model.getLostFoundModelList(true);
                        animationController?.forward();
                        ProgressHUD.showSuccess(result['msg']);
                      });
                    }
                  },
                  // 背景设置为白色
                  backgroundColor: primaryColor,
                  // 设置文字颜色
                  foregroundColor: secondaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.add, size: 36.px)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget LostFountListView() {
    return Consumer<LostFoundViewModel>(
      builder: (context, model, child) {
        return ListView.builder(
          shrinkWrap: true,
          // 移除NeverScrollableScrollPhysics，允许在SmartRefreshWidget内滚动
          physics: NeverScrollableScrollPhysics(),
          itemCount: model.list?.length ?? 0,
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            final int count = model.list?.length ?? 0;
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
            animationController?.forward();
            return LostFoundView(
              listData: model.list?[index],
              animation: animation,
              animationController: animationController,
              userName: userName,
              current: current,
              model: model,
            );
          },
        );
      },
    );
  }
}

class LostFoundView extends StatelessWidget {
  const LostFoundView({
    Key? key,
    this.listData,
    this.animationController,
    this.galleryItems,
    this.animation,
    this.userName,
    this.current,
    this.model,
  }) : super(key: key);
  final List<String>? galleryItems;
  final FoundModel? listData;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? userName;
  final int? current;
  final LostFoundViewModel? model;

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              margin: EdgeInsets.only(bottom: 8.px),
              padding: EdgeInsets.only(left: 8.px, right: 8.px),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.px),
                child: Container(
                  margin: EdgeInsets.all(5.px),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.px),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.px,
                          vertical: 10.px,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 110.px,
                              child: GridView.builder(
                                // 禁止滚动
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                itemCount:
                                    listData?.photo?.split(',').length ?? 0,
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        8.px,
                                      ), // 圆角大小
                                      child: Container(
                                        width: 100.px,
                                        height: 100.px,
                                        child: Image.network(
                                          APIs.imagePrefix +
                                              (listData?.photo?.split(
                                                    ',',
                                                  )[index] ??
                                                  ''),
                                          fit: BoxFit.cover, // 保证图片铺满整个容器
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              listData?.lostName ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14.px,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          // 类型标签
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.px,
                                              vertical: 5.px,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  listData?.def2 == '1'
                                                      ? primaryColor[500]
                                                      : secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5.px),
                                            ),
                                            child: Text(
                                              listData?.def2 == '1'
                                                  ? S.current.found
                                                  : S.current.lost,
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.px),
                                      if (listData?.def2 == '1' &&
                                          listData?.receivePlace != null)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 14.px,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              S.current.receivePlace,
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              listData?.receivePlace ?? '',
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      // 分割线
                                      if (listData?.def2 == '1' &&
                                          listData?.receivePlace != null)
                                        Divider(
                                          height: 10.px,
                                          color: Colors.grey,
                                        ),
                                      if (listData?.def2 == '0')
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 14.px,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              S.current.lostTime,
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              listData?.foundTime ?? '',
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (listData?.def2 == '1')
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 14.px,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              S.current.receiveTime,
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              listData?.foundTime ?? '',
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      SizedBox(height: 8.px),

                                      if (listData?.def2 == '1')
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 14.px,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              S
                                                  .of(context)
                                                  .goodHeartedColleague,
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              listData?.receiveName ?? '',
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (listData?.def2 == '0')
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 14.px,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              S.of(context).lostItemColleague,
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              listData?.receiveName ?? '',
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      SizedBox(height: 8.px),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            size: 14.px,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            S.of(context).contactNumber,
                                            style: TextStyle(
                                              fontSize: 12.px,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            listData?.tel ?? '',
                                            style: TextStyle(
                                              fontSize: 12.px,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.px),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 14.px,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            S.of(context).lostPlace,
                                            style: TextStyle(
                                              fontSize: 12.px,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            listData?.foundPlace ?? '',
                                            style: TextStyle(
                                              fontSize: 12.px,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (listData?.reviewStatus == 2)
                                        SizedBox(height: 8.px),
                                      if (listData?.reviewStatus == 2)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.error,
                                              size: 14.px,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              S.of(context).auditRejected,
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              listData?.def3 ?? '',
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.px),
                            Divider(height: 10.px, color: Colors.grey[300]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // 领取
                                if (listData?.isFound == '0')
                                  SizedBox(
                                    height: 20.px,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: EdgeInsets.all(0.px),
                                        minimumSize: Size(40.px, 20.px),
                                      ),
                                      onPressed: () {
                                        // 弹出确认框
                                        DialogFactory.instance
                                            .showConfirmDialog(
                                              context: context,
                                              title:
                                                  S.of(context).confirmReceive,
                                              content:
                                                  S
                                                      .of(context)
                                                      .confirmReceiveContent,
                                              confirmText:
                                                  S.of(context).confirm,
                                              cancelText: S.of(context).cancel,
                                              confirmClick: () {
                                                model?.receiveLostFound(
                                                  listData!,
                                                );
                                              },
                                            );
                                      },
                                      child: Text(
                                        S.of(context).receive,
                                        style: TextStyle(fontSize: 10.px),
                                      ),
                                    ),
                                  ),
                                if (listData?.createBy == userName &&
                                    current == 3)
                                  Row(
                                    children: [
                                      SizedBox(width: 10.px),
                                      // 编辑按钮
                                      if (listData?.reviewStatus == 2)
                                        SizedBox(
                                          height: 20.px,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  primaryColor[500],
                                              padding: EdgeInsets.all(0.px),
                                              minimumSize: Size(40.px, 20.px),
                                            ),
                                            onPressed: () async {
                                              final result =
                                                  await RouteUtils.pushNamed(
                                                    context,
                                                    'lost_found_detail_page',
                                                    arguments: {
                                                      'id': listData?.id,
                                                    },
                                                  );
                                              if (result != null &&
                                                  result['success'] == true) {
                                                model?.getLostFoundModelList(
                                                  true,
                                                );
                                                ProgressHUD.showSuccess(
                                                  result['msg'],
                                                );
                                              }
                                            },
                                            child: Text(
                                              S.of(context).edit,
                                              style: TextStyle(fontSize: 10.px),
                                            ),
                                          ),
                                        ),
                                      // 删除按钮
                                      SizedBox(width: 10.px),
                                      SizedBox(
                                        height: 20.px,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: secondaryColor,
                                            padding: EdgeInsets.all(0.px),
                                            minimumSize: Size(40.px, 20.px),
                                          ),
                                          onPressed: () {
                                            // 弹出确认框
                                            DialogFactory.instance
                                                .showConfirmDialog(
                                                  context: context,
                                                  title:
                                                      S
                                                          .of(context)
                                                          .confirmDelete,
                                                  content:
                                                      S
                                                          .of(context)
                                                          .confirmDeleteContent,
                                                  confirmText:
                                                      S.of(context).confirm,
                                                  cancelText:
                                                      S.of(context).cancel,
                                                  confirmClick: () {
                                                    model?.deleteLostFound(
                                                      listData?.id.toString() ??
                                                          '',
                                                    );
                                                  },
                                                );
                                          },
                                          child: Text(
                                            S.of(context).delete,
                                            style: TextStyle(fontSize: 10.px),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // 定位右上角状态
                      Positioned(
                        top: 5.px,
                        right: -40.px,
                        child: Transform.rotate(
                          angle: 0.785398, // 45度角，弧度制
                          child: Container(
                            width: 120.px,
                            height: 24.px,
                            alignment: Alignment.center,
                            color:
                                listData?.reviewStatus == 0
                                    ? Colors.orange
                                    : listData?.reviewStatus == 1
                                    ? listData?.isFound == '1'
                                        ? Colors.green
                                        : Colors.red
                                    : Colors.red,
                            child: Text(
                              listData?.reviewStatus == 0
                                  ? S.of(context).toBeAudited
                                  : listData?.reviewStatus == 1
                                  ? listData?.isFound == '1'
                                      ? S.of(context).toBeReceived
                                      : listData?.def2 == '1'
                                      ? S.of(context).toBeReceived
                                      : S.of(context).toBeFound
                                  : S.of(context).auditRejected,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.px,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
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

// 过滤html标签
class HtmlLineLimit extends StatelessWidget {
  const HtmlLineLimit({
    Key? key,
    required this.htmlContent,
    this.color,
    this.maxLines,
    this.fontSize,
  }) : super(key: key);

  final String htmlContent;
  final Color? color;
  final int? maxLines;
  final double? fontSize;

  String _removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.only(top: 8.px, bottom: 8.px),
          alignment: Alignment.centerLeft,
          child: Text(
            _removeHtmlTags(htmlContent),
            style: TextStyle(
              fontSize: fontSize ?? 12.px,
              color: color ?? Colors.grey,
            ),
            maxLines: maxLines ?? 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

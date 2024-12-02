import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_view_model.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  final List<SwitchType> buttonLabels = [
    SwitchType('全部', 0),
    SwitchType('失物', 1),
    SwitchType('招领', 2),
  ];
  final List<String> galleryItems = <String>[
    'assets/hotel/hotel_1.png',
    'assets/hotel/hotel_2.png',
    'assets/hotel/hotel_3.png',
    'assets/hotel/hotel_4.png',
  ];
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    _refreshController = RefreshController();

    switchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0, 0.3, curve: Curves.fastOutSlowIn)));

    super.initState();
    model.getLostFoundModelList(true);
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
      print(current);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return model;
        },
        child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text(
                '失物招领',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              foregroundColor: Colors.black,
              centerTitle: true,
              elevation: 0,
              backgroundColor: backgroundColor,
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  SmartRefreshWidget(
                      enablePullDown: true,
                      enablePullUp: true,
                      onRefresh: () {
                        //关闭刷新
                        model.getLostFoundModelList(true).then((value) {
                          _refreshController.refreshCompleted();
                          // 刷新完成
                          animationController?.forward();
                        });
                      },
                      onLoading: () async {
                        await model.getLostFoundModelList(false);
                        _refreshController.loadComplete();
                      },
                      controller: _refreshController,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/lost_found.png',
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // 搜索框带按钮
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: SizedBox(
                                    height: 30, // 设置输入框高度
                                    child: TextField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        hintText: '请输入关键字',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        // 设置行高
                                        prefixIcon: Icon(Icons.search),
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          // 无边框
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      style: TextStyle(height: 1, fontSize: 12),
                                    ),
                                  )),
                                  SizedBox(width: 10),
                                  SizedBox(
                                    height: 30, // 设置按钮高度
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                        '搜索',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                primaryColor),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SwitchTypeView(
                              listData: buttonLabels,
                              callBack: (int value) {
                                print(value);
                                updateCurrent(value);
                              },
                              animationController: animationController,
                              animation: switchAnimation,
                              current: current,
                            ),
                            LostFountListView(),
                          ],
                        ),
                      )),
                  // 固定屏幕的发布按钮
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                        onPressed: () {
                          RouteUtils.pushNamed(
                              context, RoutePath.LostFoundDetailPage);
                        },
                        // 背景设置为白色
                        backgroundColor: primaryColor,
                        // 设置文字颜色
                        foregroundColor: secondaryColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.add), Text('发布')],
                        )),
                  ),
                ],
              ),
            )));
  }

  Widget LostFountListView() {
    return Consumer<LostFoundViewModel>(
      builder: (context, model, child) {
        if (model.list?.isEmpty == true) {
          return Center(
            heightFactor: 10,
            child: Text("暂无数据"),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: model.list?.length ?? 0,
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            final int count = model.list?.length ?? 0;
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController!,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn)));
            animationController?.forward();
            return LostFoundView(
              listData: model.list?[index],
              galleryItems: galleryItems,
              animation: animation,
              animationController: animationController,
            );
          },
        );
      },
    );
  }
}

class LostFoundView extends StatelessWidget {
  const LostFoundView(
      {Key? key,
      this.listData,
      this.animationController,
      this.galleryItems,
      this.animation})
      : super(key: key);
  final List<String>? galleryItems;
  final NoticeModel? listData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            // 跳转到详情页
                            RouteUtils.pushNamed(
                                context, RoutePath.NoticeDetailPage,
                                arguments: {
                                  'noticeTitle': listData?.noticeTitle,
                                  'noticeId': listData?.noticeId,
                                  'noticeContent': listData?.noticeContent
                                });
                          },
                          child: Ink(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(listData?.noticeTitle ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        Text(listData?.createTime ?? '',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey))
                                      ],
                                    )),
                                    SizedBox(width: 20),
                                    // 是否已查看
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        '丢失',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                                HtmlLineLimit(
                                    htmlContent: listData?.noticeContent ?? ''),
                                Container(
                                  height: 100,
                                  child: GridView.builder(
                                    // 禁止滚动
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: galleryItems?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          PhotoViewGallery(
                                                            pageOptions:
                                                                galleryItems!
                                                                    .map(
                                                                      (item) =>
                                                                          PhotoViewGalleryPageOptions(
                                                                        imageProvider:
                                                                            AssetImage(item),
                                                                        initialScale:
                                                                            PhotoViewComputedScale.contained,
                                                                        heroAttributes:
                                                                            PhotoViewHeroAttributes(
                                                                          tag:
                                                                              'galleryTag_$index',
                                                                        ),
                                                                        onTapUp: (context,
                                                                                details,
                                                                                controllerValue) =>
                                                                            Navigator.of(context).pop(),
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                            backgroundDecoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            pageController:
                                                                PageController(
                                                                    initialPage:
                                                                        index),
                                                          )));
                                        },
                                        child: galleryItems != null
                                            ? Image.asset(
                                                galleryItems![index],
                                                fit: BoxFit.cover,
                                              )
                                            : SizedBox.shrink(
                                                // 空间占位符
                                                ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  )));
        });
  }
}

// 过滤html标签
class HtmlLineLimit extends StatelessWidget {
  const HtmlLineLimit({Key? key, required this.htmlContent}) : super(key: key);

  final String htmlContent;

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
          child: SingleChildScrollView(
            child: Text(
              _removeHtmlTags(htmlContent),
              style: TextStyle(fontSize: 10.px),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

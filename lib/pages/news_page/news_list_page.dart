import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/pages/news_page/news_view_model.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/pages/notice_page/notice_detail_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  var model = NewsViewModel();
  late RefreshController _refreshController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _refreshController = RefreshController();

    super.initState();
    model.getNewsModelList(1, 10);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
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
                '公司动态',
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: SafeArea(
                child: SmartRefreshWidget(
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () {
                      //关闭刷新
                      print('刷新完成');
                      model.getNewsModelList(1, 10).then((value) {
                        _refreshController.refreshCompleted();
                      });
                    },
                    controller: _refreshController,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: newsListView(),
                    )))));
  }

  Widget newsListView() {
    return Consumer<NewsViewModel>(
      builder: (context, model, child) {
        if (model.list?.isEmpty == true) {
          return Center(
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
            return NewsDataView(
              listData: model.list?[index],
              index: index,
              callBack: () => {
                // 跳转到详情页
                RouteUtils.push(context,
                    NoticeDetailPage(noticeId: model.list![index]!.noticeId!))
              },
              animation: animation,
              animationController: animationController,
            );
          },
        );
      },
    );
  }
}

class NewsDataView extends StatelessWidget {
  const NewsDataView(
      {Key? key,
      this.listData,
      this.callBack,
      this.index,
      this.animationController,
      this.animation})
      : super(key: key);

  final NoticeModel? listData;
  final VoidCallback? callBack;
  final int? index;
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
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: callBack,
                        child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: index == 0
                                ? Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            'assets/images/inviteImage.png',
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      listData?.noticeTitle ??
                                                          '',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  HtmlLineLimit(
                                                      htmlContent: listData
                                                              ?.noticeContent ??
                                                          ''),
                                                  SizedBox(height: 10),
                                                  Text('2021-09-01 10:00:00',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                ]),
                                          )
                                        ],
                                      ),
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          // 最新图标带文字
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                            child: Text('最新动态',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                          )),
                                    ],
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        listData?.noticeTitle ??
                                                            '',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    HtmlLineLimit(
                                                        htmlContent: listData
                                                                ?.noticeContent ??
                                                            ''),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(children: [
                                                  Text('2021-09-01 10:00:00',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                  SizedBox(width: 20),
                                                  // 浏览次数图标
                                                  Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      color: Colors.grey,
                                                      size: 16),
                                                  SizedBox(width: 5),
                                                  Text('100',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12))
                                                ])
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Image.asset(
                                          'assets/images/inviteImage.png',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  )),
                      ),
                    )),
              ));
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
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            child: Text(
              _removeHtmlTags(htmlContent),
              style: TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/pages/news_page/news_detail_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  int _page = 1;
  List<NoticeModel> _list = [];
  int _total = 0;

  late RefreshController _refreshController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _refreshController = RefreshController();
    super.initState();
    getNewsModelList(true);
  }

  Future<void> getNewsModelList(bool isRefresh) async {
    if (isRefresh) {
      _page = 1;
      _list = [];
    }
    try {
      DataUtils.getPageList('/system/notice/list', {
        'pageNum': _page,
        'pageSize': 10,
        'noticeType': 2,
      }, success: (data) {
        if (data != null) {
          var noticeList = data['rows'] as List;
          List<NoticeModel> rows =
              noticeList.map((i) => NoticeModel.fromJson(i)).toList();
          if (isRefresh) {
            _list = rows;
          } else {
            _list = [..._list, ...rows];
          }
          _total = data['total'] ?? 0;
          _page++;
        }
        setState(() {
          if (_list.length >= _total) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        });
      });
    } catch (e) {
      print('Error fetching news: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            S.of(context).companyNews,
            style: TextStyle(fontSize: 16.px),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
            child: SmartRefreshWidget(
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: () {
                  getNewsModelList(true).then((value) {
                    _refreshController.refreshCompleted();
                  });
                },
                onLoading: () {
                  getNewsModelList(false);
                },
                controller: _refreshController,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: newsListView(),
                ))));
  }

  Widget newsListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _list.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final int count = _list.length;
        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: animationController!,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn)));
        animationController?.forward();
        return _list.isNotEmpty
            ? NewsDataView(
                listData: _list[index],
                index: index,
                callBack: () => {
                  // 跳转到详情页
                  RouteUtils.push(
                      context,
                      NewsDetailPage(
                          noticeId: _list[index].noticeId.toString()))
                },
                animation: animation,
                animationController: animationController,
              )
            : EmptyView();
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
                    0.0, 50.px * (1.0 - animation!.value), 0.0),
                child: Container(
                    margin: EdgeInsets.only(bottom: 10.px),
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
                                            height: 180.px,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 10.px),
                                          Padding(
                                            padding: EdgeInsets.all(10.px),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      listData?.noticeTitle ??
                                                          '',
                                                      style: TextStyle(
                                                          fontSize: 12.px,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  HtmlLineLimit(
                                                      htmlContent: listData
                                                              ?.noticeContent ??
                                                          ''),
                                                  SizedBox(height: 10.px),
                                                  Text(
                                                      listData?.createTime ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10.px)),
                                                ]),
                                          )
                                        ],
                                      ),
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          // 最新图标带文字
                                          child: Container(
                                            padding: EdgeInsets.all(5.px),
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
                                                    fontSize: 10.px)),
                                          )),
                                    ],
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(10.px),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 100.px,
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
                                                            fontSize: 12.px,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    HtmlLineLimit(
                                                        htmlContent: listData
                                                                ?.noticeContent ??
                                                            ''),
                                                  ],
                                                ),
                                                SizedBox(height: 10.px),
                                                Row(children: [
                                                  Text(
                                                      listData?.createTime ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10.px)),
                                                  SizedBox(width: 20.px),
                                                  // 浏览次数图标
                                                  Icon(
                                                      Icons
                                                          .remove_red_eye_outlined,
                                                      color: Colors.grey,
                                                      size: 16.px),
                                                  SizedBox(width: 5.px),
                                                  Text('100',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10.px))
                                                ])
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20.px),
                                        Image.asset(
                                          'assets/images/inviteImage.png',
                                          width: 100.px,
                                          height: 100.px,
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
          margin: EdgeInsets.only(top: 10.px),
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            child: Text(
              _removeHtmlTags(htmlContent),
              style: TextStyle(fontSize: 10.px),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

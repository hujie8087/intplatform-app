import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/pages/notice_page/notice_detail_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({super.key});
  @override
  _NoticeListPageState createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  late RefreshController _refreshController;
  List<NoticeModel> _list = [];
  int _total = 0;
  int _page = 1;
  int _pageSize = 10;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _refreshController = RefreshController();
    getNoticeList(true);
    super.initState();
  }

  Future<void> getNoticeList(bool isRefresh) async {
    if (isRefresh) {
      _page = 1;
      _list.clear();
    }

    DataUtils.getPageList('/system/notice/list', {
      'pageNum': _page,
      'pageSize': _pageSize,
      'noticeType': 1,
    }, success: (data) {
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
      setState(() {
        if (_list.length >= _total) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
      });
    });
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
            S.of(context).notifications,
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
                  getNoticeList(true).then((value) {
                    _refreshController.refreshCompleted();
                  });
                },
                onLoading: () {
                  getNoticeList(false).then((value) {
                    _refreshController.loadComplete();
                  });
                },
                controller: _refreshController,
                child: Padding(
                  padding: EdgeInsets.all(10.px),
                  child: noticeListView(),
                ))));
  }

  Widget noticeListView() {
    if (_list.isEmpty) {
      return EmptyView();
    }
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
        return NoticeDataView(
          listData: _list[index],
          callBack: () => {
            // 跳转到详情页
            RouteUtils.push(
                context, NoticeDetailPage(noticeId: _list[index].noticeId!))
          },
          animation: animation,
          animationController: animationController,
        );
      },
    );
  }
}

class NoticeDataView extends StatelessWidget {
  const NoticeDataView(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final NoticeModel? listData;
  final VoidCallback? callBack;
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
                        borderRadius: BorderRadius.circular(20.px),
                        child: InkWell(
                          onTap: callBack,
                          child: Ink(
                            padding: EdgeInsets.all(10.px),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.px),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // 圆形图片
                                    Container(
                                      width: 30.px,
                                      height: 30.px,
                                      margin: EdgeInsets.only(right: 10.px),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/fitness_app/snack.png'),
                                            fit: BoxFit.fill,
                                          ),
                                          color: primaryColor),
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(listData?.noticeTitle ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14.px,
                                                fontWeight: FontWeight.bold)),
                                        Text(listData?.createTime ?? '',
                                            style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.grey))
                                      ],
                                    )),
                                    SizedBox(width: 10.px),
                                    // 是否已查看
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.px, vertical: 2.px),
                                      child: Text(
                                        '已查看',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.px),
                                      ),
                                    )
                                  ],
                                ),
                                HtmlLineLimit(
                                  htmlContent: listData?.noticeContent ?? '',
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
          margin: EdgeInsets.only(top: 10.px),
          padding: EdgeInsets.only(left: 10.px, right: 10.px),
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            child: Text(
              _removeHtmlTags(htmlContent),
              style: TextStyle(fontSize: 12.px),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

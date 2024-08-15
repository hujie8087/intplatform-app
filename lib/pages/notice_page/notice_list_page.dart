import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/pages/notice_page/notice_detail_page.dart';
import 'package:logistics_app/pages/notice_page/notice_view_model.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({super.key});
  @override
  _NoticeListPageState createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  var model = NoticeViewModel();
  late RefreshController _refreshController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _refreshController = RefreshController();

    super.initState();
    model.getNoticeModelList(1, 10);
    print('model.list:${model.list}');
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
                '通知公告',
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
                      model.getNoticeModelList(1, 10).then((value) {
                        _refreshController.refreshCompleted();
                      });
                    },
                    controller: _refreshController,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: noticeListView(),
                    )))));
  }

  Widget noticeListView() {
    return Consumer<NoticeViewModel>(
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
            return NoticeDataView(
              listData: model.list?[index],
              callBack: () => {
                // 跳转到详情页
                // RouteUtils.pushNamed(context, RoutePath.NoticeDetailPage,
                //     arguments: {
                //       'noticeTitle': model.list?[index]?.noticeTitle,
                //       'noticeId': model.list?[index]?.noticeId,
                //       'noticeContent': model.list?[index]?.noticeContent
                //     })
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
                      0.0, 50 * (1.0 - animation!.value), 0.0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: callBack,
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
                                    // 圆形图片
                                    Container(
                                      width: 30,
                                      height: 30,
                                      margin: EdgeInsets.only(right: 10),
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        Text(listData?.createTime ?? '',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey))
                                      ],
                                    )),
                                    SizedBox(width: 10),
                                    // 是否已查看
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      child: Text(
                                        '已查看',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                                HtmlLineLimit(
                                    htmlContent: listData?.noticeContent ?? '')
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
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            child: Text(
              _removeHtmlTags(htmlContent),
              style: TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

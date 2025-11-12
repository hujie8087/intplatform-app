import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/pages/news/monthly_page/monthly_detail_page.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logistics_app/utils/utils.dart';

@AppRoute(path: 'monthly_list_page', name: '纬达贝月刊')
class MonthlyListPage extends StatefulWidget {
  const MonthlyListPage({super.key});
  @override
  _MonthlyListPageState createState() => _MonthlyListPageState();
}

class _MonthlyListPageState extends State<MonthlyListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  int _page = 1;
  List<NoticeModel> _list = [];
  int _total = 0;

  late RefreshController _refreshController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
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
      DataUtils.getPageList(
        '/system/notice/list',
        {
          'pageNum': _page,
          'pageSize': 10,
          'noticeType': 5,
          "status": '0',
          "approvalStatus": 4,
        },
        success: (data) {
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
        },
      );
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
        title: Text(S.of(context).monthly, style: TextStyle(fontSize: 16.px)),
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
          child: Padding(padding: EdgeInsets.all(10), child: newsListView()),
        ),
      ),
    );
  }

  Widget newsListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _list.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final int count = _list.length;
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
        return _list.isNotEmpty
            ? MonthlyDataView(
              listData: _list[index],
              index: index,
              callBack:
                  () => {
                    if (kIsWeb)
                      {
                        launchUrl(
                          Uri.parse(
                            APIs.imageOnlinePrefix + _list[index].file!,
                          ),
                        ),
                      }
                    else
                      {
                        // 打开pdf
                        RouteUtils.push(
                          context,
                          MonthlyDetailPage(
                            pdfUrl:
                                _list[index].file != null
                                    ? APIs.imageOnlinePrefix +
                                        _list[index].file!
                                    : '',
                            title: _list[index].noticeTitle ?? '',
                          ),
                        ),
                      },
                  },
              animation: animation,
              animationController: animationController,
            )
            : EmptyView();
      },
    );
  }
}

class MonthlyDataView extends StatelessWidget {
  const MonthlyDataView({
    Key? key,
    this.listData,
    this.callBack,
    this.index,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final NoticeModel? listData;
  final VoidCallback? callBack;
  final int? index;
  final AnimationController? animationController;
  final Animation<double>? animation;

  String formatTime(String? time) {
    // 根据发布时间,转化为'今天','昨天','前天','一周前',超过一周则显示具体时间
    if (time == null || time.isEmpty) return '';
    DateTime dateTime = DateTime.parse(time);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);
    print('difference: ${difference.inDays}');
    switch (difference.inDays) {
      case 0:
        return '今天';
      case 1:
        return '昨天';
      case 2:
        return '前天';
      case < 7:
        return '一周前';
      default:
        return time;
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
              0.0,
              50.px * (1.0 - animation!.value),
              0.0,
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 10.px),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: callBack,
                  child: Ink(
                    padding: EdgeInsets.all(15.px),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 时间
                              Text(
                                formatTime(listData?.createTime),
                                style: TextStyle(
                                  fontSize: 12.px,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 10.px),
                              Row(
                                children: [
                                  // 文件下载
                                  Text(
                                    listData?.noticeTitle ?? '',
                                    style: TextStyle(
                                      fontSize: 14.px,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10.px),
                                ],
                              ),
                              SizedBox(height: 10.px),
                              Row(
                                children: [
                                  // 阅读次数
                                  Text(
                                    '阅读: ${listData?.papeView.toString() ?? '0'}',
                                    style: TextStyle(
                                      fontSize: 12.px,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // 展示图片
                        if (listData?.img != null)
                          Container(
                            width: 60.px,
                            height: 60.px,
                            margin: EdgeInsets.only(top: 15.px),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(
                                  APIs.imagePrefix + listData!.img!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
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
              style: TextStyle(fontSize: 12.px),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

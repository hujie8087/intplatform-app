import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/feedback_card_widget.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/complaint_message_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/shopping/my_feedback/my_feedback_detail_page.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@AppRoute(path: 'my_feedback_list_page', name: '我的反馈列表页')
class MyFeedbackListPage extends StatefulWidget {
  const MyFeedbackListPage({super.key});
  @override
  _MyFeedbackListPageState createState() => _MyFeedbackListPageState();
}

class _MyFeedbackListPageState extends State<MyFeedbackListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  int _page = 1;
  List<ComplaintMessageModel> _list = [];
  int _total = 0;
  UserInfoModel? userInfo;

  late RefreshController _refreshController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _refreshController = RefreshController();
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
      setState(() {
        print(userInfo?.user);
        getMyFeedbackModelList(true);
      });
    }
  }

  Future<void> getMyFeedbackModelList(bool isRefresh) async {
    if (isRefresh) {
      _page = 1;
      _list = [];
    }
    try {
      DataUtils.getPageList(
        '/other/ComplaintMessage/list',
        {
          'pageNum': _page,
          'pageSize': 10,
          'createBy': userInfo?.user?.userName,
        },
        success: (data) {
          if (data != null) {
            var noticeList = data['rows'] as List;
            List<ComplaintMessageModel> rows =
                noticeList
                    .map((i) => ComplaintMessageModel.fromJson(i))
                    .toList();
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
            getMyFeedbackModelList(true).then((value) {
              _refreshController.refreshCompleted();
            });
          },
          onLoading: () {
            getMyFeedbackModelList(false);
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
            ? AnimatedBuilder(
              animation: animationController!,
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                      0.0,
                      50.px * (1.0 - animation.value),
                      0.0,
                    ),
                    child: FeedbackCardWidget(
                      feedback: _list[index],
                      onTap: () {
                        // 跳转到反馈详情页
                        RouteUtils.push(
                          context,
                          MyFeedbackDetailPage(feedback: _list[index]),
                        );
                      },
                    ),
                  ),
                );
              },
            )
            : EmptyView();
      },
    );
  }
}

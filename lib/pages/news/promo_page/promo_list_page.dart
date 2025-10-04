import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/pages/news/promo_page/promo_detail_page.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@AppRoute(path: 'promo_list_page', name: '宣传片列表页')
class PromoListPage extends StatefulWidget {
  const PromoListPage({Key? key}) : super(key: key);

  @override
  _PromoListPageState createState() => _PromoListPageState();
}

class _PromoListPageState extends State<PromoListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<NoticeModel> promoList = [];
  bool isLoading = true;
  late RefreshController _refreshController;
  int pageNum = 1;
  int pageSize = 10;
  int total = 0;
  bool hasMore = true;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    super.initState();
    _refreshController = RefreshController();
    getPromoList(true);
  }

  Future<void> getPromoList(bool isRefresh) async {
    isLoading = true;
    if (isRefresh) {
      pageNum = 1;
      promoList = [];
    }
    try {
      DataUtils.getPageList(
        '/system/notice/list',
        {
          'pageNum': pageNum,
          'pageSize': pageSize,
          'noticeType': 3,
          "status": '0',
          'approvalStatus': 4,
        },
        success: (data) {
          if (data != null) {
            var noticeList = data['rows'] as List;
            List<NoticeModel> rows =
                noticeList.map((i) => NoticeModel.fromJson(i)).toList();
            if (isRefresh) {
              promoList = rows;
            } else {
              promoList = [...promoList, ...rows];
            }
            total = data['total'] ?? 0;
            pageNum++;
          }
          setState(() {
            if (promoList.length >= total) {
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
            _refreshController.refreshCompleted();
            isLoading = false;
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
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).promoList, style: TextStyle(fontSize: 16.px)),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : promoList.isEmpty
              ? EmptyView()
              : SmartRefreshWidget(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: () async {
                  await getPromoList(true);
                },
                onLoading: () async {
                  await getPromoList(false);
                },
                child: ListView.builder(
                  itemCount: promoList.length,
                  itemBuilder: (context, index) {
                    final promo = promoList[index];
                    return _buildPromoCard(promo);
                  },
                ),
              ),
    );
  }

  Widget _buildPromoCard(NoticeModel promo) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.px),
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          // 跳转到视频播放页面
          RouteUtils.push(
            context,
            PromoDetailPage(noticeId: promo.noticeId.toString()),
          );
        },
        child: Column(
          children: [
            // 视频缩略图
            Container(
              width: double.infinity,
              height: 180.px,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  promo.img != null
                      ? Image.network(
                        APIs.imageOnlinePrefix + (promo.img ?? ''),
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                  // 播放按钮
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(12.px),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20.px,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.px),
              child: Row(
                children: [
                  Text(
                    promo.noticeTitle ?? '',
                    style: TextStyle(fontSize: 14.px),
                  ),
                  Spacer(),
                  Icon(Icons.remove_red_eye, size: 14.px, color: Colors.grey),
                  SizedBox(width: 4.px),
                  Text(
                    '${promo.papeView ?? 0}',
                    style: TextStyle(fontSize: 12.px, color: Colors.grey),
                  ),
                  SizedBox(width: 20.px),
                  Icon(Icons.access_time, size: 14.px, color: Colors.grey),
                  SizedBox(width: 4.px),
                  Text(
                    promo.createTime!.substring(0, 10),
                    style: TextStyle(fontSize: 12.px, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

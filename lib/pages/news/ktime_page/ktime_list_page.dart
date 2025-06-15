import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/pages/news/promo_page/promo_detail_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KTimeListPage extends StatefulWidget {
  const KTimeListPage({Key? key}) : super(key: key);

  @override
  _KTimeListPageState createState() => _KTimeListPageState();
}

class _KTimeListPageState extends State<KTimeListPage>
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
          'noticeType': 4,
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
        title: Text(S.of(context).kTimeList, style: TextStyle(fontSize: 16.px)),
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
                child: GridView.builder(
                  padding: EdgeInsets.all(16.px),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
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
    return GestureDetector(
      onTap: () {
        RouteUtils.push(
          context,
          PromoDetailPage(noticeId: promo.noticeId.toString()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.px),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 缩略图
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.px)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      APIs.imageOnlinePrefix + (promo.img ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 渐变遮罩
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 播放按钮
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 40.px,
                        height: 40.px,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: primaryColor,
                          size: 24.px,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 内容区域
            Padding(
              padding: EdgeInsets.all(8.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    promo.noticeTitle ?? '',
                    style: TextStyle(
                      fontSize: 12.px,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.px),

                  // 底部信息
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 14.px,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.px),
                      Text(
                        '${promo.papeView ?? 0}',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      Text(
                        promo.createTime!.substring(0, 10),
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
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

import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/good_deed_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/goodDeeds/my_good_deeds_detail_page.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@AppRoute(path: 'my_good_deeds_page', name: '我的好人好事页')
class MyGoodDeedsPage extends StatefulWidget {
  const MyGoodDeedsPage({super.key});
  @override
  _MyGoodDeedsPageState createState() => _MyGoodDeedsPageState();
}

class _MyGoodDeedsPageState extends State<MyGoodDeedsPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  UserInfoModel? userInfo;
  int _page = 1;
  List<GoodDeedModel> _list = [];
  int _total = 0;

  late RefreshController _refreshController;

  // 搜索相关变量
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  bool _isSearching = false;

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

  // 获取用户信息
  void getUserInfo() async {
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      setState(() {
        userInfo = UserInfoModel.fromJson(userInfoData);
        getDeedsList(true);
      });
    }
  }

  Future<void> getDeedsList(bool isRefresh) async {
    if (isRefresh) {
      _page = 1;
      _list = [];
    }
    try {
      // 构建搜索参数
      Map<String, dynamic> params = {
        'pageNum': _page,
        'pageSize': 10,
        'createBy': userInfo?.user?.userName,
      };

      // 添加搜索关键词
      if (_searchKeyword.isNotEmpty) {
        params['title'] = _searchKeyword;
      }

      DataUtils.getPageList(
        '/other/deeds/list',
        params,
        success: (data) {
          if (data != null) {
            var deedsList = data['rows'] as List;
            List<GoodDeedModel> rows =
                deedsList.map((i) => GoodDeedModel.fromJson(i)).toList();
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
      print('Error fetching deeds: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // 执行搜索
  void _performSearch() {
    _searchKeyword = _searchController.text.trim();
    setState(() {
      _isSearching = true;
    });
    getDeedsList(true).then((_) {
      setState(() {
        _isSearching = false;
      });
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('我的发布', style: TextStyle(fontSize: 16.px)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 搜索区域
            _buildSearchSection(),

            // 好人好事列表
            Expanded(
              child:
                  _list.isNotEmpty
                      ? SmartRefreshWidget(
                        enablePullDown: true,
                        enablePullUp: true,
                        onRefresh: () {
                          getDeedsList(true).then((value) {
                            _refreshController.refreshCompleted();
                          });
                        },
                        onLoading: () {
                          getDeedsList(false);
                        },
                        controller: _refreshController,
                        child: Padding(
                          padding: EdgeInsets.all(10.px),
                          child:
                              _isSearching
                                  ? Center(child: CircularProgressIndicator())
                                  : deedsListView(),
                        ),
                      )
                      : EmptyView(),
            ),
          ],
        ),
      ),
    );
  }

  // 构建搜索区域
  Widget _buildSearchSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.px),
      child: Column(
        children: [
          // 搜索框
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38.px,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8.px),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '搜索好人好事...',
                      hintStyle: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey.shade500,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                        size: 18.px,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.px,
                        vertical: 8.px,
                      ),
                    ),
                    onSubmitted: (value) => _performSearch(),
                  ),
                ),
              ),
              SizedBox(width: 8.px),
              // 搜索按钮
              Container(
                height: 38.px,
                width: 38.px,
                decoration: BoxDecoration(
                  color: primaryColor[500],
                  borderRadius: BorderRadius.circular(8.px),
                ),
                child: IconButton(
                  icon: Icon(Icons.search, color: Colors.white, size: 18.px),
                  onPressed: _performSearch,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget deedsListView() {
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
        return AnimatedBuilder(
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
                child: _buildGoodDeedCard(_list[index]),
              ),
            );
          },
        );
      },
    );
  }

  // 构建好人好事卡片
  Widget _buildGoodDeedCard(GoodDeedModel deed) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.px),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.px),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            RouteUtils.push(
              context,
              MyGoodDeedsDetailPage(id: deed.id.toString()),
            );
          },
          borderRadius: BorderRadius.circular(12.px),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.px),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(12.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题和状态
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          deed.title ?? '未知标题',
                          style: AppTheme.title.copyWith(
                            fontSize: 16.px,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.px),
                      _buildStatusTag(deed.status),
                    ],
                  ),

                  SizedBox(height: 12.px),

                  // 描述信息
                  if (deed.description != null && deed.description!.isNotEmpty)
                    Text(
                      deed.description!,
                      style: AppTheme.body2.copyWith(
                        fontSize: 12.px,
                        color: AppTheme.lightText,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                  SizedBox(height: 12.px),

                  // 个人信息和联系方式
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 姓名
                      if (deed.personName != null &&
                          deed.personName!.isNotEmpty)
                        _buildInfoItem(
                          icon: Icons.person,
                          label: '姓名',
                          value: deed.personName!,
                          color: Colors.blue.shade600,
                        ),
                      // 联系方式
                      if (deed.contactInfo != null &&
                          deed.contactInfo!.isNotEmpty)
                        _buildInfoItem(
                          icon: Icons.phone,
                          label: '联系方式',
                          value: deed.contactInfo!,
                          color: Colors.green.shade600,
                        ),
                    ],
                  ),

                  SizedBox(height: 12.px),

                  // 底部信息
                  Row(
                    children: [
                      // 点赞数
                      if (deed.likesCount != null &&
                          deed.likesCount!.isNotEmpty)
                        _buildLikeInfo(deed.likesCount!),

                      Spacer(),

                      // 时间
                      if (deed.createTime != null &&
                          deed.createTime!.isNotEmpty)
                        Text(
                          deed.createTime!,
                          style: AppTheme.body2.copyWith(
                            fontSize: 10.px,
                            color: AppTheme.lightText,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 构建状态标签
  Widget _buildStatusTag(int? status) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 0:
        statusColor = Colors.orange;
        statusText = '待审核';
        statusIcon = Icons.schedule;
        break;
      case 1:
        statusColor = Colors.green;
        statusText = '已通过';
        statusIcon = Icons.check_circle;
        break;
      case 2:
        statusColor = Colors.red;
        statusText = '已拒绝';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusText = '未知';
        statusIcon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 12.px, color: statusColor),
          SizedBox(width: 4.px),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 10.px,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 构建信息项
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(icon, size: 14.px, color: color),
        SizedBox(width: 4.px),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11.px,
            color: AppTheme.lightText,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.px,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // 构建点赞信息
  Widget _buildLikeInfo(String likesCount) {
    int count = int.tryParse(likesCount) ?? 0;
    return Row(
      children: [
        Icon(Icons.thumb_up, size: 14.px, color: Colors.red.shade400),
        SizedBox(width: 4.px),
        Text(
          count > 0 ? '$count' : '0',
          style: TextStyle(
            fontSize: 12.px,
            color: Colors.red.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

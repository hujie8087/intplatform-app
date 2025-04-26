import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/food_recommend_model.dart';
import 'package:logistics_app/http/model/restaurant_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/date_utils.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FoodRecommendPage extends StatefulWidget {
  const FoodRecommendPage({Key? key}) : super(key: key);

  @override
  State<FoodRecommendPage> createState() => _FoodRecommendPageState();
}

class _FoodRecommendPageState extends State<FoodRecommendPage>
    with TickerProviderStateMixin {
  // 美食推荐列表
  List<FoodRecommendModel> _foodList = [];
  AnimationController? animationController;
  int _page = 1;
  int _total = 0;
  late RefreshController _refreshController;

  // 获取所有餐厅
  List<RestaurantModel> _restaurantList = [];
  // 获取餐厅列表
  Future getRestaurantList(pageNum, pageSize) async {
    var params = {'pageNum': pageNum, 'pageSize': pageSize};
    DataUtils.getPageList(
      APIs.getRestaurantList,
      params,
      success: (data) {
        RowsModel rowsModel = RowsModel.fromJson(
          data,
          (json) => RestaurantViewModel.fromJson(json),
        );
        setState(() {
          if (rowsModel.rows != null) {
            var restaurantList = data['rows'] as List;
            List<RestaurantModel> rows =
                restaurantList.map((i) => RestaurantModel.fromJson(i)).toList();
            _restaurantList = rows;
          }
          getFoodRecommend(true);
        });
      },
    );
  }

  // 获取美食推荐
  Future<void> getFoodRecommend(bool isRefresh) async {
    if (isRefresh) {
      _page = 1;
      _foodList = [];
    }
    try {
      DataUtils.getPageList(
        '/productdisplay/recommend/list',
        {'pageNum': _page, 'pageSize': 10, "status": '0'},
        success: (data) {
          if (data != null) {
            var foodRecommendList = data['rows'] as List;
            List<FoodRecommendModel> rows =
                foodRecommendList
                    .map((i) => FoodRecommendModel.fromJson(i))
                    .toList();
            if (isRefresh) {
              _foodList = rows;
            } else {
              _foodList = [..._foodList, ...rows];
            }
            _total = data['total'] ?? 0;
            _page++;
          }
          setState(() {
            if (_foodList.length >= _total) {
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
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _refreshController = RefreshController();

    getRestaurantList(1, 1000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.foodRecommend)),
      body: SafeArea(
        child: SmartRefreshWidget(
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () {
            getFoodRecommend(true).then((value) {
              _refreshController.refreshCompleted();
            });
          },
          onLoading: () {
            getFoodRecommend(false);
          },
          controller: _refreshController,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: foodRecommendListView(),
          ),
        ),
      ),
    );
  }

  Widget foodRecommendListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _foodList.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final int count = _foodList.length;
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
        return _foodList.isNotEmpty
            ? FoodRecommendDataView(
              listData: _foodList[index],
              index: index,
              callBack:
                  () => {
                    // 跳转到详情页
                  },
              animation: animation,
              animationController: animationController,
              restaurantList: _restaurantList,
            )
            : EmptyView();
      },
    );
  }
}

class FoodRecommendDataView extends StatelessWidget {
  const FoodRecommendDataView({
    Key? key,
    this.listData,
    this.callBack,
    this.index,
    this.animationController,
    this.animation,
    required this.restaurantList,
  }) : super(key: key);

  final FoodRecommendModel? listData;
  final VoidCallback? callBack;
  final int? index;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final List<RestaurantModel> restaurantList;

  String setLocationName(String location) {
    if (location.isEmpty) {
      return '';
    }
    if (restaurantList.isEmpty) {
      return '';
    }

    var locationList = location.split(',');
    var locationName = '';
    for (var i in locationList) {
      locationName +=
          restaurantList
                      .firstWhere(
                        (element) => element.id.toString() == i,
                        orElse: () => RestaurantModel(name: '', id: 0),
                      )
                      .name
                      ?.isNotEmpty ??
                  false
              ? restaurantList
                      .firstWhere(
                        (element) => element.id.toString() == i,
                        orElse: () => RestaurantModel(name: '', id: 0),
                      )
                      .name! +
                  '、'
              : '';
    }

    return locationName;
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.px),
                child: Card(
                  margin: EdgeInsets.only(bottom: 16.px),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.px),
                  ),
                  // 超出隐藏
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: callBack,
                    borderRadius: BorderRadius.circular(16.px),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 图片
                            Container(
                              height: 200.px,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    APIs.imagePrefix + listData!.photoUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.px),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 美食名称
                                  Text(
                                    listData?.foodName ?? '',
                                    style: TextStyle(
                                      fontSize: 18.px,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.px),
                                  // 地点和时间
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16.px,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4.px),
                                      if (listData?.rdLocation != null)
                                        Expanded(
                                          child: Text(
                                            setLocationName(
                                              listData?.rdLocation ?? '',
                                            ),
                                            style: TextStyle(
                                              fontSize: 12.px,
                                              color: secondaryColor,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 4.px),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16.px,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4.px),
                                      Text(
                                        S.current.recommendTime,
                                        style: TextStyle(
                                          fontSize: 12.px,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '${formatDateTime(listData?.rdDate)} ${listData?.rdTime}',
                                        style: TextStyle(
                                          fontSize: 12.px,
                                          color: secondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.px),
                                  // 推荐理由
                                  Text(
                                    '${S.current.recommendReason}：${listData?.rdReason}',
                                    style: TextStyle(
                                      fontSize: 12.px,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8.px),
                                  // 推荐人
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 16.px,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4.px),
                                      Text(
                                        '${S.current.recommendPerson}：',
                                        style: TextStyle(
                                          fontSize: 12.px,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '${listData?.recommendedBy}',
                                        style: TextStyle(
                                          fontSize: 12.px,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.px,
                              vertical: 8.px,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // 新品推荐
                            child: Row(
                              children: [
                                Icon(
                                  Icons.new_releases,
                                  size: 20.px,
                                  color: secondaryColor,
                                ),
                                SizedBox(width: 4.px),
                                Text(
                                  S.current.newProductRecommend,
                                  style: TextStyle(
                                    fontSize: 12.px,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
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

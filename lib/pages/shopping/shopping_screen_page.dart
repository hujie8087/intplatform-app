import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/restaurant_pickup_view_model.dart';
import 'package:logistics_app/http/model/restaurant_view_model.dart';
import 'package:logistics_app/pages/shopping/food_view_model.dart';
import 'package:logistics_app/pages/shopping/restaurant/restaurant_screen_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ShoppingScreenPage extends StatefulWidget {
  @override
  _ShoppingScreenPage createState() => _ShoppingScreenPage();
}

class _ShoppingScreenPage extends State<ShoppingScreenPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  var model = FoodViewModel();
  late RefreshController _refreshController;

  String imagePrefix = APIs.foodPrefix;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _refreshController = RefreshController();

    super.initState();
    model.getRestaurantPickTypeList();
    model.getRestaurantList(1, 10);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return model;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '在线订餐',
              style: TextStyle(fontSize: 18),
            ),
            centerTitle: false,
            backgroundColor: Colors.white,
          ),
          backgroundColor: backgroundColor,
          body: SafeArea(
              child: SmartRefreshWidget(
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    model.getRestaurantList(1, 10).then((value) {
                      _refreshController.refreshCompleted();
                    });
                  },
                  controller: _refreshController,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: restaurantListView(),
                  ))),
        ));
  }

  Widget restaurantListView() {
    return Consumer<FoodViewModel>(
      builder: (context, model, child) {
        if (model.list?.isEmpty == true) {
          return Center(
            child: EmptyView(
              type: EmptyType.empty,
            ),
          );
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 0,
          ),
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
            return RestaurantDataView(
                listData: model.list![index]!,
                callBack: () => {
                      RouteUtils.push(context,
                          RestaurantScreenPage(id: model.list![index]!.id!))
                    },
                imagePrefix: imagePrefix,
                animation: animation,
                animationController: animationController,
                pickupTypes: model.pickupTypes);
          },
        );
      },
    );
  }
}

class RestaurantDataView extends StatelessWidget {
  const RestaurantDataView(
      {Key? key,
      required this.listData,
      this.callBack,
      required this.imagePrefix,
      this.animationController,
      this.animation,
      this.pickupTypes})
      : super(key: key);

  final RestaurantModel listData;
  final VoidCallback? callBack;
  final String imagePrefix;
  final List<RestaurantPickupViewModel?>? pickupTypes;
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
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 6.0),
                      ],
                    ),
                    child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: callBack,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.network(
                                        imagePrefix + listData.image!,
                                        width: 40,
                                        height: 40,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.amber[100],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Row(
                                          children: [
                                            Text(listData.startTime ?? '',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.amber[900])),
                                            Text('~',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.amber[900])),
                                            Text(listData.endTime ?? '',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.amber[900])),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(listData.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SmoothStarRating(
                                              allowHalfRating: false,
                                              starCount: 5,
                                              rating: 5,
                                              size: 16.0,
                                              color: secondaryColor,
                                              borderColor: secondaryColor,
                                              spacing: 0.0),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            child: Text('5',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: secondaryColor)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: Text('月销：3000+',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (listData.pickTypes != null)
                                        Row(
                                          children:
                                              listData.pickTypes!.map((label) {
                                            return Container(
                                              padding: EdgeInsets.only(
                                                left: 5,
                                                top: 2,
                                                right: 5,
                                                bottom: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: primaryColor,
                                                    width: 1),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              margin: EdgeInsets.only(
                                                  right: 5), // 控制容器之间的间距
                                              child: Text(
                                                pickupTypes!
                                                        .firstWhere((element) =>
                                                            element!.id ==
                                                            label)
                                                        ?.name ??
                                                    '',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: primaryColor),
                                              ),
                                            );
                                          }).toList(), // 转换为列表,
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      Text(
                                        '纬达贝工业园区',
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  )));
        });
  }
}

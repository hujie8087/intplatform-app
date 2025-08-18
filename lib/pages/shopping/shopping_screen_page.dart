import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/restaurant_pickup_view_model.dart';
import 'package:logistics_app/http/model/restaurant_view_model.dart';
import 'package:logistics_app/pages/shopping/food_view_model.dart';
import 'package:logistics_app/pages/shopping/restaurant/restaurant_screen_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ShoppingScreenPage extends StatefulWidget {
  @override
  _ShoppingScreenPage createState() => _ShoppingScreenPage();
}

class _ShoppingScreenPage extends State<ShoppingScreenPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  ScrollController? scrollController;
  double opacity = 0;
  int _currentIndex = 0;
  var model = FoodViewModel();
  Timer? timer;

  bool isCollapsed = false;

  String imagePrefix = APIs.foodPrefix;
  String imageNewPrefix = APIs.imagePrefix;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    scrollController = ScrollController();
    model.getHotFoodList();
    model.getRestaurantPickTypeList();
    super.initState();
    model.getRestaurantList(1, 100);
    scrollController?.addListener(() {
      onScrollEnd(scrollController?.offset);
    });

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        if (model.hotFoodList.isNotEmpty) {
          _currentIndex = (_currentIndex + 1) % (model.hotFoodList.length);
        }
      });
    });
  }

  // 监听滚动
  void onScrollEnd(offset) {
    // 当滚动到顶部时，AppBar颜色变淡
    if (offset < 250) {
      opacity = offset / 250;
    }
    setState(() {});
  }

  @override
  void dispose() {
    animationController?.dispose();
    scrollController?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: Scaffold(
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  foregroundColor:
                      opacity == 0
                          ? Colors.white
                          : Colors.black.withOpacity(opacity),
                  title: Text(
                    S.of(context).onlineDining,
                    style: TextStyle(
                      fontSize: 16.px,
                      color:
                          opacity == 0
                              ? Colors.white
                              : Colors.black.withOpacity(opacity),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.only(right: 8.px),
                      child: IconButton(
                        onPressed: () {
                          isCollapsed = !isCollapsed;
                          setState(() {});
                        },
                        icon: Icon(
                          isCollapsed ? Icons.view_agenda : Icons.dashboard,
                          color:
                              opacity == 0
                                  ? Colors.white
                                  : Colors.black.withOpacity(opacity),
                        ),
                      ),
                    ),
                  ],
                  centerTitle: false,
                  pinned: true, // 确保 AppBar 固定在顶部
                  collapsedHeight: 50.px,
                  toolbarHeight: 50.px,
                  expandedHeight: 200.px, // 设置扩展高度
                  flexibleSpace: FlexibleSpaceBar(
                    background: Consumer<FoodViewModel>(
                      builder:
                          (context, model, child) => Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children:
                                  model.hotFoodList.asMap().entries.map((
                                    entry,
                                  ) {
                                    int index = entry.key;
                                    return AnimatedOpacity(
                                      duration: Duration(seconds: 1),
                                      opacity:
                                          _currentIndex == index ? 1.0 : 0.0,
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.zero,
                                            padding: EdgeInsets.zero,
                                            width: double.infinity,
                                            // 屏幕宽度
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width,
                                            child: Image.network(
                                              APIs.foodPrefix +
                                                  model
                                                      .hotFoodList[index]
                                                      .image,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stack,
                                                  ) => Image.asset(
                                                    'assets/images/empty/空.png',
                                                  ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 120.px,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 16.px,
                                                horizontal: 16.px,
                                              ),
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                model.hotFoodList[index].name,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.px,
                                                ),
                                              ),
                                              // 渐变背景
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black.withOpacity(
                                                      0.8,
                                                    ),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                    ),
                  ),
                ),
              ],
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 16.px, horizontal: 12.px),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.px),
                topRight: Radius.circular(16.px),
              ),
            ),
            child: restaurantListView(), // 餐厅列表
          ),
        ),
      ),
    );
  }

  Widget restaurantListView() {
    return Consumer<FoodViewModel>(
      builder: (context, model, child) {
        if (model.list?.isEmpty == true) {
          return Center(child: EmptyView(type: EmptyType.loading));
        }
        return SingleChildScrollView(
          child: Wrap(
            spacing: 8.px,
            runSpacing: 5.px,
            children: List.generate(model.list?.length ?? 0, (index) {
              final int count = model.list?.length ?? 0;
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
              return Container(
                width:
                    isCollapsed
                        ? double.infinity
                        : MediaQuery.of(context).size.width / 2 - 16.px,
                child: RestaurantDataView(
                  listData: model.list![index]!,
                  callBack:
                      () => {
                        RouteUtils.push(
                          context,
                          RestaurantScreenPage(id: model.list![index]!.id!),
                        ),
                      },
                  imagePrefix: imagePrefix,
                  imageNewPrefix: imageNewPrefix,
                  animation: animation,
                  animationController: animationController,
                  pickupTypes: model.pickupTypes,
                  isCollapsed: isCollapsed,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class RestaurantDataView extends StatelessWidget {
  const RestaurantDataView({
    Key? key,
    required this.listData,
    this.callBack,
    required this.imagePrefix,
    required this.imageNewPrefix,
    this.animationController,
    this.animation,
    this.pickupTypes,
    this.isCollapsed = false,
  }) : super(key: key);

  final RestaurantModel listData;
  final VoidCallback? callBack;
  final String imagePrefix;
  final String imageNewPrefix;
  final List<RestaurantPickupViewModel?>? pickupTypes;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final bool isCollapsed;
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
              margin: EdgeInsets.only(bottom: 8.px),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.px),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.px),
                    onTap: callBack,
                    child: Container(
                      padding: EdgeInsets.all(8.px),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                                !isCollapsed
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.start,
                            children: [
                              if (!isCollapsed)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      listData.image?.indexOf('food') != -1
                                          ? imagePrefix + listData.image!
                                          : imageNewPrefix + listData.image!,
                                      width: 32.px,
                                      height: 32.px,
                                    ),
                                  ],
                                ),
                              SizedBox(width: 8.px),
                              Row(
                                children: [
                                  if (isCollapsed)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.network(
                                          imagePrefix + listData.image!,
                                          width: 72.px,
                                          height: 72.px,
                                        ),
                                        SizedBox(width: 8.px),
                                      ],
                                    ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        !isCollapsed
                                            ? MainAxisAlignment.spaceBetween
                                            : MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        listData.name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.px,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4.px),
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
                                                size: 12.px,
                                                color: secondaryColor,
                                                borderColor: secondaryColor,
                                                spacing: 0.0,
                                              ),
                                              SizedBox(width: 4.px),
                                              Container(
                                                child: Text(
                                                  '5',
                                                  style: TextStyle(
                                                    fontSize: 10.px,
                                                    fontWeight: FontWeight.bold,
                                                    color: secondaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.px),
                                      Container(
                                        child: Text(
                                          S.of(context).monthlySales + ':3000+',
                                          style: TextStyle(
                                            fontSize: 10.px,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4.px),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (listData.pickupTypeIds != null)
                                            Row(
                                              children:
                                                  listData.pickupTypeIds!.map((
                                                    label,
                                                  ) {
                                                    return Container(
                                                      padding: EdgeInsets.only(
                                                        left: 4.px,
                                                        top: 2.px,
                                                        right: 4.px,
                                                        bottom: 2.px,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                4.px,
                                                              ),
                                                            ),
                                                      ),
                                                      margin: EdgeInsets.only(
                                                        right: 4.px,
                                                      ), // 控制容器之间的间距
                                                      child: Text(
                                                        pickupTypes!
                                                                .firstWhere(
                                                                  (element) =>
                                                                      element!
                                                                          .id ==
                                                                      label,
                                                                )
                                                                ?.name ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 8.px,
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(), // 转换为列表,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    listData.startTime! +
                                        '~' +
                                        listData.endTime!,
                                    style: TextStyle(
                                      fontSize: 8.px,
                                      color: Colors.amber[900],
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
          ),
        );
      },
    );
  }
}

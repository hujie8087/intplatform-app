import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/food_category_model.dart';
import 'package:logistics_app/http/model/restaurant_pickup_view_model.dart';
import 'package:logistics_app/http/model/restaurant_view_model.dart';
import 'package:logistics_app/utils/color.dart';

class RestaurantBody extends StatefulWidget {
  const RestaurantBody({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _RestaurantBodyState createState() => _RestaurantBodyState();
}

class _RestaurantBodyState extends State<RestaurantBody>
    with SingleTickerProviderStateMixin {
  final List<dynamic> pickTypes = [1, 2, 3];
  final List<RestaurantPickupViewModel> pickupTypes = [
    RestaurantPickupViewModel(id: 1, name: '堂食'),
    RestaurantPickupViewModel(id: 2, name: '外卖'),
    RestaurantPickupViewModel(id: 3, name: '自取')
  ];
  // 用来记录右侧每个分类的偏移位置
  Map<int, double> categoryOffsetMap = {};

  RestaurantModel? restaurantDetail;
  late TabController _tabController;
  // 当前选中的选项
  int selectedIndex = 0;
  // 菜单类型
  List<FoodCategoryModel> categories = [];

  Future _fetchData() async {
    DataUtils.getDetailById(
      APIs.getRestaurantDetail + '/' + widget.id.toString(),
      success: (data) {
        restaurantDetail = RestaurantModel.fromJson(data['data']);
        setState(() {});
      },
    );

    DataUtils.getDetailById(
      APIs.getRestaurantMenuList + '?canteenId=' + widget.id.toString(),
      success: (data) {
        BaseListModel<FoodCategoryModel> result =
            BaseListModel<FoodCategoryModel>.fromJson(
                data, (json) => FoodCategoryModel.fromJson(json));
        categories = result.data ?? [];
        setState(() {
          categoryOffsetMap[categories[0].id] = 0;
          for (int i = 1; i < categories.length; i++) {
            // 当前分类标题的高度
            double headerHeight = 36;

            // 当前分类下所有商品的总高度 (商品数量 * 单个商品高度)
            double itemsHeight =
                categories[i - 1].foodCommodityList.length * 130;

            // 当前分类的偏移量 = 上一个分类的偏移量 + 上一个分类的标题高度 + 上一个分类商品列表的总高度
            categoryOffsetMap[categories[i].id] =
                categoryOffsetMap[categories[i - 1].id]! +
                    headerHeight +
                    itemsHeight;
          }
        });
      },
    );
  }

  // 当前选中的菜单类型
  int selectedCategoryIndex = 0;
  final List<SwitchType> buttonLabels = [
    SwitchType('点菜', 0),
    SwitchType('评价', 1),
    SwitchType('餐厅', 2),
  ];
  final StickyHeaderController _foodScrollController = StickyHeaderController();
  late ScrollController _categoryScrollController;

  @override
  void initState() {
    _fetchData();
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // 添加监听器，监听TabBar的切换
    _tabController.addListener(() {
      setState(() {});
    });
    _categoryScrollController = ScrollController();
    // 监听右边菜单滚动
    _foodScrollController.addListener(() {
      final header = _foodScrollController.stickyHeaderScrollOffset;
      categoryOffsetMap.forEach((id, offset) {
        if (offset == header) {
          // 通过id查找到对应的分类的index
          final newIndex =
              categories.indexWhere((category) => category.id == id);
          if (newIndex != selectedCategoryIndex) {
            // 使用 SchedulerBinding 来确保 setState 在下一帧调用
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedCategoryIndex = newIndex;
              });
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _foodScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 120),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/restaurant-bg.jpg'), // 本地图片
                      fit: BoxFit.fitWidth, // 背景图片的拉伸方式
                      alignment: Alignment.topCenter)),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    RestaurantInfo(),
                    RestaurantOptions(),
                    Expanded(child: buildTabBarView())
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget RestaurantInfo() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      restaurantDetail?.name ?? '',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: secondaryColor,
                            ),
                            Text(
                              '5.0',
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 14),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '月售：3000+',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '点餐时间：',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: primaryColor[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text(
                            '${restaurantDetail?.startTime} ~ ${restaurantDetail?.endTime}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: pickTypes.map((label) {
                        return Container(
                          padding: EdgeInsets.only(
                            left: 5,
                            top: 2,
                            right: 5,
                            bottom: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          margin: EdgeInsets.only(right: 5), // 控制容器之间的间距
                          child: Text(
                            pickupTypes
                                    .firstWhere(
                                        (element) => element.id == label)
                                    .name ??
                                '',
                            style: TextStyle(fontSize: 12, color: primaryColor),
                          ),
                        );
                      }).toList(), // 转换为列表,
                    )
                  ],
                )),
                if (restaurantDetail?.image != null)
                  Image.network(
                    APIs.foodPrefix + restaurantDetail!.image!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              restaurantDetail?.remark ?? '',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget RestaurantOptions() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(width: 0.5, color: Colors.grey[300]!))),
        child: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          isScrollable: true,
          labelPadding: EdgeInsets.only(right: 40),
          tabAlignment: TabAlignment.start,
          indicator: const BoxDecoration(),
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 16),
          unselectedLabelColor: Colors.grey[700],
          tabs: [
            for (var i in buttonLabels)
              Column(
                children: [
                  Text(
                    i.label,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 4,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      color: i.value == _tabController.index
                          ? primaryColor
                          : Colors.transparent,
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  // TabBar切换UI
  Widget buildTabBarView() {
    return Container(
      child: TabBarView(
        controller: _tabController,
        children: [
          buildFoodMenu(),
          Center(
            child: Text('评价'),
          ),
          Center(
            child: Text('商家'),
          ),
        ],
      ),
    );
  }

  // 点菜UI
  Widget buildFoodMenu() {
    return Container(
      child: categories.isEmpty
          ? Center(
              child: EmptyView(
                type: EmptyType.empty,
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧菜单类型列表
                Container(
                  width: 80,
                  color: Colors.grey[100],
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = index;
                            _categoryScrollController.animateTo(
                                categoryOffsetMap[categories[index].id]! + 5,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(14),
                          color: selectedCategoryIndex == index
                              ? Colors.white
                              : Colors.grey[100],
                          child: Text(
                            categories[index].name,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // 右边食物列表
                Expanded(
                  child: CustomScrollView(
                    controller: _categoryScrollController,
                    slivers: categories
                        .map(
                            (category) => buildCategoryList(category: category))
                        .toList(),
                  ),
                )
              ],
            ),
    );
  }

  // 菜品分类UI
  Widget buildCategoryList({required FoodCategoryModel category}) {
    return SliverStickyHeader.builder(
      controller: _foodScrollController,
      builder: (context, state) {
        return Container(
          height: 36,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 16,
                color: (state.isPinned ? primaryColor : Colors.grey[700]!)
                    .withOpacity(1.0 - state.scrollPercentage)),
            textAlign: TextAlign.left,
          ),
        );
      },
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => buildFoodList(foods: category.foodCommodityList),
          childCount: 1,
        ),
      ),
    );
  }

  // 菜品UI
  Widget buildFoodList({required List<FoodModel> foods}) {
    return Container(
      child: foods.isEmpty
          ? Center(
              child: EmptyView(
                type: EmptyType.empty,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 130,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5, color: Colors.grey[300]!))),
                  child: Row(
                    children: [
                      if (foods[index].image != '')
                        CachedNetworkImage(
                          imageUrl: APIs.foodPrefix + foods[index].image,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error), // 加载失败时的图标
                          fadeInDuration: Duration(milliseconds: 500),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      if (foods[index].image == '')
                        Image.asset(
                          'assets/images/empty/空.png',
                          width: 100,
                          height: 100,
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(foods[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '剩余:' + foods[index].stock.toString(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                foods[index].price.toString(),
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(), // 圆形按钮
                                    padding: EdgeInsets.all(0), // 内边距
                                    backgroundColor: primaryColor, // 背景颜色为黑色
                                    minimumSize: Size(20, 20)),
                                onPressed: () {
                                  // 处理按钮点击事件
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white, // 图标颜色为白色
                                ),
                              )
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                );
              },
            ),
    );
  }
}

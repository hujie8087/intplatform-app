import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:logistics_app/common_ui/KeepAliveWrapper.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_dialog.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/food_category_model.dart';
import 'package:logistics_app/http/model/restaurant_pickup_view_model.dart';
import 'package:logistics_app/http/model/restaurant_view_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';
import 'package:logistics_app/pages/shopping/food_view_model.dart';
import 'package:logistics_app/http/model/food_model.dart';
import 'package:logistics_app/pages/shopping/restaurant/components/shopping_cart.dart';
import 'package:logistics_app/pages/shopping/restaurant/components/image_preview.dart';

class RestaurantBody extends StatefulWidget {
  const RestaurantBody({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _RestaurantBodyState createState() => _RestaurantBodyState();
}

class _RestaurantBodyState extends State<RestaurantBody>
    with TickerProviderStateMixin {
  List<dynamic> pickTypes = [];
  bool isLoading = true;
  final List<RestaurantPickupViewModel> pickupTypes = [
    RestaurantPickupViewModel(id: 1, name: S.current.diningIn),
    RestaurantPickupViewModel(id: 2, name: S.current.delivery),
    RestaurantPickupViewModel(id: 3, name: S.current.takeout)
  ];
  // 用来记录右侧每个分类的偏移位置
  Map<int, int> categoryOffsetMap = {};

  RestaurantModel? restaurantDetail;
  late TabController _tabController;
  // 当前选中的选项
  int selectedIndex = 0;
  // 菜单类型
  List<FoodCategoryModel> categories = [];
  // 购物车数量
  int cartCount = 0;

  Future _fetchData() async {
    DataUtils.getDetailById(
      APIs.getRestaurantDetail + '/' + widget.id.toString(),
      success: (data) {
        restaurantDetail = RestaurantModel.fromJson(data['data']);
        pickTypes = restaurantDetail?.pickupTypeIds ?? [];
        setState(() {
          foodViewModel.initCartData(widget.id);
        });
      },
    );

    DataUtils.getDetailById(
      APIs.getRestaurantMenuList + '/' + widget.id.toString(),
      success: (data) {
        BaseListModel<FoodCategoryModel> result =
            BaseListModel<FoodCategoryModel>.fromJson(
                data, (json) => FoodCategoryModel.fromJson(json));
        categories = result.data ?? [];
        if (categories.isNotEmpty) {
          categoryOffsetMap[categories[0].id] = 0;
          for (int i = 1; i < categories.length; i++) {
            // 当前分类标题的高度
            double headerHeight = 36.px;
            // 当前分类下所有商品的总高度 (商品数量 * 单个商品高度)
            double itemsHeight =
                categories[i - 1].foodCommodityList.length * 100.px;
            // 当前分类的偏移量 = 上一个分类的偏移量 + 上一个分类的标题高度 + 上一个分类商品列表的总高度
            // 保留整数
            categoryOffsetMap[categories[i].id] =
                (categoryOffsetMap[categories[i - 1].id]! +
                        headerHeight +
                        itemsHeight -
                        5)
                    .toInt();
          }
        }
        print(categoryOffsetMap);
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  // 当前选中的菜单类型
  int selectedCategoryIndex = 0;
  final List<SwitchType> buttonLabels = [
    SwitchType(S.current.order, 0),
    SwitchType(S.current.evaluation, 1),
    SwitchType(S.current.restaurant, 2),
  ];
  final StickyHeaderController _foodScrollController = StickyHeaderController();
  late ScrollController _categoryScrollController = ScrollController();
  late ScrollController _pageScrollController = ScrollController();
  late AnimationController _buttonAnimationController;
  late AnimationController _circleAnimationController;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  OverlayEntry? _overlayEntry;
  final cartKey = GlobalKey();
  final int debounceMilliseconds = 500;
  DateTime? _lastPressedAt; // 上次点击时间
  bool _isAtTop = false;

  // 在 build 方法外部创建 provider
  final foodViewModel = FoodViewModel();

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
    _categoryScrollController.addListener(() {
      // 检查右侧菜品是否滑动到顶部
      bool isAtTop = _categoryScrollController.position.pixels > 0.0;
      if (_isAtTop != isAtTop) {
        setState(() {
          _isAtTop = isAtTop;
        });
      }
    });
    _pageScrollController.addListener(() {
      // 检查整个页面是否滑动到顶部
      bool isAtTop = _pageScrollController.position.pixels ==
          _pageScrollController.position.maxScrollExtent;
      if (_isAtTop != isAtTop) {
        setState(() {
          _isAtTop = isAtTop;
        });
      }
    });
    // 初始化按钮动画控制器
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // 初始化圆形动画控制器
    _circleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _xAnimation =
        Tween<double>(begin: 0, end: 1).animate(_circleAnimationController);
    // 抛物线动画,先上升后下降
    _yAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _circleAnimationController,
        curve: Curves.easeInBack, // 可以使用其他曲线来控制动画效果
      ),
    );
    // 动画结束监听器，增加购物车数量
    _circleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
        _removeOverlayEntry(); // 移除圆形动画
        _circleAnimationController.reset(); // 重置动画
      }
    });
    // 监听右边菜单滚动
    _foodScrollController.addListener(() {
      final header = _foodScrollController.stickyHeaderScrollOffset.toInt();
      categoryOffsetMap.forEach((id, offset) {
        // 判断偏移量是否在当前分类的偏移量范围内
        if (offset <= header && offset + 10 >= header) {
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
    _pageScrollController.dispose();
    _buttonAnimationController.dispose();
    _circleAnimationController.dispose();
    super.dispose();
  }

  void _removeOverlayEntry() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  // 动态生成 OverlayEntry
  OverlayEntry _createOverlayEntry(
      BuildContext context, Offset start, Offset end) {
    return OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _circleAnimationController,
          builder: (context, child) {
            final x = start.dx + (end.dx - start.dx) * _xAnimation.value;
            // 抛物线动画 先上升后下降
            final y = start.dy + (end.dy - start.dy) * _yAnimation.value;

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: 1 - _circleAnimationController.value,
                child: CircleAvatar(
                  radius: 12.px,
                  backgroundColor: Colors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 触发购物车动画
  void _addToCartAnimation(GlobalKey buttonKey) {
    // 获取当前时间
    final currentTime = DateTime.now();
    // 如果上次点击时间与当前时间差大于500ms，则立即结束动画并开始新的动画
    if (_lastPressedAt == null ||
        currentTime.difference(_lastPressedAt!) >
            Duration(milliseconds: debounceMilliseconds)) {
      _lastPressedAt = currentTime;
      _removeOverlayEntry();
      // 获取按钮和购物车位置
      final buttonPosition =
          (buttonKey.currentContext?.findRenderObject() as RenderBox)
              .localToGlobal(Offset.zero);
      final cartPosition =
          (cartKey.currentContext?.findRenderObject() as RenderBox)
              .localToGlobal(Offset.zero);

      // 在 Overlay 上添加动画
      _overlayEntry =
          _createOverlayEntry(context, buttonPosition, cartPosition);
      Overlay.of(context).insert(_overlayEntry!);

      // 开始动画
      _circleAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: foodViewModel,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            NestedScrollView(
              controller: _pageScrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Row(
                            // 返回按钮
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 60.px),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.px),
                                  topRight: Radius.circular(16.px))),
                          child: Column(
                            children: [
                              RestaurantInfo(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ];
              },
              body: buildTabBarView(cartKey: cartKey),
            ),
            // 定位底部的购物车
            Positioned(
              bottom: 8.px,
              left: 0,
              child: ShoppingCart(
                cartKey: cartKey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget RestaurantInfo() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.px),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      restaurantDetail?.name ?? '',
                      style: TextStyle(
                          fontSize: 16.px, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 6.px,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 12.px,
                              color: secondaryColor,
                            ),
                            Text(
                              '5.0',
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 12.px),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10.px,
                        ),
                        Text(
                          S.of(context).monthlySales + ":" + '3000',
                          style: TextStyle(fontSize: 12.px, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10.px,
                        ),
                        Text(
                          S.of(context).diningTime + ":",
                          style: TextStyle(fontSize: 12.px, color: Colors.grey),
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
                                fontSize: 10.px,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 6.px,
                    ),
                    Row(
                      children: pickTypes.map((label) {
                        return Container(
                          padding: EdgeInsets.only(
                            left: 5.px,
                            top: 2.px,
                            right: 5.px,
                            bottom: 2.px,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.px),
                            ),
                          ),
                          margin: EdgeInsets.only(right: 5.px), // 控制容器之间的间距
                          child: Text(
                            pickupTypes
                                    .firstWhere(
                                        (element) => element.id == label)
                                    .name ??
                                '',
                            style:
                                TextStyle(fontSize: 10.px, color: primaryColor),
                          ),
                        );
                      }).toList(), // 转换为列表,
                    )
                  ],
                )),
                if (restaurantDetail?.image != null)
                  Image.network(
                    APIs.foodPrefix + restaurantDetail!.image!,
                    width: 72.px,
                    height: 72.px,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.px, right: 8.px, bottom: 8.px),
            child: Text(
              restaurantDetail?.remark ?? '',
              style: TextStyle(color: Colors.grey, fontSize: 10.px),
            ),
          ),
        ],
      ),
    );
  }

  Widget RestaurantOptions() {
    return Container(
      padding: EdgeInsets.only(left: 8.px, right: 8.px),
      margin: EdgeInsets.only(
        top: 12.px,
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        child: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          isScrollable: true,
          labelPadding: EdgeInsets.only(right: 36.px),
          tabAlignment: TabAlignment.start,
          indicator: const BoxDecoration(),
          labelStyle: TextStyle(fontSize: 14.px, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 14.px),
          unselectedLabelColor: Colors.grey[700],
          tabs: [
            for (var i in buttonLabels)
              Column(
                children: [
                  Text(
                    i.label,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4.px),
                    height: 4.px,
                    width: 20.px,
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
  Widget buildTabBarView({required GlobalKey cartKey}) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          border:
              Border(top: BorderSide(width: 0.5, color: Colors.grey[300]!))),
      child: Column(
        children: [
          RestaurantOptions(),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              KeepAliveWrapper(
                child: buildFoodMenu(),
              ),
              Center(
                child: Text(S.current.evaluation),
              ),
              Center(
                child: Text(S.current.restaurant),
              ),
            ],
          ))
        ],
      ),
    );
  }

  // 点菜UI
  Widget buildFoodMenu() {
    return Container(
      child: categories.isEmpty
          ? Center(
              child: isLoading
                  ? ProgressDialog(
                      hintText: S.current.loading,
                    )
                  : EmptyView(
                      type: EmptyType.empty,
                    ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧菜单类型列表
                Container(
                  width: 80.px,
                  color: Colors.grey[100],
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
                          padding: EdgeInsets.all(12.px),
                          color: selectedCategoryIndex == index
                              ? Colors.white
                              : Colors.grey[100],
                          child: Text(
                            categories[index].name,
                            style: TextStyle(fontSize: 12.px),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // 右边食物列表
                Expanded(
                  child: CustomScrollView(
                    physics: _isAtTop
                        ? ScrollPhysics(parent: AlwaysScrollableScrollPhysics())
                        : NeverScrollableScrollPhysics(),
                    controller: _categoryScrollController,
                    slivers: categories
                        .map((category) => buildCategoryList(
                            category: category, cartKey: cartKey))
                        .toList(),
                  ),
                )
              ],
            ),
    );
  }

  // 菜品分类UI
  Widget buildCategoryList(
      {required FoodCategoryModel category, required GlobalKey cartKey}) {
    return SliverStickyHeader.builder(
      controller: _foodScrollController,
      builder: (context, state) {
        return Container(
          height: 32.px,
          padding: EdgeInsets.symmetric(vertical: 4.px, horizontal: 10.px),
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14.px,
                color: (state.isPinned ? primaryColor : Colors.grey[700]!)
                    .withOpacity(1.0 - state.scrollPercentage)),
            textAlign: TextAlign.left,
          ),
        );
      },
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            buildFoodList(foods: category.foodCommodityList),
            if (categories.last.id == category.id)
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.px),
                margin: EdgeInsets.only(bottom: 36.px),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50.px,
                      height: 1.px,
                      color: Colors.grey[300],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.px),
                      child: Text(
                        S.current.endOfList,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10.px,
                        ),
                      ),
                    ),
                    Container(
                      width: 50.px,
                      height: 1.px,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 菜品UI
  Widget buildFoodList({required List<FoodModel> foods}) {
    // 为每一个菜品添加一个key
    final foodKeys = foods.map((food) => GlobalKey()).toList();
    return Container(
      child: foods.isEmpty
          ? Center(
              child: EmptyView(
                type: EmptyType.empty,
              ),
            )
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100.px,
                  padding: EdgeInsets.all(8.px),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Colors.grey[200]!))),
                  child: Row(
                    children: [
                      if (foods[index].image != '')
                        Hero(
                          tag: 'food_image_${foods[index].id}',
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImagePreview(
                                    imageUrl: foods[index]
                                                .image
                                                .indexOf('food') !=
                                            -1
                                        ? APIs.foodPrefix + foods[index].image
                                        : APIs.imagePrefix + foods[index].image,
                                    tag: 'food_image_${foods[index].id}',
                                  ),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: foods[index].image.indexOf('food') != -1
                                  ? APIs.foodPrefix + foods[index].image
                                  : APIs.imagePrefix + foods[index].image,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error), // 加载失败时的图标
                              fadeInDuration: Duration(milliseconds: 500),
                              height: 80.px,
                              width: 80.px,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (foods[index].image == '')
                        Image.asset(
                          'assets/images/empty/空.png',
                          width: 80.px,
                          height: 80.px,
                        ),
                      SizedBox(
                        width: 8.px,
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
                                  fontSize: 12.px,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 3.px,
                          ),
                          Text(
                            S.current.remaining +
                                ':' +
                                foods[index].stock.toString(),
                            style: TextStyle(fontSize: 10.px),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                foods[index].price.toString(),
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 14.px,
                                    fontWeight: FontWeight.bold),
                              ),
                              Consumer<FoodViewModel>(
                                builder: (context, foodViewModel, child) {
                                  // 获取当前品在购物车中的数量
                                  final cartItem =
                                      foodViewModel.cartItems.firstWhere(
                                    (item) => item.id == foods[index].id,
                                    orElse: () => FoodModel(
                                      id: foods[index].id,
                                      name: foods[index].name,
                                      image: foods[index].image,
                                      price: foods[index].price,
                                      stock: foods[index].stock,
                                      num: 0,
                                    ),
                                  );

                                  return Row(
                                    children: [
                                      // 只有当商品在购物车中时才显示减号按钮和数量
                                      if (cartItem.num > 0) ...[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.zero,
                                              backgroundColor: primaryColor,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              minimumSize: Size(16.px, 16.px)),
                                          onPressed: () {
                                            context
                                                .read<FoodViewModel>()
                                                .decreaseQuantity(foods[index]);
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 18.px,
                                          ),
                                        ),
                                        SizedBox(width: 8.px),
                                        Text(
                                          cartItem.num.toString(),
                                          style: TextStyle(fontSize: 12.px),
                                        ),
                                        SizedBox(width: 8.px),
                                      ],
                                      // 添加到购物车按钮
                                      ElevatedButton(
                                        key: foodKeys[index],
                                        style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.zero,
                                            backgroundColor: primaryColor,
                                            // 缩小按钮的点击区域至实际内容大小
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            minimumSize: Size(16.px, 16.px)),
                                        onPressed: () {
                                          _addToCartAnimation(foodKeys[index]);
                                          context
                                              .read<FoodViewModel>()
                                              .addToCart(foods[index]);
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18.px,
                                        ),
                                      )
                                    ],
                                  );
                                },
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

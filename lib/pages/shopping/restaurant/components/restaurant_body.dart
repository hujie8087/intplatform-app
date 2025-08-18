import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:logistics_app/common_ui/KeepAliveWrapper.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_dialog.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
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
    RestaurantPickupViewModel(id: 3, name: S.current.takeout),
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
    try {
      DataUtils.getDetailById(
        APIs.getRestaurantDetail + '/' + widget.id.toString(),
        success: (data) {
          if (mounted) {
            restaurantDetail = RestaurantModel.fromJson(data['data']);
            pickTypes = restaurantDetail?.pickupTypeIds ?? [];
            setState(() {
              foodViewModel.initCartData(widget.id);
            });
          }
        },
        fail: (code, msg) {
          print('获取餐厅详情失败: $msg');
        },
      );

      DataUtils.getDetailById(
        APIs.getRestaurantMenuList + '/' + widget.id.toString(),
        success: (data) {
          if (mounted) {
            BaseListModel<FoodCategoryModel> result =
                BaseListModel<FoodCategoryModel>.fromJson(
                  data,
                  (json) => FoodCategoryModel.fromJson(json),
                );
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
          }
        },
        fail: (code, msg) {
          print('获取菜单列表失败: $msg');
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      print('数据加载异常: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
      bool isAtTop =
          _pageScrollController.position.pixels ==
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
    _xAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_circleAnimationController);
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
    // 监听右边菜单滚动 - 优化滚动性能
    _foodScrollController.addListener(() {
      final header = _foodScrollController.stickyHeaderScrollOffset.toInt();
      // 使用更高效的查找方式
      for (int i = 0; i < categories.length; i++) {
        final category = categories[i];
        final offset = categoryOffsetMap[category.id];
        if (offset != null && offset <= header && offset + 10 >= header) {
          if (i != selectedCategoryIndex) {
            // 使用 SchedulerBinding 来确保 setState 在下一帧调用
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  selectedCategoryIndex = i;
                });
              }
            });
          }
          break; // 找到匹配项后立即退出循环
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _foodScrollController.dispose();
    _pageScrollController.dispose();
    _categoryScrollController.dispose();
    _buttonAnimationController.dispose();
    _circleAnimationController.dispose();
    _removeOverlayEntry(); // 清理overlay
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
    BuildContext context,
    Offset start,
    Offset end,
  ) {
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
                child: CircleAvatar(radius: 12.px, backgroundColor: Colors.red),
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
      final buttonPosition = (buttonKey.currentContext?.findRenderObject()
              as RenderBox)
          .localToGlobal(Offset.zero);
      final cartPosition = (cartKey.currentContext?.findRenderObject()
              as RenderBox)
          .localToGlobal(Offset.zero);

      // 在 Overlay 上添加动画
      _overlayEntry = _createOverlayEntry(
        context,
        buttonPosition,
        cartPosition,
      );
      Overlay.of(context).insert(_overlayEntry!);

      // 开始动画
      _circleAnimationController.forward();
    }
  }

  // 点赞
  void _addCount(FoodModel food) async {
    ShoppingUtils.addCount(
      food.id,
      success: (data) {
        ProgressHUD.showText(S.current.likeSuccess);
        _fetchData();
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: foodViewModel,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            NestedScrollView(
              controller: _pageScrollController,
              headerSliverBuilder: (
                BuildContext context,
                bool innerBoxIsScrolled,
              ) {
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
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 60.px),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.px),
                              topRight: Radius.circular(16.px),
                            ),
                          ),
                          child: Column(children: [RestaurantInfo()]),
                        ),
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
                restaurantDetail: restaurantDetail,
              ),
            ),
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
                          fontSize: 16.px,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.px),
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
                                  color: secondaryColor,
                                  fontSize: 12.px,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10.px),
                          Text(
                            S.of(context).monthlySales + ":" + '300',
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 10.px),
                          Text(
                            S.of(context).diningTime + ":",
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor[100],
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Text(
                              '${restaurantDetail?.startTime} ~ ${restaurantDetail?.endTime}',
                              style: TextStyle(
                                fontSize: 10.px,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.px),
                      Row(
                        children:
                            pickTypes.map((label) {
                              return Container(
                                padding: EdgeInsets.only(
                                  left: 5.px,
                                  top: 2.px,
                                  right: 5.px,
                                  bottom: 2.px,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.px),
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  right: 5.px,
                                ), // 控制容器之间的间距
                                child: Text(
                                  pickupTypes
                                          .firstWhere(
                                            (element) => element.id == label,
                                          )
                                          .name ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 10.px,
                                    color: primaryColor,
                                  ),
                                ),
                              );
                            }).toList(), // 转换为列表,
                      ),
                    ],
                  ),
                ),
                if (restaurantDetail?.image != null)
                  Image.network(
                    restaurantDetail?.image?.indexOf('food') != -1
                        ? APIs.foodPrefix + restaurantDetail!.image!
                        : APIs.imagePrefix + restaurantDetail!.image!,
                    width: 60.px,
                    height: 60.px,
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
      margin: EdgeInsets.only(top: 12.px),
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
                  Text(i.label),
                  Container(
                    margin: EdgeInsets.only(top: 4.px),
                    height: 4.px,
                    width: 20.px,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      color:
                          i.value == _tabController.index
                              ? primaryColor
                              : Colors.transparent,
                    ),
                  ),
                ],
              ),
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
        border: Border(top: BorderSide(width: 0.5, color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          RestaurantOptions(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                KeepAliveWrapper(child: buildFoodMenu()),
                Center(child: Text(S.current.evaluation)),
                Center(child: Text(S.current.restaurant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 点菜UI
  Widget buildFoodMenu() {
    return Container(
      child:
          categories.isEmpty
              ? Center(
                child:
                    isLoading
                        ? ProgressDialog(hintText: S.current.loading)
                        : EmptyView(type: EmptyType.empty),
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
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.px),
                            color:
                                selectedCategoryIndex == index
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
                  // 右边食物列表 - 使用优化的滚动视图
                  Expanded(
                    child: CustomScrollView(
                      physics:
                          _isAtTop
                              ? ScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              )
                              : NeverScrollableScrollPhysics(),
                      controller: _categoryScrollController,
                      slivers: _buildOptimizedCategorySlivers(cartKey),
                    ),
                  ),
                ],
              ),
    );
  }

  // 优化的分类列表构建方法
  List<Widget> _buildOptimizedCategorySlivers(GlobalKey cartKey) {
    List<Widget> slivers = [];

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      slivers.add(
        SliverStickyHeader.builder(
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
                      .withOpacity(1.0 - state.scrollPercentage),
                ),
                textAlign: TextAlign.left,
              ),
            );
          },
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index == 0) {
                // 第一个子项是商品列表
                return buildOptimizedFoodList(
                  foods: category.foodCommodityList,
                  cartKey: cartKey,
                );
              } else if (index == 1 && categories.last.id == category.id) {
                // 最后一个分类的底部提示
                return Container(
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
                );
              }
              return null;
            }, childCount: categories.last.id == category.id ? 2 : 1),
          ),
        ),
      );
    }

    return slivers;
  }

  // 优化的菜品列表构建方法
  Widget buildOptimizedFoodList({
    required List<FoodModel> foods,
    required GlobalKey cartKey,
  }) {
    if (foods.isEmpty) {
      return Center(child: EmptyView(type: EmptyType.empty));
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return _buildOptimizedFoodItem(foods[index], cartKey);
      },
    );
  }

  // 优化的单个菜品项构建方法
  Widget _buildOptimizedFoodItem(FoodModel food, GlobalKey cartKey) {
    return RepaintBoundary(
      child: Container(
        height: 100.px,
        padding: EdgeInsets.all(8.px),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // 图片部分
            _buildFoodImage(food),
            SizedBox(width: 8.px),
            // 内容部分
            Expanded(child: _buildFoodContent(food, cartKey)),
          ],
        ),
      ),
    );
  }

  // 构建菜品图片
  Widget _buildFoodImage(FoodModel food) {
    if (food.image != '') {
      return RepaintBoundary(
        child: Hero(
          tag: 'food_image_${food.id}',
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ImagePreview(
                        imageUrl:
                            food.image.indexOf('food') != -1
                                ? APIs.foodPrefix + food.image
                                : APIs.imagePrefix + food.image,
                        tag: 'food_image_${food.id}',
                      ),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl:
                  food.image.indexOf('food') != -1
                      ? APIs.foodPrefix + food.image
                      : APIs.imagePrefix + food.image,
              errorWidget: (context, url, error) => Icon(Icons.error),
              fadeInDuration: Duration(milliseconds: 300), // 减少动画时间
              height: 80.px,
              width: 80.px,
              fit: BoxFit.cover,
              memCacheWidth: 160, // 优化内存缓存
              memCacheHeight: 160,
              maxWidthDiskCache: 320, // 磁盘缓存优化
              maxHeightDiskCache: 320,
              placeholder:
                  (context, url) => Container(
                    width: 80.px,
                    height: 80.px,
                    color: Colors.grey[200],
                    child: Center(
                      child: SizedBox(
                        width: 20.px,
                        height: 20.px,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.px,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ),
      );
    } else {
      return RepaintBoundary(
        child: Image.asset(
          'assets/images/empty/空.png',
          width: 80.px,
          height: 80.px,
        ),
      );
    }
  }

  // 构建菜品内容
  Widget _buildFoodContent(FoodModel food, GlobalKey cartKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                food.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 8.px),
            GestureDetector(
              onTap: () => _addCount(food),
              child: Column(
                children: [
                  Icon(Icons.thumb_up, color: primaryColor, size: 20.px),
                  Text(
                    food.count.toString(),
                    style: TextStyle(fontSize: 10.px),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 3.px),
        Text(
          S.current.remaining + ':' + food.stock.toString(),
          style: TextStyle(fontSize: 10.px),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              food.price.toString(),
              style: TextStyle(
                color: secondaryColor,
                fontSize: 14.px,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildFoodActions(food, cartKey),
          ],
        ),
      ],
    );
  }

  // 构建菜品操作按钮
  Widget _buildFoodActions(FoodModel food, GlobalKey cartKey) {
    return Consumer<FoodViewModel>(
      builder: (context, foodViewModel, child) {
        final cartItem = foodViewModel.cartItems.firstWhere(
          (item) => item.id == food.id,
          orElse:
              () => FoodModel(
                id: food.id,
                name: food.name,
                image: food.image,
                price: food.price,
                stock: food.stock,
                num: 0,
                count: food.count,
              ),
        );

        return Row(
          children: [
            if (cartItem.num > 0) ...[
              _buildDecreaseButton(food),
              SizedBox(width: 4.px),
              _buildQuantityInput(food, cartItem.num),
              SizedBox(width: 4.px),
            ],
            _buildAddButton(food, cartItem, cartKey),
          ],
        );
      },
    );
  }

  // 构建减少按钮
  Widget _buildDecreaseButton(FoodModel food) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        backgroundColor: primaryColor,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(16.px, 16.px),
      ),
      onPressed: () {
        foodViewModel.decreaseQuantity(food);
      },
      child: Icon(Icons.remove, color: Colors.white, size: 18.px),
    );
  }

  // 构建数量输入框
  Widget _buildQuantityInput(FoodModel food, int currentNum) {
    return Container(
      width: 38.px,
      height: 20.px,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: TextEditingController(text: currentNum.toString()),
        style: TextStyle(fontSize: 12.px),
        decoration: InputDecoration(border: InputBorder.none),
        onSubmitted: (value) {
          int? val = int.tryParse(value);
          if (val == null || val == '') {
            val = 0;
          }
          if (val > food.stock) {
            ProgressHUD.showText(S.current.exceedStock);
            val = food.stock;
          }
          foodViewModel.updateQuantity(food, val);
        },
      ),
    );
  }

  // 构建添加按钮
  Widget _buildAddButton(
    FoodModel food,
    FoodModel cartItem,
    GlobalKey cartKey,
  ) {
    final foodKey = GlobalKey();
    return ElevatedButton(
      key: foodKey,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        backgroundColor: primaryColor,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(16.px, 16.px),
      ),
      onPressed: () {
        if (cartItem.num >= food.stock) {
          ProgressHUD.showText(S.current.exceedStock);
          return;
        }
        _addToCartAnimation(foodKey);
        foodViewModel.addToCart(food);
      },
      child: Icon(Icons.add, color: Colors.white, size: 18.px),
    );
  }

  // 菜品分类UI - 保留原有方法以兼容
  Widget buildCategoryList({
    required FoodCategoryModel category,
    required GlobalKey cartKey,
  }) {
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
                  .withOpacity(1.0 - state.scrollPercentage),
            ),
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

  // 菜品UI - 优化版本，减少内存占用和提高性能
  Widget buildFoodList({required List<FoodModel> foods}) {
    if (foods.isEmpty) {
      return Center(child: EmptyView(type: EmptyType.empty));
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return _buildOptimizedFoodItem(foods[index], GlobalKey());
      },
    );
  }
}

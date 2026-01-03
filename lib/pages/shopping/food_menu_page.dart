import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/food_menu_model.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

@AppRoute(path: 'food_menu_page', name: '今日菜谱')
class FoodMenuPage extends StatefulWidget {
  const FoodMenuPage({Key? key}) : super(key: key);

  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage>
    with SingleTickerProviderStateMixin {
  // 当前选择的日期
  DateTime _selectedDate = DateTime.now();

  // 今日菜谱数据
  FoodMenuModel? _todayMenu;

  // 加载状态
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getTodayMenu();
  }

  // 获取今日菜谱
  Future<void> _getTodayMenu() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      ShoppingUtils.getTodayMenu(
        {'menuDate': _selectedDate.toString().split(' ')[0]},
        success: (data) {
          setState(() {
            var todayMenuList = data['data'];
            if (todayMenuList != null) {
              _todayMenu = FoodMenuModel.fromJson(todayMenuList);
            } else {
              _todayMenu = null;
            }
            _isLoading = false;
          });
        },
        fail: (code, msg) {
          setState(() {
            _errorMessage = '错误代码: $code, 错误信息: $msg';
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '获取菜谱失败: $e';
          _isLoading = false;
        });
      }
    }
  }

  // 根据餐次类型获取菜品列表
  List<Dishs> _getDishesByMealType(int mealType) {
    if (_todayMenu?.dishs == null) return [];
    return _todayMenu!.dishs!
        .where((dish) => dish.mealType == mealType)
        .toList();
  }

  // 获取餐次名称
  String _getMealTypeName(int mealType) {
    switch (mealType) {
      case 0:
        return S.current.breakfast;
      case 1:
        return S.current.lunch;
      case 2:
        return S.current.dinner;
      default:
        return S.current.other;
    }
  }

  // 选择日期
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 180)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      locale: const Locale('zh'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _getTodayMenu();
    }
  }

  // 构建单个分类列
  Widget _buildCategoryColumn(String title, List<Dishs> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.px),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.px,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.px),
              child: Text(
                '--',
                style: TextStyle(fontSize: 14.px, color: Colors.grey[400]),
              ),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.px),
                child: Text(
                  item.name ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.px,
                    color: Color(0xFF666666),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 构建餐次区块
  Widget _buildMealSection(int mealType) {
    final dishes = _getDishesByMealType(mealType);
    if (dishes.isEmpty) {
      // 即使为空也显示空位，或者隐藏？设计稿应该是固定的
      // 这里如果没数据就不显示
      return SizedBox.shrink();
    }

    // 分类
    List<Dishs> staples = [];
    List<Dishs> normalDishes = [];
    List<Dishs> soups = [];

    for (var dish in dishes) {
      if (dish.dishType == 0)
        staples.add(dish);
      else if (dish.dishType == 2)
        soups.add(dish);
      else
        normalDishes.add(dish);
    }

    String title = _getMealTypeName(mealType);
    if (title.length >= 2 && !title.contains('\n')) {
      // 竖排文字处理
      title = title.split('').join('\n');
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.px, vertical: 8.px),
      // 不设置固定高度，让他自适应内容，但给个最小高度保证对齐
      constraints: BoxConstraints(minHeight: 140.px),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            // 卡片背景
            Container(
              margin: EdgeInsets.only(left: 20.px), //留出标签位置
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(30.px, 16.px, 16.px, 16.px),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.px),
                border: Border.all(color: Color(0xFFA07D66), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFA07D66),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryColumn('主食', staples),
                  _buildCategoryColumn('菜品', normalDishes),
                  _buildCategoryColumn('汤品', soups),
                ],
              ),
            ),
            // 左侧标签 - 垂直居中
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 40.px,
                  height: 90.px,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF9E7E6B), // 稍微浅一点的棕色
                    borderRadius: BorderRadius.circular(20.px),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(2, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.px,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建顶部标题
  Widget _buildDailyMenuHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 20.px,
        bottom: 20.px,
      ), // 减少一点顶部padding，因为AppBar还在
      decoration: BoxDecoration(
        color: Color(0xFFDAC9B6), // 稍微浅一点的棕色
        image: DecorationImage(
          image: AssetImage('assets/images/food_menu_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          width: 260.px,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFAB4D20), width: 3.px), // 蓝色边框
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.px),
                child: Text(
                  '每日菜单',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.px,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAB4D20),
                    letterSpacing: 2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.px),
                color: Color(0xFFAB4D20), // 棕色底
                child: Text(
                  'Daily Menu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.px,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建加载状态
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFAB4D20)),
          SizedBox(height: 16.px),
          Text(
            S.of(context).loading_food_menu,
            style: TextStyle(fontSize: 14.px, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // 构建错误状态
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.px, color: Colors.red[300]),
          SizedBox(height: 16.px),
          Text(
            S.of(context).load_failed,
            style: TextStyle(
              fontSize: 16.px,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.px),
          Text(
            _errorMessage ?? S.of(context).unknown_error,
            style: TextStyle(fontSize: 14.px, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.px),
          ElevatedButton.icon(
            onPressed: _getTodayMenu,
            icon: Icon(Icons.refresh),
            label: Text(
              S.of(context).reload,
              style: TextStyle(fontSize: 12.px),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFAB4D20),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64.px, color: Colors.grey[300]),
          SizedBox(height: 16.px),
          Text(
            S.of(context).no_food_menu_info,
            style: TextStyle(
              fontSize: 16.px,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF4F0), // 背景色，浅米色
      appBar: AppBar(
        title: Text(S.of(context).food_menu, style: TextStyle(fontSize: 16.px)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _selectDate(context),
            tooltip: S.of(context).select_date,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getTodayMenu,
            tooltip: S.of(context).refresh_food_menu,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDailyMenuHeader(),
          Expanded(
            child:
                _isLoading
                    ? _buildLoadingState()
                    : _errorMessage != null
                    ? _buildErrorState()
                    : _todayMenu == null ||
                        _todayMenu!.dishs == null ||
                        _todayMenu!.dishs!.isEmpty
                    ? _buildEmptyState()
                    : ListView(
                      padding: EdgeInsets.only(bottom: 12.px),
                      children: [
                        _buildMealSection(0), // 早餐
                        _buildMealSection(1), // 午餐
                        _buildMealSection(2), // 晚餐
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6.px),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            _todayMenu?.remark ?? '',
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/food_menu_model.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/utils/color.dart';
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
        {
          'pageNum': 1,
          'pageSize': 100,
          'menuDate': _selectedDate.toString().split(' ')[0],
        },
        success: (data) {
          setState(() {
            var todayMenuList = data['rows'] as List;
            if (todayMenuList.isNotEmpty) {
              List<FoodMenuModel> rows =
                  todayMenuList.map((i) => FoodMenuModel.fromJson(i)).toList();
              if (rows.isNotEmpty) {
                _todayMenu = rows[0];
              } else {
                _todayMenu = null;
              }
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
      setState(() {
        _errorMessage = '获取菜谱失败: $e';
        _isLoading = false;
      });
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

  // 获取餐次图标
  IconData _getMealTypeIcon(int mealType) {
    switch (mealType) {
      case 0:
        return Icons.wb_sunny;
      case 1:
        return Icons.wb_sunny_outlined;
      case 2:
        return Icons.nights_stay;
      default:
        return Icons.restaurant;
    }
  }

  // 获取餐次颜色
  Color _getMealTypeColor(int mealType) {
    switch (mealType) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.red;
      case 2:
        return Colors.purple;
      default:
        return Colors.grey;
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

  // 构建菜品卡片
  Widget _buildDishCard(Dishs dish) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.px, vertical: 4.px),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.px)),
      child: ListTile(
        leading:
            dish.imageUrl != null && dish.imageUrl!.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.px),
                  child: Image.network(
                    APIs.imagePrefix + dish.imageUrl!,
                    width: 50.px,
                    height: 50.px,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50.px,
                        height: 50.px,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.px),
                        ),
                        child: Icon(Icons.restaurant, color: Colors.grey[400]),
                      );
                    },
                  ),
                )
                : Container(
                  width: 50.px,
                  height: 50.px,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.px),
                  ),
                  child: Icon(Icons.restaurant, color: Colors.grey[400]),
                ),
        title: Text(
          dish.name ?? S.of(context).unknown_dish,
          style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dish.englishName != null && dish.englishName!.isNotEmpty)
              Text(
                dish.englishName!,
                style: TextStyle(
                  fontSize: 10.px,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (dish.indonesianName != null && dish.indonesianName!.isNotEmpty)
              Text(
                dish.indonesianName!,
                style: TextStyle(fontSize: 10.px, color: Colors.grey[600]),
              ),
            if (dish.description != null && dish.description!.isNotEmpty)
              Text(
                dish.description!,
                style: TextStyle(fontSize: 10.px, color: Colors.grey[500]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing:
            dish.status == 1
                ? Icon(Icons.check_circle, color: primaryColor, size: 20.px)
                : Icon(Icons.cancel, color: secondaryColor, size: 20.px),
      ),
    );
  }

  // 构建餐次区块
  Widget _buildMealSection(int mealType) {
    final dishes = _getDishesByMealType(mealType);
    if (dishes.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16.px, 16.px, 16.px, 8.px),
          padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
          decoration: BoxDecoration(
            color: _getMealTypeColor(mealType).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.px),
            border: Border.all(
              color: _getMealTypeColor(mealType).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getMealTypeIcon(mealType),
                color: _getMealTypeColor(mealType),
                size: 16.px,
              ),
              SizedBox(width: 4.px),
              Text(
                _getMealTypeName(mealType),
                style: TextStyle(
                  fontSize: 12.px,
                  fontWeight: FontWeight.w600,
                  color: _getMealTypeColor(mealType),
                ),
              ),
              SizedBox(width: 4.px),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 2.px),
                decoration: BoxDecoration(
                  color: _getMealTypeColor(mealType),
                  borderRadius: BorderRadius.circular(10.px),
                ),
                child: Text(
                  '${dishes.length}${S.of(context).dishes}',
                  style: TextStyle(
                    fontSize: 10.px,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...dishes.map((dish) => _buildDishCard(dish)).toList(),
      ],
    );
  }

  // 构建日期显示
  Widget _buildDateHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.px),
          bottomRight: Radius.circular(10.px),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: primaryColor, size: 20.px),
          SizedBox(width: 8.px),
          Text(
            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
            style: TextStyle(
              fontSize: 14.px,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Spacer(),
          TextButton.icon(
            onPressed: () => _selectDate(context),
            icon: Icon(Icons.edit_calendar, size: 14.px),
            label: Text(
              S.of(context).select_date,
              style: TextStyle(fontSize: 12.px),
            ),
            style: TextButton.styleFrom(foregroundColor: primaryColor),
          ),
        ],
      ),
    );
  }

  // 构建加载状态
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
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
              backgroundColor: primaryColor,
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
          SizedBox(height: 8.px),
          Text(
            S.of(context).no_food_menu_info_tips,
            style: TextStyle(fontSize: 12.px, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).food_menu, style: TextStyle(fontSize: 16.px)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getTodayMenu,
            tooltip: S.of(context).refresh_food_menu,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateHeader(),
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
                    : RefreshIndicator(
                      onRefresh: _getTodayMenu,
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 16.px),
                        children: [
                          _buildMealSection(0), // 早餐
                          _buildMealSection(1), // 午餐
                          _buildMealSection(2), // 晚餐
                        ],
                      ),
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

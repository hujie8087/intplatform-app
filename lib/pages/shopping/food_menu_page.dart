import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class FoodMenuPage extends StatefulWidget {
  const FoodMenuPage({Key? key}) : super(key: key);

  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage>
    with SingleTickerProviderStateMixin {
  late TabController _mealTypeTabController;

  // 当前选择的日期
  DateTime _selectedDate = DateTime.now();

  // 当前选择的食堂
  String _selectedCanteen = '第一食堂';

  // 食堂列表
  final List<String> _canteens = ['第一食堂', '第二食堂', '第三食堂', '教师食堂'];

  // 餐点类型
  final List<String> _mealTypes = ['早餐', '午餐', '晚餐'];

  // 模拟的菜单数据
  final Map<String, Map<String, List<Dish>>> _menuData = {
    '第一食堂': {
      '早餐': [
        Dish(
          name: '豆浆',
          description: '现磨豆浆',
          imageUrl: 'assets/images/soy_milk.jpg',
        ),
        Dish(
          name: '油条',
          description: '酥脆可口',
          imageUrl: 'assets/images/fried_dough.jpg',
        ),
        Dish(
          name: '包子',
          description: '肉馅/菜馅',
          imageUrl: 'assets/images/baozi.jpg',
        ),
      ],
      '午餐': [
        Dish(
          name: '红烧肉盖饭',
          description: '经典美味',
          imageUrl: 'assets/images/braised_pork.jpg',
        ),
        Dish(
          name: '鱼香肉丝',
          description: '开胃下饭',
          imageUrl: 'assets/images/fish_flavored_pork.jpg',
        ),
        Dish(
          name: '西红柿鸡蛋面',
          description: '家常美味',
          imageUrl: 'assets/images/tomato_egg_noodles.jpg',
        ),
      ],
      '晚餐': [
        Dish(
          name: '麻辣香锅',
          description: '麻辣鲜香',
          imageUrl: 'assets/images/spicy_pot.jpg',
        ),
        Dish(
          name: '土豆牛肉',
          description: '营养搭配',
          imageUrl: 'assets/images/beef_potato.jpg',
        ),
        Dish(
          name: '炒时蔬',
          description: '新鲜蔬菜',
          imageUrl: 'assets/images/vegetables.jpg',
        ),
      ],
    },
    '第二食堂': {
      '早餐': [
        Dish(
          name: '小米粥',
          description: '养胃健康',
          imageUrl: 'assets/images/millet_porridge.jpg',
        ),
        Dish(
          name: '煎饼',
          description: '薄脆可口',
          imageUrl: 'assets/images/pancake.jpg',
        ),
      ],
      '午餐': [
        Dish(
          name: '宫保鸡丁',
          description: '香辣可口',
          imageUrl: 'assets/images/kungpao_chicken.jpg',
        ),
        Dish(
          name: '清蒸鱼',
          description: '鲜嫩多汁',
          imageUrl: 'assets/images/steamed_fish.jpg',
        ),
      ],
      '晚餐': [
        Dish(
          name: '馄饨汤',
          description: '鲜美汤底',
          imageUrl: 'assets/images/wonton_soup.jpg',
        ),
        Dish(
          name: '炸酱面',
          description: '经典面食',
          imageUrl: 'assets/images/noodles.jpg',
        ),
      ],
    },
    '第三食堂': {
      '早餐': [
        Dish(
          name: '牛奶',
          description: '营养丰富',
          imageUrl: 'assets/images/milk.jpg',
        ),
        Dish(
          name: '三明治',
          description: '快捷美味',
          imageUrl: 'assets/images/sandwich.jpg',
        ),
      ],
      '午餐': [
        Dish(
          name: '咖喱饭',
          description: '浓郁美味',
          imageUrl: 'assets/images/curry_rice.jpg',
        ),
        Dish(
          name: '酸菜鱼',
          description: '酸辣开胃',
          imageUrl: 'assets/images/fish_pickled_cabbage.jpg',
        ),
      ],
      '晚餐': [
        Dish(
          name: '烤肉饭',
          description: '香气四溢',
          imageUrl: 'assets/images/bbq_rice.jpg',
        ),
        Dish(
          name: '意大利面',
          description: '西式美味',
          imageUrl: 'assets/images/pasta.jpg',
        ),
      ],
    },
    '教师食堂': {
      '早餐': [
        Dish(
          name: '皮蛋瘦肉粥',
          description: '滋补养生',
          imageUrl: 'assets/images/congee.jpg',
        ),
        Dish(
          name: '豆沙包',
          description: '甜香可口',
          imageUrl: 'assets/images/red_bean_bun.jpg',
        ),
      ],
      '午餐': [
        Dish(
          name: '北京烤鸭',
          description: '皮酥肉嫩',
          imageUrl: 'assets/images/peking_duck.jpg',
        ),
        Dish(
          name: '清炒虾仁',
          description: '鲜美原味',
          imageUrl: 'assets/images/shrimp.jpg',
        ),
      ],
      '晚餐': [
        Dish(
          name: '羊肉煲',
          description: '温补滋养',
          imageUrl: 'assets/images/mutton_pot.jpg',
        ),
        Dish(
          name: '菌菇汤',
          description: '鲜香浓郁',
          imageUrl: 'assets/images/mushroom_soup.jpg',
        ),
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _mealTypeTabController = TabController(
      length: _mealTypes.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _mealTypeTabController.dispose();
    super.dispose();
  }

  // 选择日期
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      locale: const Locale('zh'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('每日菜单', style: TextStyle(fontSize: 16.px)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
            tooltip: '选择日期',
          ),
        ],
      ),
      body: Column(
        children: [
          // 日期显示
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.today, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  DateFormat('yyyy年MM月dd日').format(_selectedDate),
                  style: TextStyle(
                    fontSize: 18.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 食堂选择器
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: DropdownButton<String>(
              value: _selectedCanteen,
              isExpanded: true,
              icon: const Icon(Icons.restaurant_menu),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCanteen = newValue;
                  });
                }
              },
              items:
                  _canteens.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 16)),
                    );
                  }).toList(),
            ),
          ),
          SizedBox(height: 12.px),
          // 菜单列表
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TabBar(
              controller: _mealTypeTabController,
              tabs: _mealTypes.map((type) => Tab(text: type)).toList(),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.px,
                color: Colors.black,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16.px,
              ),
              // 下划线
              indicator: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorColor: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 12.px),
          Expanded(
            child: TabBarView(
              controller: _mealTypeTabController,
              children:
                  _mealTypes.map((mealType) {
                    List<Dish> dishes =
                        _menuData[_selectedCanteen]?[mealType] ?? [];

                    if (dishes.isEmpty) {
                      return const Center(
                        child: Text(
                          '暂无菜单信息',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: dishes.length,
                      itemBuilder: (context, index) {
                        final dish = dishes[index];
                        return GestureDetector(
                          onTap: () => _showDishDetail(context, dish),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 菜品图片
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.asset(
                                      dish.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: Icon(
                                              Icons.restaurant,
                                              color: Colors.grey,
                                              size: 40,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // 菜品信息
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dish.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          dish.description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 这里可以添加编辑菜单的功能
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('编辑菜单功能待开发')));
        },
        child: const Icon(Icons.edit),
        tooltip: '编辑菜单',
      ),
    );
  }

  // 显示菜品详情
  void _showDishDetail(BuildContext context, Dish dish) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 顶部拖动条
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // 菜品图片
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.asset(
                    dish.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // 菜品信息
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        dish.description,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '菜品标签',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDishTags(),
                      const SizedBox(height: 24),
                      const Text(
                        '用户评价',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildReviews(),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // 菜品标签小部件
  Widget _buildDishTags() {
    final List<String> tags = ['热门', '推荐', '健康', '新品'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
    );
  }

  // 用户评价小部件
  Widget _buildReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReviewItem('张三', 4.5, '味道不错，下次还会再来！'),
        const Divider(),
        _buildReviewItem('李四', 5.0, '这个菜很好吃，强烈推荐！'),
      ],
    );
  }

  Widget _buildReviewItem(String user, double rating, String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                user,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _buildRatingStars(rating),
            ],
          ),
          const SizedBox(height: 6),
          Text(comment, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index < rating.ceil() && rating.floor() != rating.ceil()) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 16);
        }
      }),
    );
  }
}

// 菜品类
class Dish {
  final String name;
  final String description;
  final String imageUrl;

  Dish({required this.name, required this.description, required this.imageUrl});
}

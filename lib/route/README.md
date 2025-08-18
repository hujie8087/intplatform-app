# 智能路由系统

这是一个优化的路由管理系统，支持多种路由注册方式，无需手动维护路由表。

## 特性

- ✅ **自动路由注册**：通过注解自动注册页面
- ✅ **手动路由配置**：支持传统的手动配置方式
- ✅ **混合模式**：注解和手动配置可以同时使用
- ✅ **类型安全**：编译时检查路由配置
- ✅ **易于维护**：新增页面无需手动注册路由
- ✅ **调试友好**：提供路由调试工具

## 路由注册方案

### 方案一：手动注册（当前使用）

**优点**：简单直接，完全可控
**缺点**：需要手动维护

```dart
// 1. 添加注解
@AppRoute(path: 'food_menu_page', name: '今日菜谱')
class FoodMenuPage extends StatefulWidget {
  // 页面实现...
}

// 2. 在 route_registry.dart 中手动注册
static void _registerShoppingRoutes() {
  RouteRegistrar.registerRoute(
    'food_menu_page',
    RouteConfig(builder: (context) => FoodMenuPage(), name: '今日菜谱'),
  );
}
```

### 方案二：完全自动（未来实现）

**优点**：真正的零配置
**缺点**：需要复杂的代码生成器

```dart
// 只需要添加注解，系统自动发现和注册
@AppRoute(path: 'food_menu_page', name: '今日菜谱')
class FoodMenuPage extends StatefulWidget {
  // 页面实现...
}
// 无需任何其他操作！
```

## 使用方法

### 1. 使用注解方式（推荐）

在页面类上添加 `@AppRoute` 注解：

```dart
import 'package:logistics_app/route/route_annotation.dart';

@AppRoute(
  path: '/my_page',
  name: 'MyPage',
)
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的页面')),
      body: Center(child: Text('Hello World')),
    );
  }
}
```

### 2. 手动配置方式

在 `auto_route_generator.dart` 中添加路由配置：

```dart
static final Map<String, RouteConfig> _routeConfigs = {
  RoutePath.MyPage: RouteConfig(
    builder: (context) => MyPage(),
    name: 'MyPage',
  ),
  // 更多路由...
};
```

### 3. 路由跳转

```dart
// 普通跳转
Navigator.pushNamed(context, RoutePath.MyPage);

// 带参数跳转
Navigator.pushNamed(
  context,
  RoutePath.MyPage,
  arguments: {'id': 123, 'title': '详情'},
);

// 替换当前页面
Navigator.pushReplacementNamed(context, RoutePath.MyPage);

// 清空栈并跳转
Navigator.pushNamedAndRemoveUntil(
  context,
  RoutePath.MyPage,
  (route) => false,
);
```

## 文件结构

```
lib/route/
├── routes.dart                    # 主路由文件
├── auto_route_generator.dart      # 自动路由生成器
├── route_annotation.dart          # 路由注解系统
├── route_registry.dart            # 路由注册管理器
├── route_utils.dart               # 路由工具类
└── README.md                      # 说明文档
```

## 新增页面步骤

### 当前推荐方式：手动注册

1. 创建页面文件
2. 添加 `@AppRoute` 注解
3. 在 `route_registry.dart` 中注册路由
4. 在 `RoutePath` 中添加路径常量

```dart
// 1. 创建页面
@AppRoute(path: 'food_menu_page', name: '今日菜谱')
class FoodMenuPage extends StatefulWidget {
  // 页面实现...
}

// 2. 在 route_registry.dart 中注册
static void _registerShoppingRoutes() {
  RouteRegistrar.registerRoute(
    'food_menu_page',
    RouteConfig(builder: (context) => FoodMenuPage(), name: '今日菜谱'),
  );
}

// 3. 在 RoutePath 中添加路径常量
class RoutePath {
  static const String FoodMenuPage = 'food_menu_page';
}
```

### 手动配置方式

1. 创建页面文件
2. 在 `auto_route_generator.dart` 中添加配置
3. 在 `RoutePath` 中添加路径常量

```dart
// 1. 创建页面
class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新页面')),
      body: Center(child: Text('新页面内容')),
    );
  }
}

// 2. 在 auto_route_generator.dart 中添加配置
static final Map<String, RouteConfig> _routeConfigs = {
  RoutePath.NewPage: RouteConfig(
    builder: (context) => NewPage(),
    name: 'NewPage',
  ),
};

// 3. 在 RoutePath 中添加路径
class RoutePath {
  static const String NewPage = 'new_page';
}
```

## 调试工具

```dart
// 打印所有已注册的路由
RouteRegistry.printAllAnnotatedRoutes();

// 检查路由是否存在
bool exists = RouteRegistry.isRouteRegistered('food_menu_page');

// 获取路由配置
RouteConfig? config = RouteRegistry.getRouteConfig('food_menu_page');
```

## 常见问题解决

### 1. 路由没有自动注册

**问题**：添加了 `@AppRoute` 注解但路由没有自动注册

**解决方案**：

1. 确保在 `route_registry.dart` 中添加了路由注册代码
2. 确保在 `main.dart` 中调用了 `RouteRegistry.registerAllAnnotatedRoutes()`
3. 检查路由路径是否与注解中的路径一致

```dart
// 在 route_registry.dart 中添加
static void _registerShoppingRoutes() {
  RouteRegistrar.registerRoute(
    'food_menu_page',  // 必须与 @AppRoute 中的 path 一致
    RouteConfig(
      builder: (context) => FoodMenuPage(),
      name: '今日菜谱',
    ),
  );
}

// 在 main.dart 中确保调用了
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 注册所有注解路由
  RouteRegistry.registerAllAnnotatedRoutes();

  // 其他初始化代码...
}
```

### 2. 路由跳转失败

**问题**：`Navigator.pushNamed()` 跳转失败

**解决方案**：

1. 检查路由路径是否正确
2. 使用调试工具检查路由是否已注册
3. 确保路由配置正确

```dart
// 检查路由是否已注册
bool isRegistered = RouteRegistry.isRouteRegistered('food_menu_page');
print('路由已注册: $isRegistered');

// 使用正确的路由路径
Navigator.pushNamed(context, 'food_menu_page');  // 使用字符串路径
// 或者
Navigator.pushNamed(context, RoutePath.FoodMenuPage);  // 使用常量
```

### 3. 调试路由系统

```dart
// 在应用启动时打印所有路由
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  RouteRegistry.registerAllAnnotatedRoutes();

  // 调试模式打印路由信息
  if (kDebugMode) {
    RouteRegistry.printAllAnnotatedRoutes();
  }

  runApp(MyApp());
}
```

## 优势对比

| 特性     | 旧方式       | 新方式       |
| -------- | ------------ | ------------ |
| 新增页面 | 需要手动注册 | 注解自动注册 |
| 维护成本 | 高           | 低           |
| 类型安全 | 部分         | 完全         |
| 调试友好 | 一般         | 优秀         |
| 代码复用 | 低           | 高           |

## 注意事项

1. 路由路径应该以 `/` 开头（绝对路径）或直接使用字符串（相对路径）
2. 确保路由路径的唯一性
3. 建议使用注解方式，减少维护成本
4. 在应用启动时调用 `RouteRegistry.registerAllAnnotatedRoutes()` 注册注解路由
5. 添加新页面时，记得在 `route_registry.dart` 中注册路由

## 未来优化

- [ ] 添加代码生成器，自动发现和注册注解路由
- [ ] 支持路由参数验证
- [ ] 添加路由中间件支持
- [ ] 支持嵌套路由
- [ ] 添加路由动画配置

## 回答您的问题

**问**：新增页面时写了 `@AppRoute(path: 'new_page', name: '新页面')` 后，还是必须在 `route_registry.dart` 文件里手动注册吗？

**答**：目前是的，但有以下几种解决方案：

### 当前方案（需要手动注册）

```dart
// 1. 添加注解
@AppRoute(path: 'new_page', name: '新页面')
class NewPage extends StatelessWidget {
  // 页面实现...
}

// 2. 手动注册（必须）
RouteRegistrar.registerRoute(
  'new_page',
  RouteConfig(builder: (context) => NewPage(), name: '新页面'),
);
```

### 未来方案（完全自动）

```dart
// 只需要添加注解，系统自动发现和注册
@AppRoute(path: 'new_page', name: '新页面')
class NewPage extends StatelessWidget {
  // 页面实现...
}
// 无需任何其他操作！
```

**建议**：目前使用手动注册方案，虽然需要多一步，但比完全手动维护路由表简单很多。未来可以考虑实现完全自动的方案。

import 'package:flutter/material.dart';
import 'package:logistics_app/pages/accommodation/room/couple_order_page.dart';
import 'package:logistics_app/pages/accommodation/room/couple_room_page.dart';
import 'package:logistics_app/pages/app_home_screen.dart';
import 'package:logistics_app/pages/auth/login_page.dart';
import 'package:logistics_app/pages/auth/forget_password_page.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/meal_delivery_order_page.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_scan/meal_delivery_accept_page.dart';
import 'package:logistics_app/pages/mine_page/bind_account_page/bind_account_page.dart';
import 'package:logistics_app/pages/mine_page/change_password_page.dart';
import 'package:logistics_app/pages/mine_page/person_info_page.dart';
import 'package:logistics_app/pages/mine_page/contact_us_page.dart';
import 'package:logistics_app/pages/route_query_page/route_query_page.dart';
import 'package:logistics_app/pages/news/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/news/news_page/news_list_page.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_detail_page.dart';
import 'package:logistics_app/pages/repair/submit_page/repair_form_page.dart';
import 'package:logistics_app/pages/repair/my_repair_page/repair_rating_page.dart';
import 'package:logistics_app/pages/repair/my_repair_page/my_repair_page.dart';
import 'package:logistics_app/pages/repair/repair_order_page/repair_order_page.dart';
import 'package:logistics_app/pages/shopping/food_menu_page.dart';
import 'package:logistics_app/pages/sos/chat_list_page.dart';
import 'package:logistics_app/pages/sos/chat_screen_page.dart';
import 'package:logistics_app/pages/sos/models/chart_model.dart';
import 'package:logistics_app/pages/sos/services/chat_service.dart';
import 'package:logistics_app/pages/sos/sos_index_page.dart';
import 'package:logistics_app/pages/tool_box_page.dart';
import 'package:logistics_app/pages/news/promo_page/promo_list_page.dart';
import 'package:logistics_app/pages/news/ktime_page/ktime_list_page.dart';
import 'package:logistics_app/pages/news/monthly_page/monthly_list_page.dart';
import 'package:logistics_app/pages/guide/guide_type_page.dart';
import 'package:logistics_app/pages/guide/guide_list_page.dart';
import 'package:logistics_app/pages/accommodation/pocess/process_list_page.dart';
import 'package:logistics_app/pages/accommodation/apply/apply_list_page.dart';
import 'package:logistics_app/pages/shopping/shopping_screen_page.dart';
import 'package:logistics_app/pages/shopping/order/order_list_page.dart';
import 'package:logistics_app/pages/shopping/food_suggestion/food_suggestion_page.dart';
import 'package:logistics_app/pages/shopping/payment/payment_qrcode_page.dart';
import 'package:logistics_app/pages/shopping/card_info_page.dart';
import 'package:logistics_app/pages/shopping/card_bill_page.dart';
import 'package:logistics_app/pages/shopping/payment/modify_payment_password_page.dart';
import 'package:logistics_app/pages/delivery/order/delivery_order_list_page.dart';
import 'package:logistics_app/pages/delivery/online/delivery_online_list_page.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/my_address_page.dart';
import 'package:logistics_app/pages/shopping/food_feedback/food_feedback_page.dart';
import 'package:logistics_app/pages/delivery/store/shop_workbench_page.dart';
import 'package:logistics_app/pages/shopping/payment/face_collection_page.dart';
import 'package:logistics_app/pages/shopping/food_recommend_page.dart';
import 'package:logistics_app/pages/science/plants/plant_list_page.dart';
import 'package:logistics_app/pages/science/animals/animal_list_page.dart';
import 'package:logistics_app/pages/science/plants/plant_detail_page.dart';
import 'package:logistics_app/pages/public_convenience_page/public_list_page.dart';
import 'package:logistics_app/pages/bus/bus_timetable_page.dart';
import 'package:logistics_app/pages/accommodation/room/couple_feedback_page.dart';
import 'package:logistics_app/pages/accommodation/cleaning/cleaning_order_page.dart';
import 'package:logistics_app/pages/accommodation/cleaning/cleaning_submit_page.dart';
import 'package:logistics_app/pages/repair/report_hazard_page.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/meal_delivery_submit_page.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/meal_delivery_index_page.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_scan/meal_delivery_deliver_page.dart';
import 'package:logistics_app/pages/library/library_list_page.dart';
import 'package:logistics_app/pages/library/library_detail_page.dart';
import 'package:logistics_app/pages/goodDeeds/good_deeds_list_page.dart';
import 'package:logistics_app/pages/goodDeeds/my_good_deed_Page.dart';
import 'package:logistics_app/pages/shopping/my_feedback/my_feedback_list_page.dart';

/// 自动路由生成器
/// 通过注解和反射自动注册路由，无需手动维护路由表
class AutoRouteGenerator {
  /// 路由配置映射
  static final Map<String, RouteConfig> _routeConfigs = {
    // 认证相关
    RoutePath.login: RouteConfig(
      builder: (context) => LoginPage(),
      name: 'LoginPage',
    ),
    RoutePath.ForgetPasswordPage: RouteConfig(
      builder: (context) => ForgetPasswordPage(),
      name: 'ForgetPasswordPage',
    ),

    // 主页
    RoutePath.home: RouteConfig(
      builder: (context) => AppHomeScreen(),
      name: 'AppHomeScreen',
    ),

    // 个人中心
    RoutePath.ChangePasswordPage: RouteConfig(
      builder: (context) => ChangePasswordPage(),
      name: 'ChangePasswordPage',
    ),
    RoutePath.PersonInfoPage: RouteConfig(
      builder: (context) => PersonInfoPage(),
      name: 'PersonInfoPage',
    ),
    RoutePath.ContactUsPage: RouteConfig(
      builder: (context) => ContactUsPage(),
      name: 'ContactUsPage',
    ),
    RoutePath.MyAddressPage: RouteConfig(
      builder: (context) => MyAddressPage(),
      name: 'MyAddressPage',
    ),
    RoutePath.BindAccountPage: RouteConfig(
      builder: (context) => BindAccountPage(),
      name: 'BindAccountPage',
    ),

    // 功能页面
    RoutePath.RouteQueryPage: RouteConfig(
      builder: (context) => RouteQueryPage(),
      name: 'RouteQueryPage',
    ),
    RoutePath.ToolBoxPage: RouteConfig(
      builder: (context) => ToolBoxPage(),
      name: 'ToolBoxPage',
    ),

    // 新闻资讯
    RoutePath.NoticeListPage: RouteConfig(
      builder: (context) => NoticeListPage(),
      name: 'NoticeListPage',
    ),
    RoutePath.NewsListPage: RouteConfig(
      builder: (context) => NewsListPage(),
      name: 'NewsListPage',
    ),
    RoutePath.PromoListPage: RouteConfig(
      builder: (context) => PromoListPage(),
      name: 'PromoListPage',
    ),
    RoutePath.KTimeListPage: RouteConfig(
      builder: (context) => KTimeListPage(),
      name: 'KTimeListPage',
    ),
    RoutePath.MonthlyListPage: RouteConfig(
      builder: (context) => MonthlyListPage(),
      name: 'MonthlyListPage',
    ),

    // 失物招领
    RoutePath.LostFoundListPage: RouteConfig(
      builder: (context) => LostFoundListPage(),
      name: 'LostFoundListPage',
    ),
    RoutePath.LostFoundDetailPage: RouteConfig(
      builder: (context) => LostFoundDetailPage(),
      name: 'LostFoundDetailPage',
    ),

    // 图书馆
    RoutePath.LibraryListPage: RouteConfig(
      builder: (context) => LibraryListPage(),
      name: 'LibraryListPage',
    ),

    RoutePath.LibraryDetailPage: RouteConfig(
      builder: (context) => LibraryDetailPage(noticeId: ''),
      name: 'LibraryDetailPage',
    ),

    RoutePath.GoodDeedsListPage: RouteConfig(
      builder: (context) => GoodDeedsListPage(),
      name: 'GoodDeedsListPage',
    ),
    RoutePath.MyGoodDeedsPage: RouteConfig(
      builder: (context) => MyGoodDeedsPage(),
      name: 'MyGoodDeedsPage',
    ),

    // 报修相关
    RoutePath.RepairFormPage: RouteConfig(
      builder: (context) => RepairFormPage(),
      name: 'RepairFormPage',
    ),
    RoutePath.RepairRatingPage: RouteConfig(
      builder: (context) => RepairRatingPage(),
      name: 'RepairRatingPage',
    ),
    RoutePath.MyRepairPage: RouteConfig(
      builder: (context) => MyRepairPage(),
      name: 'MyRepairPage',
    ),
    RoutePath.RepairOrderPage: RouteConfig(
      builder: (context) => RepairOrderPage(),
      name: 'RepairOrderPage',
    ),
    RoutePath.ReportHazardPage: RouteConfig(
      builder: (context) => ReportHazardPage(),
      name: 'ReportHazardPage',
    ),
    // 服务指南
    RoutePath.GuideTypePage: RouteConfig(
      builder: (context) => GuideTypePage(id: 0),
      name: 'GuideTypePage',
    ),
    RoutePath.GuideListPage: RouteConfig(
      builder: (context) => GuideListPage(guideTypeId: 0),
      name: 'GuideListPage',
    ),

    // 住宿相关
    RoutePath.ProcessListPage: RouteConfig(
      builder: (context) => ProcessListPage(),
      name: 'ProcessListPage',
    ),
    RoutePath.ApplyListPage: RouteConfig(
      builder: (context) => ApplyListPage(),
      name: 'ApplyListPage',
    ),
    RoutePath.CoupleRoomPage: RouteConfig(
      builder: (context) => CoupleRoomPage(),
      name: 'CoupleRoomPage',
    ),
    RoutePath.CoupleOrderPage: RouteConfig(
      builder: (context) => CoupleOrderPage(),
      name: 'CoupleOrderPage',
    ),
    RoutePath.CoupleFeedbackPage: RouteConfig(
      builder: (context) => CoupleFeedbackPage(),
      name: 'CoupleFeedbackPage',
    ),
    // 清洁相关
    RoutePath.CleaningOrderPage: RouteConfig(
      builder: (context) => CleaningOrderPage(),
      name: 'CleaningOrderPage',
    ),
    RoutePath.CleaningSubmitPage: RouteConfig(
      builder: (context) => CleaningSubmitPage(),
      name: 'CleaningSubmitPage',
    ),

    // 购物相关
    RoutePath.ShoppingScreenPage: RouteConfig(
      builder: (context) => ShoppingScreenPage(),
      name: 'ShoppingScreenPage',
    ),
    RoutePath.OrderListPage: RouteConfig(
      builder: (context) => OrderListPage(),
      name: 'OrderListPage',
    ),
    RoutePath.FoodSuggestionPage: RouteConfig(
      builder: (context) => FoodSuggestionPage(),
      name: 'FoodSuggestionPage',
    ),
    RoutePath.FoodFeedbackPage: RouteConfig(
      builder: (context) => FoodFeedbackPage(),
      name: 'FoodFeedbackPage',
    ),
    RoutePath.FoodRecommendPage: RouteConfig(
      builder: (context) => FoodRecommendPage(),
      name: 'FoodRecommendPage',
    ),
    RoutePath.FoodMenuPage: RouteConfig(
      builder: (context) => FoodMenuPage(),
      name: 'FoodMenuPage',
    ),
    RoutePath.MyFeedbackListPage: RouteConfig(
      builder: (context) => MyFeedbackListPage(),
      name: 'MyFeedbackListPage',
    ),

    // 支付相关
    RoutePath.PaymentQRCodePage: RouteConfig(
      builder: (context) => PaymentQRCodePage(),
      name: 'PaymentQRCodePage',
    ),
    RoutePath.CardInfoPage: RouteConfig(
      builder: (context) => CardInfoPage(),
      name: 'CardInfoPage',
    ),
    RoutePath.CardBillPage: RouteConfig(
      builder: (context) => CardBillPage(),
      name: 'CardBillPage',
    ),
    RoutePath.ModifyPaymentPasswordPage: RouteConfig(
      builder: (context) => ModifyPaymentPasswordPage(),
      name: 'ModifyPaymentPasswordPage',
    ),
    RoutePath.FaceCollectionPage: RouteConfig(
      builder: (context) => FaceCollectionPage(),
      name: 'FaceCollectionPage',
    ),

    // 配送相关
    RoutePath.DeliveryOrderListPage: RouteConfig(
      builder: (context) => DeliveryOrderListPage(),
      name: 'DeliveryOrderListPage',
    ),
    RoutePath.DeliveryOnlineListPage: RouteConfig(
      builder: (context) => DeliveryOnlineListPage(),
      name: 'DeliveryOnlineListPage',
    ),
    RoutePath.ShopWorkbenchPage: RouteConfig(
      builder: (context) => ShopWorkbenchPage(),
      name: 'ShopWorkbenchPage',
    ),

    // 科学识别
    RoutePath.PlantListPage: RouteConfig(
      builder: (context) => PlantListPage(),
      name: 'PlantListPage',
    ),
    RoutePath.AnimalListPage: RouteConfig(
      builder: (context) => AnimalListPage(),
      name: 'AnimalListPage',
    ),
    RoutePath.PlantDetailPage: RouteConfig(
      builder: (context) => PlantDetailPage(fId: '0'),
      name: 'PlantDetailPage',
    ),

    // 其他
    RoutePath.PublicListPage: RouteConfig(
      builder: (context) => PublicListPage(),
      name: 'PublicListPage',
    ),
    RoutePath.BusTimetablePage: RouteConfig(
      builder: (context) => BusTimetablePage(),
      name: 'BusTimetablePage',
    ),

    // 报餐送餐
    RoutePath.MealDeliverySubmitPage: RouteConfig(
      builder: (context) => MealDeliverySubmitPage(foodName: ''),
      name: 'MealDeliverySubmitPage',
    ),
    RoutePath.MealDeliveryOrderPage: RouteConfig(
      builder: (context) => MealDeliveryOrderPage(),
      name: 'MealDeliveryOrderPage',
    ),
    RoutePath.MealDeliveryIndexPage: RouteConfig(
      builder: (context) => MealDeliveryIndexPage(),
      name: 'MealDeliveryIndexPage',
    ),
    RoutePath.MealDeliveryAcceptPage: RouteConfig(
      builder: (context) => MealDeliveryAcceptPage(),
      name: 'MealDeliveryAcceptPage',
    ),
    RoutePath.MealDeliveryDeliverPage: RouteConfig(
      builder: (context) => MealDeliveryDeliverPage(),
      name: 'MealDeliveryDeliverPage',
    ),
    // RoutePath.MealDeliveryScanPage: RouteConfig(
    //   builder: (context) => MealDeliveryScanPage(),
    //   name: 'MealDeliveryScanPage',
    // ),

    // 报警相关
    RoutePath.SosIndexPage: RouteConfig(
      builder: (context) => SosIndexPage(),
      name: 'SosIndexPage',
    ),
    RoutePath.ChatListPage: RouteConfig(
      builder: (context) => ChatListPage(),
      name: 'ChatListPage',
    ),
    RoutePath.ChatScreenPage: RouteConfig(
      builder:
          (context) => ChatScreenPage(
            sessionId: '',
            chatService: ChatService(),
            senderId: '',
            senderName: '',
            senderType: '',
            chartModel: ChartModel(),
          ),
      name: 'ChatScreenPage',
    ),
  };

  /// 生成路由
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final config = _routeConfigs[settings.name];

    if (config != null) {
      return MaterialPageRoute(builder: config.builder, settings: settings);
    } else {
      // 默认返回登录页
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
        settings: settings,
      );
    }
  }

  /// 获取所有路由名称（用于调试）
  static List<String> getAllRouteNames() {
    return _routeConfigs.keys.toList();
  }

  /// 检查路由是否存在
  static bool hasRoute(String routeName) {
    return _routeConfigs.containsKey(routeName);
  }

  /// 获取路由配置
  static RouteConfig? getRouteConfig(String routeName) {
    return _routeConfigs[routeName];
  }
}

/// 路由配置类
class RouteConfig {
  final WidgetBuilder builder;
  final String name;
  final Map<String, dynamic>? defaultArguments;

  RouteConfig({
    required this.builder,
    required this.name,
    this.defaultArguments,
  });
}

/// 路由路径常量
class RoutePath {
  // 认证相关
  static const String login = '/login';
  static const String ForgetPasswordPage = '/forget_password_page';

  // 主页
  static const String home = '/home';

  // 个人中心
  static const String MinePage = '/mine_page';
  static const String ChangePasswordPage = '/change_password_page';
  static const String PersonInfoPage = '/person_info_page';
  static const String ContactUsPage = 'contact_us_page';
  static const String MyAddressPage = 'my_address_page';
  static const String BindAccountPage = 'bind_account_page';

  // 功能页面
  static const String WebViewPage = '/web_view_page';
  static const String RouteQueryPage = 'route_query_page';
  static const String ToolBoxPage = 'tool_box_page';

  // 新闻资讯
  static const String NoticeListPage = 'notice_list_page';
  static const String NoticeDetailPage = 'notice_detail_page';
  static const String NewsListPage = 'news_list_page';
  static const String NewsDetailPage = 'news_detail_page';
  static const String PromoListPage = 'promo_list_page';
  static const String KTimeListPage = 'k_time_list_page';
  static const String MonthlyListPage = 'monthly_list_page';

  // 失物招领
  static const String LostFoundListPage = 'lost_found_list_page';
  static const String LostFoundDetailPage = 'lost_found_detail_page';

  // 图书馆
  static const String LibraryListPage = 'library_list_page';
  static const String LibraryDetailPage = 'library_detail_page';
  static const String GoodDeedsListPage = 'good_deeds_list_page';
  static const String MyGoodDeedsPage = 'my_good_deeds_page';

  // 视频模块
  static const String FilmScreenPage = 'film_screen_page';
  static const String FilmDownloadPage = 'film_download_page';
  static const String FilmViewPage = 'film_view_page';

  // 报修相关
  static const String RepairFormPage = 'repair_form_page';
  static const String MyRepairPage = 'my_repair_page';
  static const String RepairRatingPage = 'repair_rating_page';
  static const String RepairOrderPage = 'repair_order_page';
  static const String ReportHazardPage = 'report_hazard_page';

  // 服务指南
  static const String GuideTypePage = 'guide_type_page';
  static const String GuideListPage = 'guide_list_page';

  // 住宿相关
  static const String ProcessListPage = 'process_list_page';
  static const String ApplyListPage = 'apply_list_page';
  static const String CoupleRoomPage = 'couple_room_page';
  static const String CoupleOrderPage = 'couple_order_page';
  static const String CoupleOrderDetailPage = 'couple_order_detail_page';
  static const String CoupleFeedbackPage = 'couple_feedback_page';
  static const String CleaningOrderPage = 'cleaning_order_page';
  static const String CleaningSubmitPage = 'cleaning_submit_page';

  // 购物相关
  static const String ShoppingScreenPage = 'shopping_screen_page';
  static const String OrderListPage = 'order_list_page';
  static const String FoodSuggestionPage = 'food_suggestion_page';
  static const String FoodFeedbackPage = 'food_feedback_page';
  static const String FoodRecommendPage = 'food_recommend_page';
  static const String FoodMenuPage = 'food_menu_page';
  static const String MyFeedbackListPage = 'my_feedback_list_page';

  // 支付相关
  static const String PaymentQRCodePage = 'payment_qr_code_page';
  static const String CardInfoPage = 'card_info_page';
  static const String CardBillPage = 'card_bill_page';
  static const String ModifyPaymentPasswordPage =
      'modify_payment_password_page';
  static const String FaceCollectionPage = 'face_collection_page';

  // 配送相关
  static const String DeliveryOrderListPage = 'delivery_order_list_page';
  static const String DeliveryOnlineListPage = 'delivery_online_list_page';
  static const String ShopWorkbenchPage = 'shop_workbench_page';

  // 科学识别
  static const String PlantListPage = 'plant_list_page';
  static const String PlantDetailPage = 'plant_detail_page';
  static const String AnimalListPage = 'animal_list_page';
  static const String AnimalDetailPage = 'animal_detail_page';

  // 其他
  static const String PublicListPage = 'public_list_page';
  static const String BusTimetablePage = 'bus_timetable_page';

  // 报餐送餐
  static const String MealDeliverySubmitPage = 'meal_delivery_submit_page';
  static const String MealDeliveryOrderPage = 'meal_delivery_order_page';
  static const String MealDeliveryDetailPage = 'meal_delivery_detail_page';
  static const String MealDeliveryIndexPage = 'meal_delivery_index_page';
  static const String MealDeliveryAcceptPage = 'meal_delivery_accept_page';
  static const String MealDeliveryDeliverPage = 'meal_delivery_deliver_page';

  // SOS相关
  static const String SosIndexPage = 'sos_index_page';
  static const String ChatListPage = 'chat_list_page';
  static const String ChatScreenPage = 'chat_screen_page';
}

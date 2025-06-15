import 'package:logistics_app/pages/accommodation_page/apply_list_page.dart';
import 'package:logistics_app/pages/accommodation_page/process_list_page.dart';
import 'package:logistics_app/pages/app_home_screen.dart';
import 'package:logistics_app/pages/delivery/online/delivery_online_list_page.dart';
import 'package:logistics_app/pages/delivery/order/delivery_order_list_page.dart';
import 'package:logistics_app/pages/delivery/store/shop_workbench_page.dart';
import 'package:logistics_app/pages/guide/guide_list_page.dart';
import 'package:logistics_app/pages/guide/guide_type_page.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_detail_page.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/mine_page/contact_us_page.dart';
import 'package:logistics_app/pages/auth/forget_password_page.dart';
import 'package:logistics_app/pages/auth/login_page.dart';
import 'package:logistics_app/pages/mine_page/change_password_page.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/my_address_page.dart';
import 'package:logistics_app/pages/mine_page/person_info_page.dart';
import 'package:logistics_app/pages/news/ktime_page/ktime_list_page.dart';
import 'package:logistics_app/pages/news/monthly_page/monthly_list_page.dart';
import 'package:logistics_app/pages/news/news_page/news_list_page.dart';
import 'package:logistics_app/pages/news/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/news/promo_page/promo_list_page.dart';
import 'package:logistics_app/pages/public_convenience_page/public_list_page.dart';
import 'package:logistics_app/pages/repair/my_repair_page/my_repair_page.dart';
import 'package:logistics_app/pages/repair/my_repair_page/repair_rating_page.dart';
import 'package:logistics_app/pages/repair/repair_order_page/repair_order_page.dart';
import 'package:logistics_app/pages/repair/submit_page/repair_form_page.dart';
import 'package:logistics_app/pages/route_query_page/route_query_page.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/pages/shopping/card_bill_page.dart';
import 'package:logistics_app/pages/shopping/card_info_page.dart';
import 'package:logistics_app/pages/shopping/food_feedback/food_feedback_page.dart';
import 'package:logistics_app/pages/shopping/food_recommend_page.dart';
import 'package:logistics_app/pages/shopping/food_suggestion/food_suggestion_page.dart';
import 'package:logistics_app/pages/shopping/order/order_list_page.dart';
import 'package:logistics_app/pages/shopping/payment/face_collection_page.dart';
import 'package:logistics_app/pages/shopping/payment/modify_payment_password_page.dart';
import 'package:logistics_app/pages/shopping/payment/payment_qrcode_page.dart';
import 'package:logistics_app/pages/shopping/shopping_screen_page.dart';
import 'package:logistics_app/pages/tool_box_page.dart';
import 'package:logistics_app/pages/science/plants/plant_list_page.dart';
import 'package:logistics_app/pages/science/animals/animal_list_page.dart';
import 'package:logistics_app/pages/science/plants/plant_detail_page.dart';
import 'package:logistics_app/pages/shopping/food_menu_page.dart';
import 'package:logistics_app/pages/bus/bus_timetable_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeBuilders = <String, WidgetBuilder>{
      RoutePath.login: (context) => LoginPage(),
      RoutePath.home: (context) => AppHomeScreen(),
      RoutePath.ForgetPasswordPage: (context) => ForgetPasswordPage(),
      RoutePath.ChangePasswordPage: (context) => ChangePasswordPage(),
      RoutePath.PersonInfoPage: (context) => PersonInfoPage(),
      RoutePath.ContactUsPage: (context) => ContactUsPage(),
      RoutePath.RouteQueryPage: (context) => RouteQueryPage(),
      RoutePath.NoticeListPage: (context) => NoticeListPage(),
      RoutePath.NewsListPage: (context) => NewsListPage(),
      RoutePath.LostFoundListPage: (context) => LostFoundListPage(),
      RoutePath.LostFoundDetailPage: (context) => LostFoundDetailPage(),
      RoutePath.RepairFormPage: (context) => RepairFormPage(),
      RoutePath.RepairRatingPage: (context) => RepairRatingPage(),
      RoutePath.MyRepairPage: (context) => MyRepairPage(),
      RoutePath.RepairOrderPage: (context) => RepairOrderPage(),
      RoutePath.ToolBoxPage: (context) => ToolBoxPage(),
      RoutePath.PromoListPage: (context) => PromoListPage(),
      RoutePath.KTimeListPage: (context) => KTimeListPage(),
      RoutePath.MonthlyListPage: (context) => MonthlyListPage(),
      RoutePath.GuideTypePage: (context) => GuideTypePage(id: 0),
      RoutePath.GuideListPage: (context) => GuideListPage(guideTypeId: 0),
      RoutePath.ProcessListPage: (context) => ProcessListPage(),
      RoutePath.ApplyListPage: (context) => ApplyListPage(),
      RoutePath.ShoppingScreenPage: (context) => ShoppingScreenPage(),
      RoutePath.OrderListPage: (context) => OrderListPage(),
      RoutePath.FoodSuggestionPage: (context) => FoodSuggestionPage(),
      RoutePath.PaymentQRCodePage: (context) => PaymentQRCodePage(),
      RoutePath.CardInfoPage: (context) => CardInfoPage(),
      RoutePath.CardBillPage: (context) => CardBillPage(),
      RoutePath.ModifyPaymentPasswordPage:
          (context) => ModifyPaymentPasswordPage(),
      RoutePath.DeliveryOrderListPage: (context) => DeliveryOrderListPage(),
      RoutePath.DeliveryOnlineListPage: (context) => DeliveryOnlineListPage(),
      RoutePath.MyAddressPage: (context) => MyAddressPage(),
      RoutePath.FoodFeedbackPage: (context) => FoodFeedbackPage(),
      RoutePath.ShopWorkbenchPage: (context) => ShopWorkbenchPage(),
      RoutePath.FaceCollectionPage: (context) => FaceCollectionPage(),
      RoutePath.FoodRecommendPage: (context) => FoodRecommendPage(),
      RoutePath.PlantListPage: (context) => PlantListPage(),
      RoutePath.AnimalListPage: (context) => AnimalListPage(),
      RoutePath.PlantDetailPage: (context) => PlantDetailPage(fId: '0'),
      RoutePath.PublicListPage: (context) => PublicListPage(),
      RoutePath.FoodMenuPage: (context) => FoodMenuPage(),
      RoutePath.BusTimetablePage: (context) => BusTimetablePage(),
    };

    final builder = routeBuilders[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    } else {
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
        settings: settings,
      );
    }
  }
}

// 路由地址
class RoutePath {
  // 登录页
  static const String login = '/login';
  // 主页
  static const String home = '/home';
  // 我的页面
  static const String MinePage = '/mine_page';
  // 忘记密码
  static const String ForgetPasswordPage = '/forget_password_page';
  // 详情页
  static const String WebViewPage = '/web_view_page';
  // 修改密码
  static const String ChangePasswordPage = '/change_password_page';
  // 个人信息
  static const String PersonInfoPage = '/person_info_page';
  // 联系我们
  static const String ContactUsPage = 'contact_us_page';
  // 线路查询
  static const String RouteQueryPage = 'route_query_page';
  // 通知列表
  static const String NoticeListPage = 'notice_list_page';
  // 通知详情
  static const String NoticeDetailPage = 'notice_detail_page';
  // 公司新闻
  static const String NewsListPage = 'news_list_page';
  // 公司新闻详情
  static const String NewsDetailPage = 'news_detail_page';
  // 失物招领列表页
  static const String LostFoundListPage = 'lost_found_list_page';
  // 失物招领详情页
  static const String LostFoundDetailPage = 'lost_found_detail_page';
  // 视频模块首页
  static const String FilmScreenPage = 'film_screen_page';
  // 视频模块下载页面
  static const String FilmDownloadPage = 'film_download_page';
  // 视频播放页面
  static const String FilmViewPage = 'film_view_page';
  // 报修页面
  static const String RepairFormPage = 'repair_form_page';
  // 我的报修
  static const String MyRepairPage = 'my_repair_page';
  // 报修评价
  static const String RepairRatingPage = 'repair_rating_page';
  // 报修订单
  static const String RepairOrderPage = 'repair_order_page';
  // 地址管理
  static const String MyAddressPage = 'my_address_page';
  // 公共便利列表页
  static const String PublicListPage = 'public_list_page';

  // 工具箱
  static const String ToolBoxPage = 'tool_box_page';
  // 宣传片列表
  static const String PromoListPage = 'promo_list_page';
  // 小K时光列表
  static const String KTimeListPage = 'k_time_list_page';
  // 纬达贝月刊列表
  static const String MonthlyListPage = 'monthly_list_page';
  // 服务指南列表
  static const String GuideTypePage = 'guide_type_page';
  // 服务指南详情
  static const String GuideListPage = 'guide_list_page';
  // 住宿流程
  static const String ProcessListPage = 'process_list_page';
  // 在线申请
  static const String ApplyListPage = 'apply_list_page';
  // 在线订餐
  static const String ShoppingScreenPage = 'shopping_screen_page';
  // 我的订单
  static const String OrderListPage = 'order_list_page';
  // 我要吃
  static const String FoodSuggestionPage = 'food_suggestion_page';
  // 我想说
  static const String FoodFeedbackPage = 'food_feedback_page';
  // 支付二维码
  static const String PaymentQRCodePage = 'payment_qr_code_page';
  // 挂失
  static const String CardInfoPage = 'card_info_page';
  // 消费记录
  static const String CardBillPage = 'card_bill_page';
  // 修改支付密码
  static const String ModifyPaymentPasswordPage =
      'modify_payment_password_page';
  // 人脸采集
  static const String FaceCollectionPage = 'face_collection_page';

  // 配送订单查询
  static const String DeliveryOrderListPage = 'delivery_order_list_page';
  // 配送在线接单
  static const String DeliveryOnlineListPage = 'delivery_online_list_page';
  // 商铺工作台
  static const String ShopWorkbenchPage = 'shop_workbench_page';
  // 美食推荐
  static const String FoodRecommendPage = 'food_recommend_page';
  // 植物识别
  static const String PlantListPage = 'plant_list_page';
  // 植物详情
  static const String PlantDetailPage = 'plant_detail_page';
  // 动物识别
  static const String AnimalListPage = 'animal_list_page';
  // 动物详情
  static const String AnimalDetailPage = 'animal_detail_page';
  // 今日菜单
  static const String FoodMenuPage = 'food_menu_page';
  // 公交时刻表
  static const String BusTimetablePage = 'bus_timetable_page';
}

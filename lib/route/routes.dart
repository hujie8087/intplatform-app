import 'package:logistics_app/pages/app_home_screen.dart';
import 'package:logistics_app/pages/film_page/film_download_page.dart';
import 'package:logistics_app/pages/film_page/film_screen_page.dart';
import 'package:logistics_app/pages/film_page/film_view_page.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_detail_page.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/mine_page/contact_us_page.dart';
import 'package:logistics_app/pages/forget_password_page.dart';
import 'package:logistics_app/pages/auth/login_page.dart';
import 'package:logistics_app/pages/mine_page/change_password_page.dart';
import 'package:logistics_app/pages/mine_page/mine_page.dart';
import 'package:logistics_app/pages/mine_page/person_info_page.dart';
import 'package:logistics_app/pages/news_page/news_detail_page.dart';
import 'package:logistics_app/pages/news_page/news_list_page.dart';
import 'package:logistics_app/pages/notice_page/notice_detail_page.dart';
import 'package:logistics_app/pages/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/public_convenience_page/public_convenience_list_page.dart';
import 'package:logistics_app/pages/repair/my_repair_page.dart';
import 'package:logistics_app/pages/repair/repair_form_page.dart';
import 'package:logistics_app/pages/repair/repair_rating_page.dart';
import 'package:logistics_app/pages/route_query_page/route_query_page.dart';
import 'package:logistics_app/pages/web_view_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeBuilders = <String, WidgetBuilder>{
      RoutePath.login: (context) => LoginPage(),
      RoutePath.home: (context) => AppHomeScreen(),
      RoutePath.ForgetPasswordPage: (context) => ForgetPasswordPage(),
      RoutePath.WebViewPage: (context) => WebViewPage(),
      RoutePath.ChangePasswordPage: (context) => ChangePasswordPage(),
      RoutePath.PersonInfoPage: (context) => PersonInfoPage(),
      RoutePath.ContactUsPage: (context) => ContactUsPage(),
      RoutePath.RouteQueryPage: (context) => RouteQueryPage(),
      RoutePath.NoticeListPage: (context) => NoticeListPage(),
      RoutePath.NewsListPage: (context) => NewsListPage(),
      RoutePath.NewsDetailPage: (context) => NewsDetailPage(),
      RoutePath.LostFoundListPage: (context) => LostFoundListPage(),
      RoutePath.LostFoundDetailPage: (context) => LostFoundDetailPage(),
      RoutePath.FilmScreenPage: (context) => FilmScreenPage(),
      RoutePath.FilmDownloadPage: (context) => FilmDownloadPage(),
      RoutePath.FilmViewPage: (context) => FilmViewPage(),
      RoutePath.RepairFormPage: (context) => RepairFormPage(),
      RoutePath.RepairRatingPage: (context) => RepairRatingPage(),
      RoutePath.MyRepairPage: (context) => MyRepairPage(),
      RoutePath.PublicConvenienceListPage: (context) =>
          PublicConvenienceListPage(),
    };

    final builder = routeBuilders[settings.name];

    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
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
  // 公共便利列表页
  static const String PublicConvenienceListPage =
      'public_convenience_list_page';
}

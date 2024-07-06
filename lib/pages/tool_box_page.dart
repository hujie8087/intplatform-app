import 'package:flutter/material.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/news_page/news_list_page.dart';
import 'package:logistics_app/pages/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/repair/repair_form_page.dart';
import 'package:logistics_app/pages/route_query_page/route_query_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';

class ToolBoxPage extends StatefulWidget {
  @override
  _ToolBoxPageState createState() => _ToolBoxPageState();
}

class _ToolBoxPageState extends State<ToolBoxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '工具箱',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.left,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset(
            'assets/images/tool_box_bg.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.directions,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                Text(
                                  '交通服务',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GridView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1.0),
                              children: [
                                _FunctionAreaItem(
                                    '路线查询', true, Icons.directions, () {
                                  RouteUtils.push(context, RouteQueryPage());
                                }),
                                // 车辆信息
                                _FunctionAreaItem(
                                    '车辆信息', false, Icons.directions_car, null),
                                // 评价与建议
                                _FunctionAreaItem(
                                    '评价与建议', true, Icons.feedback, null),
                                // 车牌申请
                                _FunctionAreaItem(
                                    '车牌申请', false, Icons.card_membership, null),
                                // 车牌挂失及注销
                                _FunctionAreaItem(
                                    '挂失及注销', true, Icons.card_giftcard, null),
                              ],
                            ),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.newspaper,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '资讯类',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GridView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1.0),
                              children: [
                                // 通知公告
                                _FunctionAreaItem(
                                    '通知公告',
                                    true,
                                    Icons.notifications,
                                    () => RouteUtils.push(
                                        context, NoticeListPage())),
                                // 公司新闻
                                _FunctionAreaItem(
                                    '公司动态',
                                    false,
                                    Icons.newspaper_rounded,
                                    () => RouteUtils.push(
                                        context, NewsListPage())),
                              ],
                            ),
                          ],
                        )),
                    // 住宿服务
                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.hotel,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '住宿服务',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GridView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1.0),
                              children: [
                                // 住宿流程
                                _FunctionAreaItem(
                                    '住宿流程', false, Icons.hotel, null),
                                // 在线申请
                                _FunctionAreaItem(
                                    '在线申请', true, Icons.edit_document, null),
                              ],
                            ),
                          ],
                        )),
                    // 报修服务
                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.build,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '报修服务',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GridView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1.0),
                              children: [
                                // 报修
                                _FunctionAreaItem(
                                    '在线报修',
                                    true,
                                    Icons.build,
                                    () => RouteUtils.push(
                                        context, RepairFormPage())),
                                // 报修记录
                                _FunctionAreaItem(
                                    '我的报修', false, Icons.history, null),
                              ],
                            ),
                          ],
                        )),
                    // 餐饮服务
                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.fastfood,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '餐饮服务',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GridView(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1.0),
                              children: [
                                // 在线预订
                                _FunctionAreaItem(
                                    '在线预订', false, Icons.book_online, null),
                                // 餐饮介绍
                                _FunctionAreaItem(
                                    '餐饮介绍', true, Icons.fastfood, null),
                                // 我想吃
                                _FunctionAreaItem(
                                    '我想吃', false, Icons.restaurant, null),
                                // 我想说
                                _FunctionAreaItem(
                                    '我想说', true, Icons.feedback, null),
                              ],
                            ),
                          ],
                        )),
                    // 公共服务
                    Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.public,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '公共服务',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GridView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1.0),
                              children: [
                                // 服务指南
                                _FunctionAreaItem(
                                    '服务指南', true, Icons.info, null),
                                // 公共便利
                                _FunctionAreaItem(
                                    '公共便利', false, Icons.public, null),
                                // 失物招领
                                _FunctionAreaItem(
                                    '失物招领',
                                    true,
                                    Icons.inventory_2_outlined,
                                    () => RouteUtils.push(
                                        context, LostFoundListPage())),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _FunctionAreaItem(
      String title, bool isEven, IconData icon, GestureTapCallback? onTap) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isEven
                    ? primaryColor.withOpacity(0.1)
                    : secondaryColor.withOpacity(0.1)),
            child: Icon(
              icon,
              color: isEven ? primaryColor : secondaryColor,
              size: 20,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title, style: TextStyle(fontSize: 12))
        ],
      ),
      onTap: onTap,
    );
  }
}

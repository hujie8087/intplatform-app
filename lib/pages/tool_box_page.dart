import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/option_grid_view.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/news_page/news_list_page.dart';
import 'package:logistics_app/pages/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/public_convenience_page/public_convenience_list_page.dart';
import 'package:logistics_app/pages/repair/my_repair_page.dart';
import 'package:logistics_app/pages/repair/repair_form_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';

// String title, bool isEven, IconData icon,
// bool showBadge, GestureTapCallback? onTap
class MenuItemModel {
  final String? title; // 标题
  final bool? isEven; // 对应的widget
  final IconData? icon;
  final bool? showBadge;
  final GestureTapCallback? onTap;
  const MenuItemModel(
      {this.title, this.isEven, this.icon, this.showBadge, this.onTap});
}

class ToolBoxPage extends StatefulWidget {
  @override
  _ToolBoxPageState createState() => _ToolBoxPageState();
}

class _ToolBoxPageState extends State<ToolBoxPage> {
  @override
  Widget build(BuildContext context) {
    final List<MenuItemModel> transportMenu = [
      MenuItemModel(
          title: '路线查询',
          icon: Icons.directions,
          isEven: true,
          showBadge: false,
          onTap: null),
      MenuItemModel(
          title: '车辆信息',
          icon: Icons.directions_car,
          isEven: false,
          showBadge: false,
          onTap: null),
      MenuItemModel(
          title: '评价与建议',
          icon: Icons.feedback,
          isEven: true,
          showBadge: false,
          onTap: null),
      MenuItemModel(
          title: '车牌申请',
          icon: Icons.card_membership,
          isEven: false,
          showBadge: false,
          onTap: null),
      MenuItemModel(
          title: '挂失及注销',
          icon: Icons.card_giftcard,
          isEven: true,
          showBadge: false,
          onTap: null),
    ];
    final List<MenuItemModel> newsMenu = [
      MenuItemModel(
          title: '通知公告',
          icon: Icons.notifications,
          isEven: false,
          showBadge: false,
          onTap: () => RouteUtils.push(context, NoticeListPage())),
      MenuItemModel(
          title: '公司动态',
          icon: Icons.newspaper_rounded,
          isEven: true,
          showBadge: false,
          onTap: () => RouteUtils.push(context, NewsListPage())),
    ];
    final List<MenuItemModel> repairMenu = [
      MenuItemModel(
          title: '在线报修',
          icon: Icons.build,
          isEven: true,
          showBadge: false,
          onTap: () => RouteUtils.push(context, RepairFormPage())),
      MenuItemModel(
          title: '我的报修',
          icon: Icons.history,
          isEven: false,
          showBadge: false,
          onTap: () => RouteUtils.push(context, MyRepairPage())),
    ];
    final List<MenuItemModel> commonMenu = [
      MenuItemModel(
          title: '服务指南',
          icon: Icons.info,
          isEven: true,
          showBadge: false,
          onTap: null),
      MenuItemModel(
          title: '公共便利',
          icon: Icons.public,
          isEven: false,
          showBadge: false,
          onTap: () => RouteUtils.push(context, PublicConvenienceListPage())),
      MenuItemModel(
          title: '失物招领',
          icon: Icons.inventory_2_outlined,
          isEven: true,
          showBadge: false,
          onTap: () => RouteUtils.push(context, LostFoundListPage())),
    ];

    final List<MenuItemModel> foodMenu = [
      MenuItemModel(
          title: '在线预订',
          icon: Icons.book_online,
          isEven: true,
          showBadge: false,
          onTap: null),
      MenuItemModel(
          title: '餐饮介绍',
          icon: Icons.fastfood,
          isEven: false,
          showBadge: false,
          onTap: null),
      MenuItemModel(
          title: '我想吃',
          icon: Icons.restaurant,
          isEven: true,
          showBadge: false,
          onTap: null),
      MenuItemModel(
          title: '我想说',
          icon: Icons.feedback,
          isEven: false,
          showBadge: false,
          onTap: null),
    ];

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
                    // Container(
                    //     padding: EdgeInsets.all(10),
                    //     margin: EdgeInsets.only(bottom: 10),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Icon(
                    //               Icons.directions,
                    //               color: primaryColor,
                    //               size: 20,
                    //             ),
                    //             Text(
                    //               '交通服务',
                    //               style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 10,
                    //         ),
                    //         OptionGridView(
                    //           itemCount: transportMenu.length,
                    //           rowCount: 5,
                    //           mainAxisSpacing: 10,
                    //           crossAxisSpacing: 10,
                    //           itemBuilder: (context, index) {
                    //             return _FunctionAreaItem(transportMenu[index]);
                    //           },
                    //         ),
                    //       ],
                    //     )),
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
                            OptionGridView(
                              itemCount: newsMenu.length,
                              rowCount: 5,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              itemBuilder: (context, index) {
                                return _FunctionAreaItem(newsMenu[index]);
                              },
                            ),
                          ],
                        )),
                    // 住宿服务
                    // Container(
                    //     padding: EdgeInsets.all(10),
                    //     margin: EdgeInsets.only(bottom: 10),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Icon(
                    //               Icons.hotel,
                    //               color: primaryColor,
                    //               size: 20,
                    //             ),
                    //             SizedBox(
                    //               width: 5,
                    //             ),
                    //             Text(
                    //               '住宿服务',
                    //               style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 10,
                    //         ),
                    //         GridView(
                    //           shrinkWrap: true,
                    //           physics: NeverScrollableScrollPhysics(),
                    //           gridDelegate:
                    //               SliverGridDelegateWithFixedCrossAxisCount(
                    //                   crossAxisCount: 5,
                    //                   crossAxisSpacing: 10,
                    //                   mainAxisSpacing: 10,
                    //                   childAspectRatio: 1.0),
                    //           children: [
                    //             // 住宿流程
                    //             _FunctionAreaItem(
                    //                 '住宿流程', false, Icons.hotel, false, null),
                    //             // 在线申请
                    //             _FunctionAreaItem('在线申请', true,
                    //                 Icons.edit_document, false, null),
                    //           ],
                    //         ),
                    //       ],
                    //     )),
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
                            OptionGridView(
                              itemCount: repairMenu.length,
                              rowCount: 5,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              itemBuilder: (context, index) {
                                return _FunctionAreaItem(repairMenu[index]);
                              },
                            ),
                          ],
                        )),
                    // 餐饮服务
                    // Container(
                    //     padding: EdgeInsets.all(10),
                    //     margin: EdgeInsets.only(bottom: 10),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Icon(
                    //               Icons.fastfood,
                    //               color: primaryColor,
                    //               size: 20,
                    //             ),
                    //             SizedBox(
                    //               width: 5,
                    //             ),
                    //             Text(
                    //               '餐饮服务',
                    //               style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 10,
                    //         ),
                    //         OptionGridView(
                    //           itemCount: foodMenu.length,
                    //           rowCount: 5,
                    //           mainAxisSpacing: 10,
                    //           crossAxisSpacing: 10,
                    //           itemBuilder: (context, index) {
                    //             return _FunctionAreaItem(foodMenu[index]);
                    //           },
                    //         ),
                    //       ],
                    //     )),
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
                            OptionGridView(
                              itemCount: commonMenu.length,
                              rowCount: 5,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              itemBuilder: (context, index) {
                                return _FunctionAreaItem(commonMenu[index]);
                              },
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

  Widget _FunctionAreaItem(meneItem) {
    return GestureDetector(
      child: Column(
        children: [
          badges.Badge(
            showBadge: meneItem.showBadge,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: meneItem.isEven
                      ? primaryColor.withOpacity(0.1)
                      : secondaryColor.withOpacity(0.1)),
              child: Icon(
                meneItem.icon,
                color: meneItem.isEven ? primaryColor : secondaryColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            meneItem.title,
            maxLines: 2,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ],
      ),
      onTap: meneItem.onTap,
    );
  }
}

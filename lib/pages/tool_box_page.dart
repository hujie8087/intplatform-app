import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/icon_api_widget.dart';
import 'package:logistics_app/common_ui/option_grid_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/tool_utils.dart';
import 'package:logistics_app/http/model/base_model.dart';
import 'package:logistics_app/http/model/guide_type_view_model.dart';
import 'package:logistics_app/http/model/guide_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/pages/guide/guide_list_page.dart';
import 'package:logistics_app/pages/guide/guide_type_page.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/my_address_page.dart';
import 'package:logistics_app/pages/news_page/news_list_page.dart';
import 'package:logistics_app/pages/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/repair/my_repair_page.dart';
import 'package:logistics_app/pages/repair/repair_form_page.dart';
import 'package:logistics_app/pages/shopping/card_bill_page.dart';
import 'package:logistics_app/pages/shopping/card_info_page.dart';
import 'package:logistics_app/pages/shopping/food_suggestion/food_suggestion_page.dart';
import 'package:logistics_app/pages/shopping/order/order_list_page.dart';
import 'package:logistics_app/pages/shopping/payment/modify_payment_password_page.dart';
import 'package:logistics_app/pages/shopping/payment/payment_qrcode_page.dart';
import 'package:logistics_app/pages/shopping/shopping_screen_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';

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
  List<GuideTypeViewModel> guideTypeList = [];
  List<GuideViewModel> guideList = [];
  List<MenuItemModel> commonMenu = [];

  Future<void> _fetchGuideListData(GuideTypeViewModel guideType) async {
    ToolUtils.getGuideList<GuideViewModel>(
      {'pageNum': 1, 'pageSize': 1000, 'typeId': guideType.id},
      success: (res) {
        RowsModel<GuideViewModel> rowsModel =
            RowsModel.fromJson(res, (json) => GuideViewModel.fromJson(json));
        guideList = rowsModel.rows ?? [];
        if (guideList.isNotEmpty) {
          RouteUtils.push(context,
              GuideListPage(guideType: guideType, guideList: guideList));
        } else {
          RouteUtils.push(context, GuideTypePage(id: guideType.id!));
        }
        setState(() {});
      },
    );
  }

  Future<void> _fetchData() async {
    ToolUtils.getGuideTypeList<GuideTypeViewModel>(
      {'pageNum': 1, 'pageSize': 1000},
      success: (res) {
        RowsModel<GuideTypeViewModel> rowsModel = RowsModel.fromJson(
            res, (json) => GuideTypeViewModel.fromJson(json));
        guideTypeList = rowsModel.rows ?? [];
        setState(() {
          if (guideTypeList.isNotEmpty) {
            commonMenu = guideTypeList.map((item) {
              return MenuItemModel(
                  title: item.title,
                  icon: iconMap[item.img],
                  isEven: item.id! % 2 == 0,
                  showBadge: false,
                  onTap: () async {
                    await _fetchGuideListData(item);
                    // RouteUtils.push(context, GuideTypePage(id: item.id!));
                  });
            }).toList();
          }
        });
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
  }

  // 更新区域数据
  void refreshAddressData() async {
    await SpUtils.remove('buildingVersion');
    await SpUtils.remove('building');
    getAddressData();
  }

// 获取区域楼栋数据
  void getAddressData() async {
    int? buildingVersion = await SpUtils.getInt('buildingVersion');
    int newBuildingVersion = 0;
    Object? buildingData = await SpUtils.getModel('building');
    DataUtils.getBuildingVersion(
      success: (data) {
        newBuildingVersion = data['data']['version'];
        if (newBuildingVersion != buildingVersion || buildingData == null) {
          SpUtils.saveInt('buildingVersion', newBuildingVersion);
          DataUtils.getBuildingTree(
            success: (data) {
              BaseModel rowsModel = BaseModel.fromJson(data);
              if (rowsModel.data != null) {
                SpUtils.saveModel('building', rowsModel.data);
              }
            },
          );
        }
      },
      fail: (code, msg) {},
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // final List<MenuItemModel> transportMenu = [
    //   MenuItemModel(
    //       title: '路线查询',
    //       icon: Icons.directions,
    //       isEven: true,
    //       showBadge: false,
    //       onTap: null),
    //   MenuItemModel(
    //       title: '车辆信息',
    //       icon: Icons.directions_car,
    //       isEven: false,
    //       showBadge: false,
    //       onTap: null),
    //   MenuItemModel(
    //       title: '评价与建议',
    //       icon: Icons.feedback,
    //       isEven: true,
    //       showBadge: false,
    //       onTap: null),
    //   MenuItemModel(
    //       title: '车牌申请',
    //       icon: Icons.card_membership,
    //       isEven: false,
    //       showBadge: false,
    //       onTap: null),
    //   MenuItemModel(
    //       title: '挂失及注销',
    //       icon: Icons.card_giftcard,
    //       isEven: true,
    //       showBadge: false,
    //       onTap: null),
    // ];
    final List<MenuItemModel> newsMenu = [
      MenuItemModel(
          title: S.of(context).notifications,
          icon: Icons.notifications,
          isEven: false,
          showBadge: false,
          onTap: () => RouteUtils.push(context, NoticeListPage())),
      MenuItemModel(
          title: S.of(context).news,
          icon: Icons.newspaper_rounded,
          isEven: true,
          showBadge: false,
          onTap: () => RouteUtils.push(context, NewsListPage())),
    ];
    final List<MenuItemModel> repairMenu = [
      MenuItemModel(
          title: S.of(context).repairOnline,
          icon: Icons.build,
          isEven: true,
          showBadge: false,
          onTap: () => RouteUtils.push(context, RepairFormPage())),
      MenuItemModel(
          title: S.of(context).myRepair,
          icon: Icons.history,
          isEven: false,
          showBadge: false,
          onTap: () => RouteUtils.push(context, MyRepairPage())),
      MenuItemModel(
          title: S.of(context).addressManagement,
          icon: Icons.location_on,
          isEven: true,
          showBadge: false,
          onTap: () => RouteUtils.push(context, MyAddressPage())),
      // 更新区域数据
      MenuItemModel(
          title: S.of(context).updateAddressData,
          icon: Icons.update,
          isEven: false,
          showBadge: false,
          onTap: () => {refreshAddressData()}),
    ];

    final List<MenuItemModel> foodMenu = [
      MenuItemModel(
          title: S.of(context).onlineDining,
          icon: Icons.book_online,
          isEven: true,
          showBadge: false,
          onTap: () => {RouteUtils.push(context, ShoppingScreenPage())}),
      MenuItemModel(
          title: S.of(context).myOrder,
          icon: Icons.bookmark_outline,
          isEven: false,
          showBadge: false,
          onTap: () => {RouteUtils.push(context, OrderListPage())}),
      MenuItemModel(
          title: S.of(context).iWantToEat,
          icon: Icons.restaurant,
          isEven: true,
          showBadge: false,
          onTap: () => {RouteUtils.push(context, FoodSuggestionPage())}),
      MenuItemModel(
          title: S.of(context).paymentQRCode,
          icon: Icons.qr_code_scanner,
          isEven: false,
          showBadge: false,
          onTap: () => {RouteUtils.push(context, PaymentQRCodePage())}),
      // 消费卡挂失解锁
      MenuItemModel(
          title: S.of(context).cardLoss,
          icon: Icons.credit_card,
          isEven: true,
          showBadge: false,
          onTap: () => {RouteUtils.push(context, CardInfoPage())}),
      // 消费卡账单
      MenuItemModel(
          title: S.of(context).cardBill,
          icon: Icons.receipt,
          isEven: false,
          showBadge: false,
          onTap: () => {RouteUtils.push(context, CardBillPage())}),
      // 修改支付密码
      MenuItemModel(
          title: S.of(context).updatePaymentPassword,
          icon: Icons.lock,
          isEven: true,
          showBadge: false,
          onTap: () => {RouteUtils.push(context, ModifyPaymentPasswordPage())}),
    ];

    // final List<MenuItemModel> lostFoundMenu = [
    //   MenuItemModel(
    //       title: '失物招领',
    //       icon: Icons.find_in_page,
    //       isEven: true,
    //       showBadge: false,
    //       onTap: () => {RouteUtils.push(context, LostFoundListPage())}),
    // ];
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          S.of(context).toolPage,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.px),
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
              padding: EdgeInsets.all(8.px),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(8.px),
                        margin: EdgeInsets.only(bottom: 8.px),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.px)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.newspaper,
                                  color: primaryColor,
                                  size: 18.px,
                                ),
                                SizedBox(
                                  width: 4.px,
                                ),
                                Text(
                                  S.of(context).information,
                                  style: TextStyle(
                                      fontSize: 12.px,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.px,
                            ),
                            OptionGridView(
                              itemCount: newsMenu.length,
                              rowCount: 5,
                              mainAxisSpacing: 8.px,
                              crossAxisSpacing: 8.px,
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
                        padding: EdgeInsets.all(8.px),
                        margin: EdgeInsets.only(bottom: 8.px),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.px)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.build,
                                  color: primaryColor,
                                  size: 18.px,
                                ),
                                SizedBox(
                                  width: 4.px,
                                ),
                                Text(
                                  S.of(context).repairService,
                                  style: TextStyle(
                                      fontSize: 12.px,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.px,
                            ),
                            OptionGridView(
                              itemCount: repairMenu.length,
                              rowCount: 5,
                              mainAxisSpacing: 8.px,
                              crossAxisSpacing: 8.px,
                              itemBuilder: (context, index) {
                                return _FunctionAreaItem(repairMenu[index]);
                              },
                            ),
                          ],
                        )),
                    // 餐饮服务
                    Container(
                        padding: EdgeInsets.all(8.px),
                        margin: EdgeInsets.only(bottom: 8.px),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.px)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.fastfood,
                                  color: primaryColor,
                                  size: 18.px,
                                ),
                                SizedBox(
                                  width: 4.px,
                                ),
                                Text(
                                  S.of(context).diningService,
                                  style: TextStyle(
                                      fontSize: 12.px,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.px,
                            ),
                            OptionGridView(
                              itemCount: foodMenu.length,
                              rowCount: 5,
                              mainAxisSpacing: 8.px,
                              crossAxisSpacing: 8.px,
                              itemBuilder: (context, index) {
                                return _FunctionAreaItem(foodMenu[index]);
                              },
                            ),
                          ],
                        )),
                    // 失物招领
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
                    //               Icons.find_in_page,
                    //               color: primaryColor,
                    //               size: 20,
                    //             ),
                    //             SizedBox(
                    //               width: 5,
                    //             ),
                    //             Text(
                    //               '公共服务',
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
                    //           itemCount: lostFoundMenu.length,
                    //           rowCount: 5,
                    //           mainAxisSpacing: 10,
                    //           crossAxisSpacing: 10,
                    //           itemBuilder: (context, index) {
                    //             return _FunctionAreaItem(lostFoundMenu[index]);
                    //           },
                    //         ),
                    //       ],
                    //     )),
                    // 服务指南
                    if (commonMenu.isNotEmpty)
                      Container(
                          padding: EdgeInsets.all(8.px),
                          margin: EdgeInsets.only(bottom: 8.px),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.px)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.public,
                                    color: primaryColor,
                                    size: 18.px,
                                  ),
                                  SizedBox(
                                    width: 4.px,
                                  ),
                                  Text(
                                    S.of(context).serviceGuide,
                                    style: TextStyle(
                                        fontSize: 12.px,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.px,
                              ),
                              OptionGridView(
                                itemCount: commonMenu.length,
                                rowCount: 5,
                                mainAxisSpacing: 8.px,
                                crossAxisSpacing: 8.px,
                                itemBuilder: (context, index) {
                                  return _FunctionAreaItem(commonMenu[index]);
                                },
                              ),
                            ],
                          )),
                    SizedBox(
                      height: 50.px,
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
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            badges.Badge(
              showBadge: meneItem.showBadge,
              child: Container(
                width: 36.px,
                height: 36.px,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: meneItem.isEven
                        ? primaryColor.withOpacity(0.1)
                        : secondaryColor.withOpacity(0.1)),
                child: Icon(
                  meneItem.icon,
                  color: meneItem.isEven ? primaryColor : secondaryColor,
                  size: 18.px,
                ),
              ),
            ),
            SizedBox(
              height: 4.px,
            ),
            Text(
              meneItem.title,
              maxLines: 2,
              style: TextStyle(fontSize: 10.px),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ],
        ),
      ),
      onTap: meneItem.onTap,
    );
  }
}

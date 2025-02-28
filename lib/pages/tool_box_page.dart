import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/icon_api_widget.dart';
import 'package:logistics_app/common_ui/option_grid_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/repair_utils.dart';
import 'package:logistics_app/http/data/tool_utils.dart';
import 'package:logistics_app/http/model/app_menu_model.dart';
import 'package:logistics_app/http/model/apply_view_model.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/base_model.dart';
import 'package:logistics_app/http/model/guide_type_view_model.dart';
import 'package:logistics_app/http/model/guide_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/main.dart';
import 'package:logistics_app/pages/accommodation_page/apply_detail_page.dart';
import 'package:logistics_app/pages/guide/guide_list_page.dart';
import 'package:logistics_app/pages/guide/guide_type_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';

// String title, bool isEven, IconData icon,
// bool showBadge, GestureTapCallback? onTap
class MenuItemModel {
  final String? cname; // 标题
  final String? yname; // 标题
  final String? uname; // 标题
  final IconData? icon;
  final bool showBadge;
  final GestureTapCallback? onTap;
  final int? badgeContent;

  const MenuItemModel(
      {this.cname,
      this.yname,
      this.uname,
      this.icon,
      this.showBadge = false,
      this.onTap,
      this.badgeContent});
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      cname: json['cname'],
      yname: json['yname'],
      uname: json['uname'],
      icon: json['icon'],
      showBadge: json['showBadge'],
      badgeContent: json['badgeContent'],
      onTap: json['onTap'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'cname': cname,
      'yname': yname,
      'uname': uname,
      'icon': icon,
      'showBadge': showBadge,
      'badgeContent': badgeContent,
      'onTap': onTap,
    };
  }
}

class AppMenuListModel {
  final String? cname;
  final String? yname;
  final String? uname;
  final List<MenuItemModel>? menuItemList;
  final IconData? icon;
  const AppMenuListModel(
      {this.cname, this.yname, this.uname, this.menuItemList, this.icon});
  factory AppMenuListModel.fromJson(Map<String, dynamic> json) {
    return AppMenuListModel(
      cname: json['cname'],
      yname: json['yname'],
      uname: json['uname'],
      menuItemList: json['menuItemList']
          ?.map((item) => MenuItemModel.fromJson(item))
          .toList(),
      icon: json['icon'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'cname': cname,
      'yname': yname,
      'uname': uname,
      'menuItemList': menuItemList,
      'icon': icon,
    };
  }
}

class ToolBoxPage extends StatefulWidget {
  @override
  _ToolBoxPageState createState() => _ToolBoxPageState();
}

class _ToolBoxPageState extends State<ToolBoxPage> with RouteAware {
  List<GuideTypeViewModel> guideTypeList = [];
  List<GuideViewModel> guideList = [];
  List<String>? permission;
  int repairUnfinishedCount = 0;
  int repairUnreadCount = 0;
  List<AppMenuListModel> appMenuList = [];
  List<AppMenuModel> appMenuListFilter = [];
  UserInfoModel? userInfoData;
  String token = '';
  List<Map<String, dynamic>> publicIconMap = [
    {
      'id': 1,
      'title': '缝纫店',
      'icon': Icons.local_laundry_service,
    },
    {
      'id': 2,
      'title': '超市',
      'icon': Icons.shopping_bag,
    },
    {
      'id': 3,
      'title': '配钥匙',
      'icon': Icons.key,
    },
    {
      'id': 4,
      'title': '理发店',
      'icon': Icons.content_cut,
    },
    {
      'id': 5,
      'title': '消费卡',
      'icon': Icons.credit_card,
    },
    {
      'id': 6,
      'title': '健身房',
      'icon': Icons.fitness_center,
    },
    {
      'id': 7,
      'title': '体育馆',
      'icon': Icons.sports_soccer,
    },
  ];
  // 获取当前语言版本

  String languageCode = 'zh';

  // 获取维修订单未完成数量
  Future<void> getRepairUnfinishedCount() async {
    RepairUtils.getRepairUnfinishedCount(
      success: (data) {
        setState(() {
          repairUnfinishedCount = data['data']['waitRepairCount'] +
              data['data']['againRepairCount'];
          SpUtils.saveInt(
              Constants.SP_REPAIR_UNFINISHED_COUNT, repairUnfinishedCount);
        });
        if (appMenuList.isEmpty) {
          getAppMenu();
        } else {
          filterAppMenu();
        }
      },
    );
  }

  // 获取我的报修未读数量
  Future<void> getMyRepairUnreadCount() async {
    RepairUtils.getMyRepairList(
      {'pageNum': 1, 'pageSize': 1000, 'status': 1, 'readStatus': 1},
      success: (data) {
        setState(() {
          if (repairUnreadCount != data['total']) {
            repairUnreadCount = data['total'];
            filterAppMenu();
          }
        });
      },
    );
  }

  // 获取服务指南
  Future<void> getGuideList() async {
    ToolUtils.getGuideTypeList<GuideTypeViewModel>(
      {'pageNum': 1, 'pageSize': 1000},
      success: (res) {
        RowsModel<GuideTypeViewModel> rowsModel = RowsModel.fromJson(
            res, (json) => GuideTypeViewModel.fromJson(json));
        setState(() {
          guideTypeList = rowsModel.rows ?? [];
        });
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
  }

  // 设置badgeContent数量
  int setBadgeContent(String permission) {
    int badgeContent = 0;
    switch (permission) {
      case 'commonality:repair:unfinishedCountApp':
        badgeContent = repairUnfinishedCount;
        break;
      case 'commonality:repair:listApp':
        badgeContent = repairUnreadCount;
        break;
      default:
        badgeContent = 0;
        break;
    }

    return badgeContent;
  }

  // 获取App菜单
  Future<void> getAppMenu() async {
    ToolUtils.getAppMenu<AppMenuModel>(
      success: (data) {
        BaseListModel<AppMenuModel> response =
            BaseListModel.fromJson(data, (json) => AppMenuModel.fromJson(json));
        appMenuListFilter = response.data ?? [];
        setState(() {
          filterAppMenu();
        });
      },
    );
  }

  // 设置过滤App菜单
  Future<void> filterAppMenu() async {
    token = await SpUtils.getString(Constants.SP_TOKEN) ?? '';
    // 未登录，过滤需要登录的菜单
    if (token == '' || token.isEmpty) {
      appMenuListFilter = appMenuListFilter
          .map(
            (menu) {
              return AppMenuModel(
                remark: menu.remark,
                id: menu.id,
                cname: menu.cname,
                yname: menu.yname,
                uname: menu.uname,
                sort: menu.sort,
                status: menu.status,
                icon: menu.icon,
                permissions: menu.permissions,
                isLogin: menu.isLogin,
                iconArticles: menu.iconArticles?.where((article) {
                  if (article.status == 1 || article.isLogin == 1) {
                    return false;
                  }
                  return true;
                }) // 过滤 `iconArticles`
                    .toList(),
              );
            },
          )
          .where((menu) => menu.isLogin == 0)
          .toList();
    } else {
      // 已登录，过滤需要权限的菜单
      appMenuListFilter = appMenuListFilter.map(
        (menu) {
          return AppMenuModel(
            remark: menu.remark,
            id: menu.id,
            cname: menu.cname,
            yname: menu.yname,
            uname: menu.uname,
            sort: menu.sort,
            status: menu.status,
            icon: menu.icon,
            permissions: menu.permissions,
            isLogin: menu.isLogin,
            iconArticles: menu.iconArticles?.where((article) {
              if (article.status == 1) {
                return false;
              } else if (article.permissions != null) {
                return permission!.contains(article.permissions);
              }
              return true;
            }) // 过滤 `iconArticles`
                .toList(),
          );
        },
      ).toList();
    }
    appMenuList = appMenuListFilter
        .map((e) => AppMenuListModel(
              cname: e.cname,
              yname: e.yname,
              uname: e.uname,
              icon: iconMap[e.icon] as IconData,
              menuItemList: e.iconArticles
                  ?.map((article) => MenuItemModel(
                        cname: article.cname,
                        yname: article.yname,
                        uname: article.uname,
                        icon: iconMap[article.icon] as IconData,
                        showBadge: article.isMic == 1,
                        badgeContent:
                            setBadgeContent(article.permissions ?? ''),
                        onTap: () {
                          switch (article.router) {
                            case 'apply_url':
                              _getApplyUrl();
                              break;
                            case 'refresh_address_data':
                              refreshAddressData();
                              break;
                            case 'guide_type_page':
                              RouteUtils.push(
                                  context,
                                  GuideTypePage(
                                      id: int.parse(article.remark!)));
                              break;
                            case 'guide_list_page':
                              RouteUtils.push(
                                  context,
                                  GuideListPage(
                                      guideTypeId: int.parse(article.remark!)));
                              break;
                            default:
                              RouteUtils.pushNamed(context, article.router!);
                          }
                        },
                      ))
                  .toList(),
            ))
        .where((menu) => menu.menuItemList!.length > 0)
        .toList();
  }

  Future<void> _fetchData() async {
    languageCode = await SpUtils.getString('locale') ?? 'zh';
    final userInfoDataModel = await SpUtils.getModel('userInfo');
    token = await SpUtils.getString(Constants.SP_TOKEN) ?? '';
    userInfoData = userInfoDataModel != null
        ? UserInfoModel.fromJson(userInfoDataModel)
        : null;
    print('token: $token');
    if (userInfoData != null && token != '') {
      permission = userInfoData?.permissions;
      if (permission != null &&
          permission!.contains('commonality:repair:unfinishedCountApp')) {
        getRepairUnfinishedCount();
      }
      if (appMenuList.isEmpty) {
        await getAppMenu();
      }
      getMyRepairUnreadCount();
    } else {
      if (appMenuList.isEmpty) {
        await getAppMenu();
      }
    }
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

  void _getApplyUrl() async {
    ProgressHUD.showLoadingText('数据加载中...');
    DataUtils.getApplyList(
      {
        'status': '2',
        'type': '1',
        'pageNum': 1,
        'pageSize': 100,
      },
      success: (data) {
        RowsModel<ApplyViewModel> response =
            RowsModel.fromJson(data, (json) => ApplyViewModel.fromJson(json));
        List<ApplyViewModel> applyList = response.rows ?? [];
        if (applyList.isNotEmpty) {
          DataUtils.getApplyUrl(
            {
              'id': applyList[0].formId,
            },
            success: (data) {
              ProgressHUD.hide();
              String applyUrl = data['data']['url'];
              if (applyUrl.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApplyDetailPage(
                              url: applyUrl,
                              title: '我的流程',
                            )));
              }
              setState(() {});
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGuideList();
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // 当从其他页面返回时触发
    print("页面重新进入，触发请求...");
    if (permission != null &&
        permission!.contains('commonality:repair:unfinishedCountApp')) {
      getRepairUnfinishedCount();
    }
    if (token != '' && token.isNotEmpty) {
      getMyRepairUnreadCount();
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        bottom: true,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: 8.px, bottom: 20.px, left: 8.px, right: 8.px),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    appMenuList.length,
                    (index) => Container(
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
                                  appMenuList[index].icon as IconData,
                                  color: primaryColor,
                                  size: 18.px,
                                ),
                                SizedBox(
                                  width: 4.px,
                                ),
                                Text(
                                  languageCode == 'zh'
                                      ? appMenuList[index].cname ?? ''
                                      : languageCode == 'en'
                                          ? appMenuList[index].uname ?? ''
                                          : appMenuList[index].yname ?? '',
                                  style: TextStyle(
                                      fontSize: 14.px,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.px,
                            ),
                            OptionGridView(
                              itemCount:
                                  appMenuList[index].menuItemList?.length ?? 0,
                              rowCount: 5,
                              mainAxisSpacing: 8.px,
                              crossAxisSpacing: 8.px,
                              itemBuilder: (context, idx) {
                                return _FunctionAreaItem(
                                    appMenuList[index].menuItemList![idx], idx);
                              },
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _FunctionAreaItem(MenuItemModel meneItem, int index) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            badges.Badge(
              badgeContent: meneItem.badgeContent != null
                  ? Text(
                      meneItem.badgeContent.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 10.px),
                    )
                  : null,
              showBadge: meneItem.showBadge && meneItem.badgeContent != 0,
              child: Container(
                width: 36.px,
                height: 36.px,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index % 2 == 0
                        ? primaryColor.withOpacity(0.1)
                        : secondaryColor.withOpacity(0.1)),
                child: Icon(
                  meneItem.icon,
                  color: index % 2 == 0 ? primaryColor : secondaryColor,
                  size: 18.px,
                ),
              ),
            ),
            SizedBox(
              height: 4.px,
            ),
            Text(
              languageCode == 'zh'
                  ? meneItem.cname ?? ''
                  : languageCode == 'en'
                      ? meneItem.yname ?? ''
                      : meneItem.uname ?? '',
              maxLines: 2,
              style: TextStyle(fontSize: 12.px),
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

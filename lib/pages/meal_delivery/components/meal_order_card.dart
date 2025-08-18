import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/meal_delivery_utils.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/location_page.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/meal_delivery_model.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/meal_delivery_detail_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class MealOrderCard extends StatefulWidget {
  final MealDeliveryOrderModel orderInfo;
  final UserInfoModel userInfo;
  final Function()? onSubmitSuccess;
  final Function()? onCompleteSuccess;

  MealOrderCard({
    required this.orderInfo,
    required this.userInfo,
    this.onSubmitSuccess,
    this.onCompleteSuccess,
  });

  @override
  _MealOrderCardState createState() => _MealOrderCardState();
}

class _MealOrderCardState extends State<MealOrderCard> {
  late String actionButtonText;
  late List roleId = widget.userInfo.mealUser?.permissions ?? [];
  MealDeliveryModel mealDeliveryModel = MealDeliveryModel();

  String getCenterStatusText(int statusCode) {
    switch (statusCode) {
      case 0:
        return S.of(context).groupNotSubmitted;
      case 1:
        return S.of(context).groupSubmitted;
      case 2:
        return S.of(context).departmentSubmitted;
      case 3:
        return S.of(context).orderCenterConfirmed;
      default:
        return S.of(context).groupNotSubmitted;
    }
  }

  String getOrderStatusText(int statusCode) {
    switch (statusCode) {
      case 0:
        return S.of(context).deliveryOrderPlaced;
      case 1:
        return S.of(context).deliveryCooking;
      case 2:
        return S.of(context).deliveryPacked;
      case 3:
        return S.of(context).deliveryDelivering;
      case 4:
        return S.of(context).deliveryDelivered;
      default:
        return S.of(context).deliveryCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderInfo = widget.orderInfo;
    return Slidable(
      key: const ValueKey(0),
      enabled: orderInfo.orderStatus != "-1",
      endActionPane:
          orderInfo.orderStatus == "-1" ? null : _buildActionPane(orderInfo),
      child: GestureDetector(
        onTap:
            () => Navigator.pushNamed(
              context,
              '/OrderDetailPage',
              arguments: {"orderInfo": orderInfo},
            ),
        child: _buildOrderCard(context, orderInfo),
      ),
    );
  }

  getFoodType(String foodType) {
    switch (foodType) {
      case "0":
        return S.of(context).chineseFood;
      case "1":
        return S.of(context).indonesianFood;
      case "2":
        return S.of(context).bottleWater;
      default:
        return S.of(context).chineseFood;
    }
  }

  String getFoodName(String foodCode) {
    switch (foodCode) {
      case "0":
        return S.of(context).breakfast;
      case "1":
        return S.of(context).lunch;
      case "2":
        return S.of(context).dinner;
      case "3":
        return S.of(context).nightSnack;
      case "4":
        return S.of(context).waterService;
      case "5":
        return S.of(context).dessert;
      case "6":
        return S.of(context).earlyTea;
      default:
        return "--";
    }
  }

  String getSourceType(String sourceCode) {
    switch (sourceCode) {
      case "0":
        return S.of(context).normalOrder;
      case "1":
        return S.of(context).supplementOrder;
      default:
        return S.of(context).reduceOrder;
    }
  }

  String getleaderStatus(String sourceCode) {
    switch (sourceCode) {
      case "0":
        return S.of(context).deliveryNotAudited;
      case "1":
        return S.of(context).deliveryAudited;
      default:
        return S.of(context).deliveryAuditRejected;
    }
  }

  String extractAfterLastSlash(handleStr) {
    var str = handleStr ?? '';
    RegExp regExp = RegExp(r'\/([^\/]*)$');
    Match? match = regExp.firstMatch(str);
    return match?.group(1) ?? '';
  }

  Widget _buildOrderCard(
    BuildContext context,
    MealDeliveryOrderModel orderInfo,
  ) {
    return GestureDetector(
      onTap: () {
        final result = Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MealDeliveryDetailPage(
                  orderId: orderInfo.oId.toString(),
                  userInfo: widget.userInfo,
                ),
          ),
        );
        if (result == true) {
          widget.onCompleteSuccess?.call();
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 10.px),
        decoration: BoxDecoration(
          color: Color(0xFFFDFCF9),
          borderRadius: BorderRadius.circular(10.px),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10.px,
              offset: Offset(0, 4.px),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    int orderStatus = int.parse(orderInfo.orderStatus ?? '0');
                    if (3 == orderStatus) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  LocationPage(fcName: orderInfo.fcName ?? ''),
                        ),
                      );
                    } else {
                      ProgressHUD.showError(S.of(context).deliveryNotStarted);
                    }
                  },
                  child: Container(
                    width: 45.px,
                    height: 45.px,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10.px),
                      boxShadow: [
                        BoxShadow(color: Color(0x72D3D1D8), blurRadius: 10.px),
                      ],
                    ),
                    child: const Icon(
                      Icons.share_location,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10.px),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              orderInfo.deliverySite ?? '',
                              style: TextStyle(
                                fontSize: 12.px,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: "#" + (orderInfo.orderNo ?? ''),
                                ),
                              );
                              ProgressHUD.showSuccess(
                                S.of(context).copySuccess,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "#" + (orderInfo.orderNo ?? ''),
                              style: TextStyle(
                                fontSize: 10.px,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              getFoodType(orderInfo.foodType ?? ''),
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 10.px,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Text(
                              '(${getCenterStatusText(int.parse(orderInfo.centerStatus ?? '0'))})',
                              softWrap: true,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 10.px,
                                color:
                                    orderInfo.centerStatus == "0"
                                        ? secondaryColor[400]
                                        : primaryColor[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.px),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getFoodName(orderInfo.foodName ?? ''),
                            style: TextStyle(
                              fontSize: 10.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "(${getleaderStatus(orderInfo.leaderStatus ?? '0')})",
                            style: TextStyle(
                              fontSize: 10.px,
                              color:
                                  orderInfo.leaderStatus == "1"
                                      ? primaryColor[900]
                                      : secondaryColor[400],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.px),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${orderInfo.packageType == "0"
                                ? S.of(context).deliveryBag
                                : orderInfo.packageType == "1"
                                ? S.of(context).deliveryMealBox
                                : S.of(context).deliveryBucket}',
                            style: TextStyle(
                              fontSize: 10.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      orderInfo.reason != null
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).deliveryRejectReason,
                                style: TextStyle(
                                  fontSize: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                orderInfo.reason ?? '',
                                style: TextStyle(
                                  fontSize: 12.px,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                          : const SizedBox(height: 0),
                      SizedBox(height: 5.px),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${extractAfterLastSlash(orderInfo.deptName)}',
                      style: TextStyle(fontSize: 14.px),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: S.of(context).orderNum,
                            style: TextStyle(fontSize: 12.px),
                          ),
                          TextSpan(
                            text: orderInfo.pNum.toString(),
                            style: TextStyle(fontSize: 18.px),
                          ),
                          TextSpan(
                            text: S.of(context).orderNumUnit,
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 60.px,
                  height: 60.px,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.px),
                    border: Border.all(
                      color: secondaryColor[400]!,
                      width: 2.px,
                    ),
                  ),
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      getOrderStatusText(
                        int.parse(orderInfo.orderStatus ?? '0'),
                      ),
                      style: TextStyle(
                        fontSize: 12.px,
                        fontWeight: FontWeight.w700,
                        color: secondaryColor[400]!,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [..._buildButtonWidgets(orderInfo)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _handleBtn(
    BuildContext context,
    Function actionCallback,
    String title,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => actionCallback(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 4.px),
        margin: EdgeInsets.only(left: 10.px),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.px),
          border: Border.all(color: color),
        ),
        child: Text(title, style: TextStyle(color: color, fontSize: 12.px)),
      ),
    );
  }

  List<Widget> _buildButtonWidgets(MealDeliveryOrderModel orderInfo) {
    List<Widget> buttonWidgets = [];
    for (var element in roleId) {
      if (element.contains('driver') &&
          orderInfo.orderStatus == "2" &&
          roleId.contains('order:orders:editStatus') == true) {
        buttonWidgets.clear();
        buttonWidgets.add(
          _handleBtn(
            context,
            () => _driverRoleActions(orderInfo),
            S.of(context).deliveryStartDelivery,
            Colors.blue,
          ),
        );
      } else {
        switch (element) {
          case 'package':
            if (orderInfo.orderStatus == "1" &&
                roleId.contains('order:orders:editStatus') == true) {
              buttonWidgets.clear();
              buttonWidgets.add(
                _handleBtn(
                  context,
                  () => _packageRoleActions(orderInfo),
                  S.of(context).deliveryPackage,
                  Colors.blue,
                ),
              );
              break;
            }
          default:
            if (roleId.contains('order:orders:teamSubmit') == true &&
                orderInfo.centerStatus == "0") {
              buttonWidgets.clear();
              buttonWidgets.add(
                _handleBtn(
                  context,
                  () => _defaultActions(orderInfo),
                  S.of(context).deliveryReturnOrder,
                  secondaryColor[400]!,
                ),
              );
              buttonWidgets.add(
                _handleBtn(
                  context,
                  () => _teamSubmitRoleActions(orderInfo),
                  S.of(context).deliverySubmit,
                  primaryColor[400]!,
                ),
              );
              break;
            } else if (roleId.contains('order:orders:deptSubmit') == true &&
                orderInfo.centerStatus == "1" &&
                orderInfo.leaderStatus == "0") {
              buttonWidgets.clear();
              buttonWidgets.add(
                _handleBtn(
                  context,
                  () => _deptSubmitRoleActions(orderInfo),
                  S.of(context).deliverySubmit,
                  Colors.green,
                ),
              );
              buttonWidgets.add(
                _handleBtn(
                  context,
                  () => _deptDefaultActions(orderInfo),
                  S.of(context).deliveryReject,
                  Colors.red,
                ),
              );
              break;
            }
        }
      }
    }
    return buttonWidgets;
  }

  ActionPane _buildActionPane(MealDeliveryOrderModel orderInfo) {
    List<ActionButton> buttons;
    for (var element in roleId) {
      if (element.contains('driver') &&
          orderInfo.orderStatus == "2" &&
          roleId.contains('order:orders:editStatus') == true) {
        buttons = [
          ActionButton(
            label: S.of(context).deliveryStartDelivery,
            actionCallback: _driverRoleActions,
            backgroundColor: Colors.blue,
            icon: Icons.local_shipping,
          ),
        ];
        break;
      } else {
        switch (element) {
          case 'package':
            if (orderInfo.orderStatus == "1" &&
                roleId.contains('order:orders:editStatus') == true) {
              buttons = [
                ActionButton(
                  label: S.of(context).deliveryPackage,
                  actionCallback: _packageRoleActions,
                  backgroundColor: Colors.blue,
                  icon: Icons.archive,
                ),
              ];
              break;
            }
            return const ActionPane(motion: StretchMotion(), children: []);
          default:
            if (roleId.contains('order:orders:teamSubmit') == true &&
                orderInfo.centerStatus == "0") {
              buttons = [
                ActionButton(
                  label: S.of(context).deliveryReturnOrder,
                  actionCallback: _defaultActions,
                  backgroundColor: secondaryColor[400]!,
                  icon: Icons.cancel,
                ),
                ActionButton(
                  label: S.of(context).deliverySubmit,
                  actionCallback: _teamSubmitRoleActions,
                  backgroundColor: primaryColor[400]!,
                  icon: Icons.check_circle,
                ),
              ];
              break;
            } else if (roleId.contains('order:orders:deptSubmit') == true &&
                orderInfo.centerStatus == "1" &&
                orderInfo.leaderStatus == "0") {
              buttons = [
                ActionButton(
                  label: S.of(context).deliverySubmit,
                  actionCallback: _deptSubmitRoleActions,
                  backgroundColor: Colors.green,
                  icon: Icons.check_circle,
                ),
                ActionButton(
                  label: S.of(context).deliveryReject,
                  actionCallback: _deptDefaultActions,
                  backgroundColor: Colors.red,
                  icon: Icons.cancel,
                ),
              ];
              break;
            }
            return const ActionPane(motion: StretchMotion(), children: []);
        }
      }
      return _roleSpecificActionPane(orderInfo, buttons);
    }
    return const ActionPane(motion: StretchMotion(), children: []);
  }

  // 班组提交
  _teamSubmitRoleActions(MealDeliveryOrderModel orderInfo) async {
    await mealDeliveryModel.teamSubmitOrder(context, orderInfo.oId);
    widget.onSubmitSuccess?.call();
  }

  //部门提交
  _deptSubmitRoleActions(MealDeliveryOrderModel orderInfo) async {
    await mealDeliveryModel.deptSubmitOrder(context, orderInfo.oId);
    widget.onSubmitSuccess?.call();
  }

  //部门驳回
  _deptDefaultActions(MealDeliveryOrderModel orderInfo) async {
    MealDeliveryUtils.returnOrderMealByDept(
      orderInfo.oId,
      success: (res) {
        if (res['code'] == 200) {
          ProgressHUD.showSuccess(S.of(context).deliveryRejectSuccess);
          widget.onSubmitSuccess?.call();
        } else {
          ProgressHUD.showError(S.of(context).deliveryRejectFail);
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(S.of(context).deliveryRejectFail);
      },
    );
  }

  // 打包
  _packageRoleActions(MealDeliveryOrderModel orderInfo) {
    _onPackageRoleActionPressed(context, orderInfo);
  }

  // 配送
  _driverRoleActions(MealDeliveryOrderModel orderInfo) async {
    await mealDeliveryModel.deliverOrder(context, orderInfo.oId);
  }

  // 退单
  _defaultActions(MealDeliveryOrderModel orderInfo) {
    _onDefaultActionPressed(context, orderInfo.oId);
  }
}

class ActionButton {
  final String label;
  final Function(MealDeliveryOrderModel) actionCallback;
  final Color backgroundColor;
  final IconData icon;

  ActionButton({
    required this.label,
    required this.actionCallback,
    required this.backgroundColor,
    required this.icon,
  });
}

ActionPane _roleSpecificActionPane(
  MealDeliveryOrderModel orderInfo,
  List<ActionButton> buttons,
) {
  List<Widget> children = [];

  for (int i = 0; i < buttons.length; i++) {
    final button = buttons[i];
    if (i == 0) {
      children.add(SizedBox(width: 6.px));
    }
    // 添加按钮
    children.add(
      SlidableAction(
        flex: 1,
        onPressed: (context) => button.actionCallback(orderInfo),
        backgroundColor: button.backgroundColor,
        foregroundColor: Colors.white,
        icon: button.icon,
        label: button.label,
        borderRadius: BorderRadius.circular(15.px),
        autoClose: true,
        spacing: 4.px,
      ),
    );

    // 在按钮之间添加间距（除了最后一个按钮）

    if (i < buttons.length - 1) {
      children.add(SizedBox(width: 6.px));
    }
  }

  return ActionPane(motion: const StretchMotion(), children: children);
}

//退单
_onDefaultActionPressed(BuildContext context, orderInfo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).deliveryReturnOrderConfirm),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // 左边的按钮
              TextButton(
                child: Text(S.of(context).deliveryCancel),
                onPressed: () {
                  Navigator.of(context).pop(); // 关闭对话框
                },
              ),
              // 右边的按钮
              TextButton(
                child: Text(S.of(context).deliveryConfirm),
                onPressed: () async {
                  // 在这里添加处理退单的逻辑
                  MealDeliveryUtils.cancelOrderMeal(
                    orderInfo,
                    success: (res) {
                      if (res['code'] == 200) {
                        ProgressHUD.showSuccess(
                          S.of(context).deliveryReturnOrderSuccess,
                        );
                        //更新订单列表
                        Navigator.pop(context);
                      }
                    },
                    fail: (code, msg) {
                      ProgressHUD.showError(
                        S.of(context).deliveryReturnOrderFail,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

//打包选择车队
// 自定义类表示下拉菜单项
class DropdownMenuItemModel {
  String label;
  int value;

  DropdownMenuItemModel({required this.label, required this.value});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DropdownMenuItemModel &&
        other.label == label &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(label, value);
}

//选择车队
_onPackageRoleActionPressed(context, orderInfo) async {
  // 初始化选择
  DropdownMenuItemModel selectedOption = DropdownMenuItemModel(
    label: S.of(context).deliverySelectTeam,
    value: 0,
  );
  List<DropdownMenuItemModel> menuItems = [
    DropdownMenuItemModel(label: S.of(context).deliverySelectTeam, value: 0),
  ];

  MealDeliveryUtils.getMealCar(
    orderInfo['fdId'],
    success: (res) {
      if (res['code'] == 200) {
        res['data'].forEach((element) {
          menuItems.add(
            DropdownMenuItemModel(
              label: element['fcName'],
              value: element['fcId'],
            ),
          ); // 假设fcId为value
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: Text(S.of(context).deliverySelectTeam),
                  content: DropdownButton<DropdownMenuItemModel>(
                    value: selectedOption,
                    items:
                        menuItems.map((DropdownMenuItemModel item) {
                          return DropdownMenuItem<DropdownMenuItemModel>(
                            value: item,
                            child: Text(item.label),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedOption = newValue!;
                      });
                    },
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // 左边的按钮
                        TextButton(
                          child: Text(S.of(context).deliveryCancel),
                          onPressed: () {
                            Navigator.of(context).pop(); // 关闭对话框
                          },
                        ),
                        // 右边的按钮
                        TextButton(
                          child: Text(S.of(context).deliveryConfirm),
                          onPressed: () async {
                            orderInfo.packageOrder(
                              context,
                              orderInfo['oId'],
                              selectedOption.value,
                              selectedOption.label,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      }
    },
    fail: (code, msg) {
      ProgressHUD.showError(S.of(context).deliverySelectTeamFail);
    },
  );
}

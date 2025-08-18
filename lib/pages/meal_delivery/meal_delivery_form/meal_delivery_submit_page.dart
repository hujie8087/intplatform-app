import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/meal_delivery/components/delivery_site_selector.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/meal_delivery_model.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/person_select_page.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/product_card.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/meal_delivery_order_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';
import 'package:slide_switcher/slide_switcher.dart';

class MealOrder {
  String mealType; // 餐食类型
  String timeSlot; // 配送时间段
  String site; // 配送站点
  String packType; // 打包方式
  String deliveryType; // 配送方式
  int quantity; // 份数

  MealOrder({
    required this.mealType,
    required this.timeSlot,
    required this.site,
    required this.packType,
    required this.deliveryType,
    required this.quantity,
  });
}

class MealDeliverySubmitPage extends StatefulWidget {
  final String foodName;
  MealDeliverySubmitPage({required this.foodName});
  @override
  _MealDeliverySubmitPageState createState() => _MealDeliverySubmitPageState();
}

class _MealDeliverySubmitPageState extends State<MealDeliverySubmitPage> {
  final _formKey = GlobalKey<FormState>();

  MealDeliveryModel mealDeliveryModel = MealDeliveryModel();

  int _packType = 0;
  int _deliveryType = 0;
  MealDeliverySiteModel? _selectedDeliverySite;
  List<MealDeliveryTimeModel> _deliveryTimes = [];
  MealDeliveryTimeModel? _selectedDeliveryTime;
  TextEditingController _quantityController = TextEditingController();
  UserInfoModel? _userInfo;
  List<FoodOrdersDetil> _foodOrdersDetil = [];
  late List statusArrays;

  int _selectedMealType = -1;

  @override
  void initState() {
    super.initState();
    _quantityController.text = '0';
    _fetchData();
  }

  Future<void> _fetchData() async {
    await mealDeliveryModel.getFoodType();
    // 模拟异步数据获取
    var userInfoData = await SpUtils.getModel('userInfo');
    await mealDeliveryModel.getCanOrderTimeList();
    _deliveryTimes.clear();
    // 更新状态
    setState(() {
      if (userInfoData != null) {
        _userInfo = UserInfoModel.fromJson(userInfoData);
      }

      _deliveryTimes =
          mealDeliveryModel.canOrderTimeList
              .where(
                (element) =>
                    element.tType != '4' &&
                    element.tType != '5' &&
                    element.tType != '6',
              )
              .map((element) {
                return MealDeliveryTimeModel(
                  id: element.tId,
                  name:
                      mealDeliveryModel.foodTypeList
                          .firstWhere(
                            (e) => e.dictValue == element.tType,
                            orElse: () => DictModel(),
                          )
                          .dictLabel,
                  value: element.tType,
                  disabled:
                      element.tType != null
                          ? checkCanOrderTime(element.tType!)
                          : false,
                );
              })
              .toList();
    });
  }

  bool checkCanOrderTime(String tType) {
    final now = DateTime.now();
    MealDeliveryTimeListModel mealType = mealDeliveryModel.canOrderTimeList
        .firstWhere((element) => element.tType == tType);

    var startParts = mealType.beginTime?.split(':') ?? [];
    var endParts = mealType.endTime?.split(':') ?? [];

    // 解析起始和结束时间
    startParts = mealType.deptBeginTime?.split(':') ?? [];
    endParts = mealType.deptEndTime?.split(':') ?? [];

    // 安全检查：确保时间格式正确
    if (startParts.length < 2 || endParts.length < 2) {
      return false;
    }

    try {
      final startHour = int.parse(startParts[0]);
      final startMinute = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMinute = int.parse(endParts[1]);

      final startTime = DateTime(
        now.year,
        now.month,
        now.day,
        startHour,
        startMinute,
      );

      final endTime = DateTime(
        now.year,
        now.month,
        now.day,
        endHour,
        endMinute,
      );

      if (endTime.isAfter(startTime)) {
        // 情况 1：起止在同一天内（如 06:00 - 16:00）
        return now.isAfter(startTime) && now.isBefore(endTime);
      } else {
        // 情况 2：跨天的时间段（如 22:00 - 06:00）
        return now.isAfter(startTime) || now.isBefore(endTime);
      }
    } catch (e) {
      // 如果时间解析失败，返回false
      print('时间解析错误: $e');
      return false;
    }
  }

  void changeMealType(int index) {
    setState(() {
      _selectedMealType = index;
      statusArrays = [index, 2];
      _selectedDeliverySite = null;
      getSeatList(index);
    });
  }

  getSeatList(nationType) async {
    //删除之前的数据
    await mealDeliveryModel.getMealPlace({'nationType': nationType});
  }

  Future<void> _submit() async {
    if (mealDeliveryModel.selectedPeople.length == 0 &&
        widget.foodName != '99') {
      ProgressHUD.showError(S.of(context).deliverySelectPerson);
      return;
    }

    if (_selectedDeliverySite == null) {
      ProgressHUD.showError(S.of(context).deliverySelectPlace);
      return;
    }

    _foodOrdersDetil =
        mealDeliveryModel.selectedPeople
            .map(
              (e) => FoodOrdersDetil(
                userName: e.username,
                userNo: e.jobNumber,
                userId: e.id.toString(),
                deptName: e.deptPath,
                deptId: e.deptId,
                postId: e.postId.toString(),
                companyId: e.companyId.toString(),
                postName: e.postName,
                nationType: e.nationType,
                companyName: e.companyName,
                delFlag: e.delFlag,
                updateTime: e.updateTime,
                updateBy: e.updateBy,
                createTime: e.createTime,
                createBy: e.createBy,
                deleteTime: e.deleteTime,
                deleteBy: e.deleteBy,
                userIdList: e.userIdList,
                firstLevelDeptName: e.deptName,
              ),
            )
            .toList();

    if (_formKey.currentState!.validate()) {
      final parameters = {
        "jobNumber": _userInfo?.user?.userName,
        "deliverySite": _selectedDeliverySite?.fsAddressId,
        "foodName":
            widget.foodName == '99'
                ? _selectedDeliveryTime?.value
                : widget.foodName,
        "foodType": _selectedMealType,
        "foodOrdersDetil": _foodOrdersDetil.map((e) => e.toJson()).toList(),
        "pNum": _quantityController.text,
        "deliveryId": _selectedDeliverySite?.fsId,
        "packageType": _packType,
        "deliveryType": _deliveryType,
        "orderType": '0',
      };
      try {
        final result = await mealDeliveryModel.submitOrder(parameters);
        if (result) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MealDeliveryOrderPage()),
          );
        }
      } catch (e) {
        ProgressHUD.showError(
          '${S.of(context).deliverySubmitOrderFail},${e.toString()}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: mealDeliveryModel,
      child: Consumer<MealDeliveryModel>(
        builder: (context, mealDeliveryModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                S.of(context).deliverySubmitOrder,
                style: TextStyle(fontSize: 16.px),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(12.px),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 选择餐种
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ProductCard(
                            imageUrl: "assets/images/chinese_food.png",
                            productName: S.of(context).chineseFood,
                            isSelected: _selectedMealType == 0,
                            onTap: () => changeMealType(0),
                          ),
                        ),
                        SizedBox(width: 12.px),
                        Expanded(
                          child: ProductCard(
                            imageUrl: "assets/images/indonesia_food.png",
                            productName: S.of(context).indonesianFood,
                            isSelected: _selectedMealType == 1,
                            onTap: () => changeMealType(1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.px),
                    // 选择用餐时间段
                    if (widget.foodName == '99')
                      Container(
                        margin: EdgeInsets.only(bottom: 15.px),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.px),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x99C2BFAC),
                              blurRadius: 15.px,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.px,
                            vertical: 0.px,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.px),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x99C2BFAC),
                                blurRadius: 10.px,
                                offset: Offset(0, 8.px),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: DropdownButton<MealDeliveryTimeModel>(
                            isExpanded: true,
                            value: _selectedDeliveryTime,
                            hint: Text(
                              S.of(context).deliverySelectTime,
                              style: TextStyle(fontSize: 12.px),
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                            underline: SizedBox(),
                            onChanged: (MealDeliveryTimeModel? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedDeliveryTime = newValue;
                                });
                              }
                            },
                            items:
                                _deliveryTimes.map<
                                  DropdownMenuItem<MealDeliveryTimeModel>
                                >((MealDeliveryTimeModel value) {
                                  return DropdownMenuItem<
                                    MealDeliveryTimeModel
                                  >(
                                    value: value,
                                    child: Text(value.name ?? ''),
                                    enabled: value.disabled ?? false,
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    // 选择用餐都地点
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.px),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x99C2BFAC),
                            blurRadius: 15.px,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Container(
                        height: 45.px,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.px,
                          vertical: 0.px,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.px),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x99C2BFAC),
                              blurRadius: 10.px,
                              offset: Offset(0, 8.px),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet<
                              MealDeliverySiteModel
                            >(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return DeliverySiteSelector(
                                  sites: mealDeliveryModel.deliverySites,
                                  selectedSite: _selectedDeliverySite,
                                );
                              },
                            );
                            if (result != null) {
                              setState(() {
                                _selectedDeliverySite = result;
                              });
                            }
                          },
                          child: Container(
                            height: 40.px,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: primaryColor,
                                  size: 20.px,
                                ),
                                SizedBox(width: 10.px),
                                Expanded(
                                  child: Text(
                                    _selectedDeliverySite?.fsAddressCn ??
                                        S.of(context).deliverySelectPlace,
                                    style: TextStyle(
                                      fontSize: 12.px,
                                      color:
                                          _selectedDeliverySite != null
                                              ? Colors.black
                                              : Colors.grey,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.px),
                    // 打包方式
                    Container(
                      height: 45.px,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x99C2BFAC),
                            blurRadius: 15.px,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SlideSwitcher(
                            containerColor: primaryColor,
                            containerBorderRadius: 10.px,
                            onSelect:
                                (int index) =>
                                    setState(() => _packType = index),
                            containerHeight: 45.px,
                            containerWight:
                                constraints.maxWidth -
                                2 * 4.px, // 实际宽度减去左右 padding
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.takeout_dining,
                                    color:
                                        _packType == 0
                                            ? primaryColor
                                            : Colors.white,
                                    size: 16.px,
                                  ),
                                  SizedBox(width: 5.px),
                                  Text(
                                    S.of(context).deliveryPackedMeal,
                                    style: TextStyle(
                                      fontWeight:
                                          _packType == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          _packType == 0
                                              ? primaryColor
                                              : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lunch_dining,
                                    color:
                                        _packType == 1
                                            ? primaryColor
                                            : Colors.white,
                                    size: 16.px,
                                  ),
                                  SizedBox(width: 5.px),
                                  Text(
                                    S.of(context).deliveryBoxedMeal,
                                    style: TextStyle(
                                      fontWeight:
                                          _packType == 1
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          _packType == 1
                                              ? primaryColor
                                              : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15.px),
                    // 配送方式
                    Container(
                      height: 45.px,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.px),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x99C2BFAC),
                            blurRadius: 15.px,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SlideSwitcher(
                            containerColor: primaryColor,
                            containerBorderRadius: 10.px,
                            onSelect:
                                (int index) =>
                                    setState(() => _deliveryType = index),
                            containerHeight: 45.px,
                            containerWight:
                                constraints.maxWidth -
                                2 * 4.px, // 实际宽度减去左右 padding
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delivery_dining,
                                    color:
                                        _deliveryType == 0
                                            ? primaryColor
                                            : Colors.white,
                                    size: 16.px,
                                  ),
                                  SizedBox(width: 5.px),
                                  Text(
                                    S.of(context).delivery,
                                    style: TextStyle(
                                      fontWeight:
                                          _deliveryType == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          _deliveryType == 0
                                              ? primaryColor
                                              : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.store,
                                    color:
                                        _deliveryType == 1
                                            ? primaryColor
                                            : Colors.white,
                                    size: 16.px,
                                  ),
                                  SizedBox(width: 5.px),
                                  Text(
                                    S.of(context).selfPickup,
                                    style: TextStyle(
                                      fontWeight:
                                          _deliveryType == 1
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          _deliveryType == 1
                                              ? primaryColor
                                              : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15.px),
                    // 份数
                    if (widget.foodName == '99')
                      Container(
                        margin: EdgeInsets.only(bottom: 15.px),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.px),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x99C2BFAC),
                              blurRadius: 15.px,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        height: 45.px,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 24.px),
                            Icon(
                              Icons.people,
                              color: primaryColor,
                              size: 20.px,
                            ),
                            SizedBox(width: 10.px),
                            Text(
                              S.of(context).deliveryQuantity,
                              style: TextStyle(
                                fontSize: 12.px,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 10.px),
                            IconButton(
                              onPressed:
                                  () => setState(() {
                                    if (int.parse(_quantityController.text) >
                                        0) {
                                      _quantityController.text =
                                          (int.parse(_quantityController.text) -
                                                  1)
                                              .toString();
                                    } else {
                                      _quantityController.text = '0';
                                    }
                                  }),
                              icon: Icon(Icons.remove, color: primaryColor),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _quantityController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '0',
                                  hintStyle: TextStyle(fontSize: 12.px),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 12.px),
                                textAlign: TextAlign.center,
                                onChanged:
                                    (value) => setState(
                                      () => _quantityController.text = value,
                                    ),
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  () => setState(() {
                                    _quantityController.text =
                                        (int.parse(_quantityController.text) +
                                                1)
                                            .toString();
                                  }),
                              icon: Icon(Icons.add, color: primaryColor),
                            ),
                          ],
                        ),
                      ),

                    if (widget.foodName != '99')
                      // 选择人员
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 15.px),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.px),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x99C2BFAC),
                              blurRadius: 15.px,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (_selectedMealType == -1) {
                              ProgressHUD.showError(
                                S.of(context).deliverySelectMealType,
                              );
                              return;
                            }
                            await mealDeliveryModel.getMealPersonList({
                              'deptId': _userInfo?.mealUser?.sysUser?.deptId,
                              'foodName': widget.foodName,
                              'foodType': _selectedMealType,
                              'statusArrays': statusArrays,
                            });
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PersonSelectPage(
                                      people: mealDeliveryModel.people,
                                      selectedPeople:
                                          mealDeliveryModel.selectedPeople,
                                    ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _quantityController.text =
                                    result.length.toString();
                                mealDeliveryModel.selectedPeople = result;
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add,
                                color: primaryColor,
                                size: 18.px,
                              ),
                              SizedBox(width: 8.px),
                              Text(
                                mealDeliveryModel.selectedPeople.length > 0
                                    ? '${S.of(context).deliverySelectedPeople}(${mealDeliveryModel.selectedPeople.length})'
                                    : S.of(context).deliverySelectPerson,
                                style: TextStyle(fontSize: 12.px),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 18.px,
                          ),
                          SizedBox(width: 8.px),
                          Text(
                            S.of(context).deliveryCreateOrder,
                            style: TextStyle(
                              fontSize: 16.px,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 45.px),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

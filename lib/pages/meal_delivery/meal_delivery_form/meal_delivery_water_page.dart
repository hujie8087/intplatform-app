import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/meal_delivery/components/delivery_site_selector.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/meal_delivery_model.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/meal_delivery_order_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';
import 'package:slide_switcher/slide_switcher.dart';

class MealDeliveryWaterPage extends StatefulWidget {
  const MealDeliveryWaterPage({Key? key}) : super(key: key);

  @override
  _MealDeliveryWaterPageState createState() => _MealDeliveryWaterPageState();
}

class _MealDeliveryWaterPageState extends State<MealDeliveryWaterPage> {
  final _formKey = GlobalKey<FormState>();
  MealDeliveryModel mealDeliveryModel = MealDeliveryModel();

  MealDeliverySiteModel? _selectedDeliverySite;
  int _deliveryType = 0;
  TextEditingController _quantityController = TextEditingController();
  UserInfoModel? _userInfo;

  @override
  void initState() {
    super.initState();
    _quantityController.text = '0';
    _fetchData();
    _loadDeliverySites();
  }

  Future<void> _fetchData() async {
    var userInfoData = await SpUtils.getModel('userInfo');
    setState(() {
      if (userInfoData != null) {
        _userInfo = UserInfoModel.fromJson(userInfoData);
      }
    });
  }

  Future<void> _loadDeliverySites() async {
    await mealDeliveryModel.getMealPlace({'nationType': 2});
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
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
                S.of(context).deliveryWaterService,
                style: TextStyle(fontSize: 16.px),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(12.px),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 顶部装饰区域
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.px),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15.px),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4FC3F7).withOpacity(0.3),
                            blurRadius: 10.px,
                            offset: Offset(0, 5.px),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 图标
                          Container(
                            width: 60.px,
                            height: 60.px,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15.px),
                            ),
                            child: Icon(
                              Icons.water_drop,
                              color: Colors.white,
                              size: 30.px,
                            ),
                          ),
                          SizedBox(height: 15.px),
                          // 标题
                          Text(
                            S.of(context).deliveryWaterService,
                            style: TextStyle(
                              fontSize: 18.px,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.px),
                          // 描述
                          Text(
                            S.of(context).deliveryWaterServiceTips,
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.px),

                    // 选择配送站点
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
                            containerWight: constraints.maxWidth - 2 * 4.px,
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

                    // 数量选择
                    Container(
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
                            Icons.water_drop,
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
                                  if (int.parse(_quantityController.text) > 0) {
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
                                      (int.parse(_quantityController.text) + 1)
                                          .toString();
                                }),
                            icon: Icon(Icons.add, color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.px),
                    // 提交按钮
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

  Future<void> _submit() async {
    if (_selectedDeliverySite == null) {
      ProgressHUD.showError(S.of(context).deliverySelectPlace);
      return;
    }

    if (_formKey.currentState!.validate()) {
      final parameters = {
        "jobNumber": _userInfo?.user?.userName,
        "deliverySite": _selectedDeliverySite?.fsAddressId,
        "foodName": '4',
        "foodType": '2',
        "foodOrdersDetil": [],
        "pNum": _quantityController.text,
        "deliveryId": _selectedDeliverySite?.fsId,
        "packageType": '2',
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
          "${S.of(context).deliverySubmitOrderFail},${e.toString()}",
        );
      }
    }
  }
}

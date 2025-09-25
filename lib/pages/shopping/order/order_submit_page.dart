import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/divider_widget.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/delivery_fee_model.dart';
import 'package:logistics_app/http/model/delivery_time_model.dart';
import 'package:logistics_app/http/model/food_model.dart';
import 'package:logistics_app/http/model/restaurant_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/add_address_page.dart';
import 'package:logistics_app/pages/repair/components/my_address_view.dart';
import 'package:logistics_app/pages/repair/repair_data_model.dart';
import 'package:logistics_app/pages/shopping/food_view_model.dart';
import 'package:logistics_app/pages/shopping/order/order_list_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:logistics_app/utils/utils.dart';
import 'package:provider/provider.dart';

class OrderScreenPageWrapper extends StatelessWidget {
  final int restaurantId;
  final List<FoodModel> cartItems;
  final double totalPrice;
  final FoodViewModel foodViewModel;

  const OrderScreenPageWrapper({
    Key? key,
    required this.restaurantId,
    required this.cartItems,
    required this.totalPrice,
    required this.foodViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: foodViewModel,
      child: OrderScreenPage(
        restaurantId: restaurantId,
        cartItems: cartItems,
        totalPrice: totalPrice,
      ),
    );
  }
}

class OrderScreenPage extends StatefulWidget {
  final int restaurantId;
  final List<FoodModel> cartItems;
  final double totalPrice;

  const OrderScreenPage({
    Key? key,
    required this.restaurantId,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _OrderScreenPageState createState() => _OrderScreenPageState();
}

class _OrderScreenPageState extends State<OrderScreenPage> {
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int? selectedPickupType; // 默认取餐方式
  RestaurantModel? restaurantDetail;
  UserInfoModel? userInfo;
  RepairDataModel model = RepairDataModel();
  bool _isLoading = false;

  Future _fetchData() async {
    DataUtils.getDetailById(
      APIs.getRestaurantDetail + '/' + widget.restaurantId.toString(),
      success: (data) {
        restaurantDetail = RestaurantModel.fromJson(data['data']);
        setState(() {});
      },
    );
    var user = await SpUtils.getModel('userInfo');
    userInfo = UserInfoModel.fromJson(user);
    _phoneController.text = userInfo?.user?.phonenumber ?? '';
    model.getMyAddressList(1, 10000);
    _getDeliveryTime();
    _getDeliveryFee();
    _getCanteenPickupType();
  }

  // 餐厅配送方式
  List<DeliveryTimeModel> canteenPickupOptions = [];
  DeliveryTimeModel? selectedCanteenPickupType;
  // 获取餐厅配送方式
  Future _getCanteenPickupType() async {
    ShoppingUtils.getCanteenPickupType(
      widget.restaurantId,
      success: (data) {
        canteenPickupOptions =
            RowsModel<DeliveryTimeModel>.fromJson(
              data,
              (json) => DeliveryTimeModel.fromJson(json),
            ).rows ??
            [];
        setState(() {});
      },
    );
  }

  // 配送时间选择
  List<DeliveryTimeModel> deliveryTimeOptions = [];
  DeliveryTimeModel? selectedDeliveryTime;
  // 获取配送时间列表
  Future _getDeliveryTime() async {
    ShoppingUtils.getRestaurantDeliveryTime(
      widget.restaurantId,
      success: (data) {
        deliveryTimeOptions =
            BaseListModel<DeliveryTimeModel>.fromJson(
              data,
              (json) => DeliveryTimeModel.fromJson(json),
            ).data ??
            [];
        setState(() {
          deliveryTimeOptions = filterTimeSlots(deliveryTimeOptions);
        });
      },
    );
  }

  List<DeliveryFeeModel> deliveryFeeOptions = [];
  DeliveryFeeModel? selectedDeliveryFee;
  // 获取配送费用
  Future _getDeliveryFee() async {
    ShoppingUtils.getRestaurantDeliveryFee(
      widget.restaurantId,
      success: (data) {
        deliveryFeeOptions =
            BaseListModel<DeliveryFeeModel>.fromJson(
              data,
              (json) => DeliveryFeeModel.fromJson(json),
            ).data ??
            [];
        setState(() {});
      },
    );
  }

  // 生成配送费说明
  String generateDeliveryFeeDescription(List<DeliveryFeeModel> rules) {
    List<String> descriptions = [];

    for (var rule in rules) {
      final condition = rule.billingConditions;
      final price = rule.price;

      String readable = '';

      if (condition != null && price != null) {
        // 简单替换逻辑，适用于你给的规则格式
        readable = condition
            .replaceAll('price', '订单金额')
            .replaceAll('<=', '≤')
            .replaceAll('>=', '≥')
            .replaceAll('<', '<')
            .replaceAll('>', '>')
            .replaceAll('&&', '且');

        readable += '  配送费: ${price.toStringAsFixed(2)}';
        descriptions.add(readable);
      }
    }

    return descriptions.join('\n');
  }

  List<DeliveryTimeModel> filterTimeSlots(List<DeliveryTimeModel> slots) {
    final now = DateTime.now();
    final cutoff = now.add(const Duration(hours: 1)); // 当前时间 + 1小时

    return slots.where((slot) {
      // "16:00-16:30" => 取 "16:30"
      final parts = slot.name?.split('-') ?? [];
      if (parts.length != 2) return false;

      final end = parts[1];
      final endParts = end.split(':');
      if (endParts.length != 2) return false;

      final endHour = int.tryParse(endParts[0]) ?? 0;
      final endMinute = int.tryParse(endParts[1]) ?? 0;

      // 用今天的日期拼接结束时间
      final endTime = DateTime(
        now.year,
        now.month,
        now.day,
        endHour,
        endMinute,
      );
      return endTime.isAfter(cutoff);
    }).toList();
  }

  // 第一个页面
  void _navigateToSecondPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAddressPage()),
    );
    // 处理返回值
    if (result == true) {
      model.getMyAddressList(1, 10000).then((value) {
        // _refreshController.refreshCompleted();
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).submitOrder,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 餐厅信息
            Container(
              margin: EdgeInsets.all(8.px),
              padding: EdgeInsets.all(5.px),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.px),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.px),
                        child: CachedNetworkImage(
                          imageUrl:
                              restaurantDetail?.image?.indexOf('food') != -1
                                  ? APIs.foodPrefix +
                                      (restaurantDetail?.image ?? '')
                                  : APIs.imagePrefix +
                                      (restaurantDetail?.image ?? ''),
                          width: 54.px,
                          height: 54.px,
                          fit: BoxFit.cover,
                          errorWidget:
                              (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      SizedBox(width: 8.px),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurantDetail?.name ?? '',
                              style: TextStyle(
                                fontSize: 12.px,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.px),
                            Text(
                              '${S.of(context).businessHours}:${restaurantDetail?.startTime ?? ''} - ${restaurantDetail?.endTime ?? ''}',
                              style: TextStyle(
                                fontSize: 10.px,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 商品列表
                  Container(
                    padding: EdgeInsets.all(8.px),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.px),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).goodsInfo,
                          style: TextStyle(
                            fontSize: 12.px,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.px),
                        ...widget.cartItems
                            .map((item) => _buildOrderItem(item))
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 取餐方式选择
            Container(
              margin: EdgeInsets.only(left: 6.px, right: 6.px, bottom: 6.px),
              padding: EdgeInsets.all(10.px),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.px),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).pickupType,
                    style: TextStyle(
                      fontSize: 12.px,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.px),
                  Row(
                    // 根据restaurantDetail.pickupTypeIds匹配 选择取餐方式
                    children:
                        canteenPickupOptions
                            .where(
                              (e) =>
                                  restaurantDetail?.pickupTypeIds?.contains(
                                    e.id,
                                  ) ??
                                  false,
                            )
                            .map((e) => _buildPickupTypeButton(e.id ?? 1))
                            .toList(),
                  ),
                ],
              ),
            ),
            // 选择配送时显示地址选择
            if (selectedPickupType == 3) ...[
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(6.px),
                padding: EdgeInsets.all(10.px),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.px),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).addressInfo,
                      style: TextStyle(
                        fontSize: 12.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.px),
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(6.px)),
                      onTap:
                          () => {
                            Picker.showModalSheet(
                              context,
                              child: ChangeNotifierProvider.value(
                                value: model,
                                child: MyAddressView(
                                  addressList: model.addressList,
                                  defaultAddress: model.defaultAddress,
                                  onAddressSelected: (address) {
                                    Navigator.pop(context, address);
                                  },
                                  onAddAddress: () => _navigateToSecondPage(),
                                  areaIds: restaurantDetail?.newDeliveryIds,
                                ),
                              ),
                            ).then((value) {
                              if (value != null) {
                                model.defaultAddress = value;
                                _phoneController.text =
                                    model.defaultAddress?.tel ?? '';
                                setState(() {});
                              }
                            }),
                          },
                      child: Ink(
                        padding: EdgeInsets.all(6.px),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.px),
                          ), // 确保边框效果
                        ),
                        child:
                            model.defaultAddress != null
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                model
                                                        .defaultAddress
                                                        ?.detailedAddress ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 12.px,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5.px),
                                              Row(
                                                children: [
                                                  Text(
                                                    model
                                                            .defaultAddress
                                                            ?.name ??
                                                        '',
                                                    style: TextStyle(
                                                      fontSize: 10.px,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6.px),
                                                  Text(
                                                    model.defaultAddress?.tel ??
                                                        '',
                                                    style: TextStyle(
                                                      fontSize: 10.px,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.edit,
                                          color: primaryColor,
                                          size: 16.px,
                                        ),
                                      ],
                                    ),
                                    if (restaurantDetail?.newDeliveryIds !=
                                            null &&
                                        model.defaultAddress != null &&
                                        !(restaurantDetail!.newDeliveryIds
                                                ?.contains(
                                                  model
                                                          .defaultAddress
                                                          ?.areaId ??
                                                      0,
                                                ) ??
                                            false))
                                      Text(
                                        S.of(context).addressOutOfRange,
                                        style: TextStyle(
                                          fontSize: 10.px,
                                          color: Colors.red,
                                        ),
                                      ),
                                  ],
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      S.of(context).selectAddress,
                                      style: TextStyle(color: primaryColor),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: primaryColor,
                                      size: 14.px,
                                    ),
                                  ],
                                ),
                      ),
                    ),
                    SizedBox(height: 6.px),
                    // 配送时间选择
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).deliveryTime + ':',
                          style: TextStyle(fontSize: 12.px),
                        ),
                        // 根据deliveryTimeOptions选择配送时间,用全屏底部弹窗
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _buildDeliveryTimePicker(context).then((value) {
                                if (value != null) {
                                  selectedDeliveryTime = value;
                                  setState(() {});
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedDeliveryTime?.name ?? '',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12.px),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.px),
                    // 配送费
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              S.of(context).deliveryFee + ':',
                              style: TextStyle(fontSize: 12.px),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              size: 20.px,
                                              color: primaryColor,
                                            ),
                                            SizedBox(width: 4.px),
                                            Text(
                                              '配送费说明',
                                              style: TextStyle(fontSize: 14.px),
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                          generateDeliveryFeeDescription(
                                            deliveryFeeOptions,
                                          ),
                                          style: TextStyle(fontSize: 12.px),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('知道了'),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              child: Icon(
                                Icons.info_outline,
                                size: 14.px,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          selectedDeliveryFee?.price?.toStringAsFixed(2) ??
                              '0.00',
                          style: TextStyle(fontSize: 12.px),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            // 个人信息
            Container(
              margin: EdgeInsets.all(6.px),
              padding: EdgeInsets.all(10.px),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.px),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).personalInfo,
                    style: TextStyle(
                      fontSize: 12.px,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.px),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).employeeNumber + ':',
                        style: TextStyle(fontSize: 12.px),
                      ),
                      SizedBox(width: 8.px),
                      Text(
                        userInfo?.user?.userName ??
                            S
                                .of(context)
                                .pleaseFillIn(S.of(context).employeeNumber),
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.px),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).name + ':',
                        style: TextStyle(fontSize: 12.px),
                      ),
                      SizedBox(width: 6.px),
                      Text(
                        userInfo?.user?.nickName ??
                            S.of(context).pleaseFillIn(S.of(context).name),
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.px),
                  // 联系电话
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).phone + ':',
                        style: TextStyle(fontSize: 12.px),
                      ),
                      SizedBox(width: 6.px),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          // 限制输入非数字
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12.px,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: S
                                .of(context)
                                .pleaseFillIn(S.of(context).phone),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 0,
                            ),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.px),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).pickupLimitTime + ':',
                        style: TextStyle(fontSize: 12.px),
                      ),
                      SizedBox(width: 6.px),
                      Text(
                        '${restaurantDetail?.startTime} ~ ${restaurantDetail?.endTime}',
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 备注信息
            Container(
              margin: EdgeInsets.all(6.px),
              padding: EdgeInsets.all(10.px),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.px),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).remark,
                    style: TextStyle(
                      fontSize: 12.px,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.px),
                  TextField(
                    controller: _remarkController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      // 设置行高
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 6.px,
                        horizontal: 6.px,
                      ),
                      hintText: S
                          .of(context)
                          .pleaseFillIn(S.of(context).remark),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.px),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.px),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      // 设置输入时的文字大小
                    ),
                    style: TextStyle(fontSize: 12.px),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // 选择配送时间
  Future _buildDeliveryTimePicker(BuildContext context) {
    return Picker.showModalSheet(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).pleaseSelect(S.of(context).deliveryTime),
            style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6.px),
          Container(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height * 0.4, // 设置最大高度为屏幕高度的40%
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final time in deliveryTimeOptions)
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, time);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 36.px,
                            child: Text(
                              time.name ?? '',
                              style: TextStyle(fontSize: 12.px),
                            ),
                          ),
                        ),
                        DividerWidget(),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).then((value) {
      if (value != null) {
        selectedDeliveryTime = value;
        setState(() {});
      }
    });
  }

  // 选择取餐方式
  Widget _buildPickupTypeButton(int id) {
    bool isSelected = selectedPickupType == id;
    return GestureDetector(
      onTap: () {
        selectedPickupType = id;
        if (id == 1 || id == 2) {
          selectedDeliveryTime = null;
          selectedDeliveryFee = null;
        } else if (id == 3) {
          // 联系电话默认为空
          _phoneController.text = model.defaultAddress?.tel ?? '';
          if (selectedDeliveryFee == null) {
            // 根据订单总价，从deliveryFeeOptions中选择配送费
            selectedDeliveryFee = deliveryFeeOptions.firstWhere(
              (element) => Utils.evaluateExpression(
                element.billingConditions?.replaceAll(
                      'price',
                      widget.totalPrice.toInt().toString(),
                    ) ??
                    '',
              ),
            );
          }
          if (selectedDeliveryTime == null) {
            // 根据订单总价，从deliveryTimeOptions中选择配送时间
            selectedDeliveryTime = deliveryTimeOptions.first;
          }
        }
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.px),
        padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 2.px),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          border: Border.all(color: isSelected ? primaryColor : Colors.grey),
          borderRadius: BorderRadius.circular(6.px),
        ),
        child: Text(
          canteenPickupOptions.firstWhere((e) => e.id == id).name ?? '',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 12.px,
          ),
        ),
      ),
    );
  }

  // 商品信息
  Widget _buildOrderItem(FoodModel item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.px),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          if (item.image.isNotEmpty)
            CachedNetworkImage(
              imageUrl:
                  item.image.indexOf('food') != -1
                      ? APIs.foodPrefix + item.image
                      : APIs.imagePrefix + item.image,
              width: 54.px,
              height: 54.px,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          SizedBox(width: 8.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.px),
                Text(
                  '${item.price}',
                  style: TextStyle(color: secondaryColor, fontSize: 14.px),
                ),
              ],
            ),
          ),
          Text(
            'x${item.num}',
            style: TextStyle(color: Colors.grey, fontSize: 12.px),
          ),
        ],
      ),
    );
  }

  // 底部按钮
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  S.of(context).total + ':',
                  style: TextStyle(fontSize: 14.px),
                ),
                Text(
                  '${(widget.totalPrice + (selectedDeliveryFee?.price ?? 0)).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 18.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.px),
                if (selectedPickupType == 3)
                  Text(
                    S.of(context).deliveryFee +
                        ':${selectedDeliveryFee?.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(color: secondaryColor, fontSize: 10.px),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.px, vertical: 8.px),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.px),
              ),
            ),
            child:
                _isLoading
                    ? SizedBox(
                      width: 20.px,
                      height: 20.px,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2.5,
                      ),
                    )
                    : Text(S.of(context).submitOrder),
          ),
        ],
      ),
    );
  }

  void _submitOrder() {
    // 检查联系电话
    if (_phoneController.text.isEmpty) {
      ProgressHUD.showError(S.of(context).pleaseFillIn(S.of(context).phone));
      return;
    }
    if (restaurantDetail?.id == null) {
      ProgressHUD.showError('店铺信息异常，请返回店铺页面重新提交结算！');
      return;
    }
    // 检查取餐方式没选
    if (selectedPickupType == null) {
      ProgressHUD.showError(
        S.of(context).pleaseSelect(S.of(context).pickupType),
      );
      return;
    }
    // 配送方式为配送时
    if (selectedPickupType == 3) {
      // 检查地址
      if (model.defaultAddress == null) {
        ProgressHUD.showError(
          S.of(context).pleaseSelect(S.of(context).address),
        );
        return;
      }
      // 检查地址是否在配送范围内
      if (restaurantDetail?.newDeliveryIds != null &&
          !restaurantDetail!.newDeliveryIds!.contains(
            model.defaultAddress?.areaId ?? 0,
          )) {
        ProgressHUD.showError(S.of(context).addressOutOfRange);
        return;
      }
    }
    DialogFactory.new().showConfirmDialog(
      context: context,
      title: S.of(context).confirmSubmit,
      content: S.of(context).confirmSubmitContent,
      confirmClick: () {
        Map<String, dynamic> parameters = {
          'name': userInfo?.user?.nickName,
          'tel': _phoneController.text,
          'nick': userInfo?.user?.userName,
          'canteenId': restaurantDetail?.id,
          'canteenName': restaurantDetail?.name,
          'totalPrice': widget.totalPrice,
          'orderDetails': widget.cartItems,
          'remark': _remarkController.text,
          'pickupType': selectedPickupType,
          'expectedTime':
              '${restaurantDetail?.startTime} ~ ${restaurantDetail?.endTime}',
        };
        if (selectedPickupType == 3) {
          double postPrice = selectedDeliveryFee?.price ?? 0;
          parameters['postPrice'] = postPrice;
          parameters['totalPrice'] = widget.totalPrice + postPrice;
          parameters['deliveryArea'] = selectedDeliveryTime?.name;
          parameters['address'] = model.defaultAddress?.detailedAddress;
        }
        setState(() {
          _isLoading = true;
        });
        // 提交订单
        ShoppingUtils.submitOrder(
          parameters,
          success: (value) {
            setState(() {
              _isLoading = false;
            });
            ProgressHUD.showSuccess(S.of(context).submitSuccess);
            Navigator.pop(context); // 关闭对话框
            // 清空当前餐厅的购物车
            context.read<FoodViewModel>().clearCart(restaurantDetail?.id ?? 0);
            // 跳转至订单列表页
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderListPage()),
            );
          },
          fail: (code, msg) {
            setState(() {
              _isLoading = false;
            });
            ProgressHUD.showError(msg);
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/restaurant_view_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:logistics_app/pages/shopping/food_view_model.dart';
import 'package:logistics_app/pages/shopping/restaurant/components/cart_detail_sheet.dart';
import 'package:logistics_app/pages/shopping/order/order_submit_page.dart';
import 'package:logistics_app/utils/color.dart';

class ShoppingCart extends StatelessWidget {
  final GlobalKey cartKey;
  final RestaurantModel? restaurantDetail;

  const ShoppingCart({
    Key? key,
    required this.cartKey,
    required this.restaurantDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodViewModel>(
      builder: (context, foodViewModel, child) {
        // 计算购物车总数量
        int totalQuantity = foodViewModel.cartTotalQuantity;

        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 42.px,
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
          ),
          padding: EdgeInsets.only(
            left: 24.px,
            right: 8.px,
            top: 8.px,
            bottom: 8.px,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: primaryColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: 实现购物车详情
                    showModalBottomSheet(
                      context: context,
                      builder:
                          (context) => ChangeNotifierProvider.value(
                            value: foodViewModel,
                            child: CartDetailSheet(),
                          ),
                    );
                  },
                  child: Row(
                    children: [
                      // 购物车图标，带数字小红点
                      badges.Badge(
                        badgeContent: Text(
                          totalQuantity.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.px,
                          ),
                          key: cartKey,
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          color: totalQuantity > 0 ? Colors.white : Colors.grey,
                          size: 24.px,
                        ),
                      ),
                      SizedBox(width: 8.px),
                      Text(
                        S.of(context).total,
                        style: TextStyle(
                          color: totalQuantity > 0 ? Colors.white : Colors.grey,
                          fontSize: 12.px,
                        ),
                      ),
                      SizedBox(width: 5.px),
                      Text(
                        '${foodViewModel.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 最低消费
              if (restaurantDetail?.lowConsumption != null &&
                  foodViewModel.totalPrice < restaurantDetail!.lowConsumption!)
                Row(
                  children: [
                    Text(
                      '最低消费：',
                      style: TextStyle(color: Colors.white, fontSize: 10.px),
                    ),
                    Text(
                      '${restaurantDetail?.lowConsumption}',
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.px,
                      ),
                    ),
                    SizedBox(width: 10.px),
                  ],
                ),
              ElevatedButton(
                onPressed:
                    totalQuantity > 0 &&
                            (restaurantDetail?.lowConsumption == null ||
                                foodViewModel.totalPrice >=
                                    restaurantDetail!.lowConsumption!)
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OrderScreenPageWrapper(
                                    foodViewModel: foodViewModel,
                                    restaurantId: foodViewModel.restaurantId!,
                                    cartItems: foodViewModel.cartItems,
                                    totalPrice: foodViewModel.totalPrice,
                                  ),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.px)),
                  ),
                  // 当购物车为空时禁用按钮
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(
                  S.of(context).checkout,
                  style: TextStyle(color: Colors.white, fontSize: 12.px),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

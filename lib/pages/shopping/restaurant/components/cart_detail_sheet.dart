import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/food_model.dart';
import 'package:logistics_app/pages/shopping/food_view_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';

class CartDetailSheet extends StatelessWidget {
  const CartDetailSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodViewModel>(
      builder: (context, model, child) {
        if (model.cartItems.isEmpty) {
          return Container(
            padding: EdgeInsets.all(16.px),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.px)),
            ),
            child: Center(
              child: EmptyView(
                text: S.current.cartEmpty,
              ),
            ),
          );
        }

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(14.px)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部标题栏
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.px, vertical: 10.px),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.cart,
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(S.current.clearCart),
                            content: Text(S.current.clearCartTips),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(S.current.cancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  model.clearCart(model.restaurantId ?? 0);
                                  Navigator.pop(context); // 关闭对话框
                                  Navigator.pop(context); // 关闭购物车面板
                                },
                                child: Text(
                                  S.current.clear,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.delete_outline, color: Colors.grey),
                      label: Text(
                        S.current.clear,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              // 购物车商品列表
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = model.cartItems[index];
                    return _buildCartItem(context, item, model);
                  },
                ),
              ),

              // 底部合计
              Container(
                padding: EdgeInsets.all(14.px),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.total,
                      style: TextStyle(fontSize: 14.px),
                    ),
                    Text(
                      '${model.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartItem(
      BuildContext context, FoodModel item, FoodViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.px, vertical: 10.px),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          // 商品图片
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: APIs.foodPrefix + item.image,
              width: 54.px,
              height: 54.px,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(width: 12),

          // 商品信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14.px,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.px),
                Text(
                  '¥${item.price}',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 数量控制
          Row(
            children: [
              IconButton(
                onPressed: () => model.decreaseQuantity(item),
                icon: Icon(Icons.remove_circle_outline),
                color: primaryColor,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${item.num}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: () => model.addToCart(item),
                icon: Icon(Icons.add_circle),
                color: primaryColor,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

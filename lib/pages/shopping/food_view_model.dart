import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/address_form_model.dart';
import 'package:logistics_app/http/model/restaurant_pickup_view_model.dart';
import 'package:logistics_app/http/model/restaurant_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/http/model/food_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class AddressFormResult {
  final bool success;
  final String? errorMessage;
  final RestaurantViewModel? data;

  AddressFormResult({required this.success, this.errorMessage, this.data});
}

class FoodViewModel with ChangeNotifier {
  List<RestaurantModel?>? list = [];
  List<RestaurantPickupViewModel?>? pickupTypes = [];
  List buildingList = [];
  AddressFormModel? addressFormModel;
  List<FoodModel> cartItems = [];
  double totalPrice = 0.0;
  int? restaurantId;
  List<FoodModel> hotFoodList = [];

  // 获取购物车总数量
  int get cartTotalQuantity {
    return cartItems.fold(0, (sum, item) => sum + item.num);
  }

  // 获取餐厅列表
  Future getRestaurantList(pageNum, pageSize) async {
    var params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    DataUtils.getPageList(APIs.getRestaurantList, params, success: (data) {
      RowsModel rowsModel = RowsModel.fromJson(
          data, (json) => RestaurantViewModel.fromJson(json));
      if (rowsModel.rows != null) {
        var myAddressList = data['rows'] as List;
        List<RestaurantModel> rows =
            myAddressList.map((i) => RestaurantModel.fromJson(i)).toList();
        list = rows;
      }
      notifyListeners();
    });
  }

  // 获取餐厅取餐类型
  Future getRestaurantPickTypeList() async {
    DataUtils.getPageList(APIs.getRestaurantPickTypeList, null,
        success: (data) {
      RowsModel rowsModel = RowsModel.fromJson(
          data, (json) => RestaurantPickupViewModel.fromJson(json));
      if (rowsModel.rows != null) {
        var myAddressList = data['rows'] as List;
        List<RestaurantPickupViewModel> rows = myAddressList
            .map((i) => RestaurantPickupViewModel.fromJson(i))
            .toList();
        pickupTypes = rows;
      }
      notifyListeners();
    });
  }

  // 初始化购物车数据
  Future<void> initCartData(int restaurantId) async {
    this.restaurantId = restaurantId;
    await loadCartFromStorage();
  }

  // 从本地存储加载购物车数据
  Future<void> loadCartFromStorage() async {
    try {
      final cartData = await SpUtils.getModel('cart_$restaurantId');
      if (cartData != null) {
        final List cartList = cartData['items'] as List;
        cartItems = cartList.map((item) => FoodModel.fromJson(item)).toList();
        calculateTotal();
      } else {
        cartItems = [];
        totalPrice = 0;
      }
      notifyListeners();
    } catch (e) {
      print('Error loading cart data: $e');
      cartItems = [];
      totalPrice = 0;
      notifyListeners();
    }
  }

  // 保存购物车数据到本地存储
  Future<void> saveCartToStorage() async {
    try {
      final cartData = {
        'restaurantId': restaurantId,
        'items': cartItems.map((item) => item.toJson()).toList(),
      };
      await SpUtils.saveModel('cart_$restaurantId', cartData);
      print('cart_$restaurantId: ${cartData}');
    } catch (e) {
      print('Error saving cart data: $e');
    }
  }

  // 添加到购物车
  void addToCart(FoodModel food) {
    var existingItemIndex = cartItems.indexWhere((item) => item.id == food.id);

    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].num = (cartItems[existingItemIndex].num) + 1;
    } else {
      food.num = 1;
      cartItems.add(food);
    }

    calculateTotal();
    saveCartToStorage();
    notifyListeners();
  }

  // 计算总价
  void calculateTotal() {
    totalPrice =
        cartItems.fold(0, (sum, item) => sum + (item.price * (item.num)));
    notifyListeners();
  }

  // 减少购物车中商品的数量
  void decreaseQuantity(FoodModel food) {
    var existingItemIndex = cartItems.indexWhere((item) => item.id == food.id);

    if (existingItemIndex != -1) {
      if (cartItems[existingItemIndex].num > 1) {
        cartItems[existingItemIndex].num = cartItems[existingItemIndex].num - 1;
      } else {
        cartItems.removeAt(existingItemIndex);
      }

      calculateTotal();
      saveCartToStorage();
      notifyListeners();
    }
  }

  // 清空购物车
  Future<void> clearCart(int restaurantId) async {
    cartItems = [];
    totalPrice = 0;
    await SpUtils.remove('cart_$restaurantId');
    notifyListeners();
  }

  // 获取热门菜品
  Future getHotFoodList() async {
    ShoppingUtils.getHotFoodList(success: (data) {
      hotFoodList = data['rows']
          .map((i) => FoodModel.fromJson(i))
          .toList()
          .cast<FoodModel>();
      notifyListeners();
    });
  }
}

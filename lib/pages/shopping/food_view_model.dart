import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/address_form_model.dart';
import 'package:logistics_app/http/model/restaurant_pickup_view_model.dart';
import 'package:logistics_app/http/model/restaurant_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';

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
}

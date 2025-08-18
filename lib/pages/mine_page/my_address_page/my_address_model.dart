import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/address_form_model.dart';
import 'package:logistics_app/http/model/my_address_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';

class AddressFormResult {
  final bool success;
  final String? errorMessage;
  final AddressModel? data;
  AddressFormResult({required this.success, this.errorMessage, this.data});
}

class MyAddressModel with ChangeNotifier {
  List<AddressModel?>? list = [];
  List buildingList = [];
  AddressFormModel? addressFormModel;
  int currentPage = 1; // 当前页码
  int pageSize = 10; // 每页大小
  int total = 0;
// 获取我的地址列表
  Future<bool> getMyAddressModelList({bool isRefresh = false}) async {
    if (isRefresh) {
      // 重置分页
      currentPage = 1;
      list = [];
    }

    var params = {
      'pageNum': currentPage,
      'pageSize': pageSize,
    };

    final completer = Completer<bool>();

    DataUtils.getPageList(APIs.getMyAddressList, params, success: (data) {
      RowsModel rowsModel =
          RowsModel.fromJson(data, (json) => MyAddressViewModel.fromJson(json));
      if (rowsModel.rows != null) {
        var myAddressList = data['rows'] as List;
        List<AddressModel> rows =
            myAddressList.map((i) => AddressModel.fromJson(i)).toList();
        total = data['total'];

        // 更新列表数据
        if (list == null) {
          list = rows;
        } else {
          list!.addAll(rows);
        }

        // 增加页码
        currentPage++;

        // 在所有数据处理完成后，才通知 UI 更新
        notifyListeners();
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    }, fail: (code, msg) {
      completer.complete(false);
    });

    return completer.future;
  }

// 新增地址
  Future<AddressFormResult> addAddress() async {
    Loading.showLoading();
    final Completer<AddressFormResult> completer =
        Completer<AddressFormResult>();
    DataUtils.addMyAddress(addressFormModel, success: (data) {
      Loading.dismissAll();
      completer.complete(AddressFormResult(success: true));
    }, fail: (code, msg) {
      Loading.dismissAll();
      completer.complete(AddressFormResult(success: false, errorMessage: msg));
    });
    return completer.future;
  }

// 删除我的地址
  Future<AddressFormResult> deleteAddress(ids) async {
    Loading.showLoading();
    final Completer<AddressFormResult> completer =
        Completer<AddressFormResult>();
    DataUtils.deleteAddress(ids, success: (data) {
      Loading.dismissAll();
      completer.complete(AddressFormResult(success: true));
    }, fail: (code, msg) {
      Loading.dismissAll();
      completer.complete(AddressFormResult(success: false, errorMessage: msg));
    });
    return completer.future;
  }

// 获取我的地址详情
  Future<AddressFormResult> getMyAddressDetail(id) async {
    final Completer<AddressFormResult> completer =
        Completer<AddressFormResult>();
    DataUtils.getMyAddressDetail<AddressModel>(id, success: (data) {
      completer.complete(AddressFormResult(
          success: true, data: AddressModel.fromJson(data['data'])));
    }, fail: (code, msg) {
      completer.complete(AddressFormResult(success: false, errorMessage: msg));
    });
    return completer.future;
  }

// 编辑我的地址
  Future<AddressFormResult> editAddress(AddressModel) async {
    Loading.showLoading();
    final Completer<AddressFormResult> completer =
        Completer<AddressFormResult>();
    DataUtils.editMyAddress(AddressModel, success: (data) {
      Loading.dismissAll();
      completer.complete(AddressFormResult(success: true));
    }, fail: (code, msg) {
      Loading.dismissAll();
      completer.complete(AddressFormResult(success: false, errorMessage: msg));
    });
    return completer.future;
  }
}

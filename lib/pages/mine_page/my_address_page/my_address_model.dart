import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/address_form_model.dart';
import 'package:logistics_app/http/model/base_model.dart';
import 'package:logistics_app/http/model/my_address_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/sp_utils.dart';

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
// 获取我的地址列表
  Future getMyAddressModelList(pageNum, pageSize) async {
    var params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    DataUtils.getPageList('/system/address/list', params, success: (data) {
      RowsModel rowsModel =
          RowsModel.fromJson(data, (json) => MyAddressViewModel.fromJson(json));
      if (rowsModel.rows != null) {
        var myAddressList = data['rows'] as List;
        List<AddressModel> rows =
            myAddressList.map((i) => AddressModel.fromJson(i)).toList();
        list = rows;
      }
      notifyListeners();
    });
  }

// 获取生活区数据
  Future getBuildingTreeModel() async {
    var userInfo = await SpUtils.getModel('userInfo');
    if (userInfo != null) {
      DataUtils.getBuildingTree(success: (data) {
        BaseModel rowsModel = BaseModel.fromJson(data);
        if (rowsModel.data != null) {
          buildingList = rowsModel.data;
        }
        notifyListeners();
      });
    } else {
      ProgressHUD.showText(S.current.needLogin);
      RouteUtils.navigateToLogin();
    }
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

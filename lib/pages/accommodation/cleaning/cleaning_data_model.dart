import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/cleaning_form_model.dart';
import 'package:logistics_app/http/model/cleaning_view_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/my_address_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';

class CleaningResult {
  final bool success;
  final String? errorMessage;

  CleaningResult({required this.success, this.errorMessage});
}

class CleaningDataModel with ChangeNotifier {
  List list = [];
  CleaningFormModel? cleaningFormModel;
  List<AddressModel> addressList = [];
  AddressModel? defaultAddress;
  CleaningViewModel? cleaningViewData;
  bool isShowButton = false;
  List<CleaningTypeModel> cleaningTypeList = [];
  List<CleaningViewModel> cleaningOrderList = [];
  List<DictModel> statusList = [];
  int total = 0;
  int pageNum = 1;
  int pageSize = 10;
  bool isRefresh = false;
  String selectedStatus = '-1';
  DateTime? selectedDate;
  String selectedArea = '';
  CleaningTypeModel? selectedItem;
  bool isLoadMore = false;

  // 获取我的地址列表
  Future getMyAddressList(pageNum, pageSize) async {
    var params = {'pageNum': pageNum, 'pageSize': pageSize};
    DataUtils.getPageList(
      APIs.getMyAddressList,
      params,
      success: (data) {
        RowsModel rowsModel = RowsModel.fromJson(
          data,
          (json) => MyAddressViewModel.fromJson(json),
        );
        if (rowsModel.rows != null) {
          var myAddressList = data['rows'] as List;
          List<AddressModel> rows =
              myAddressList.map((i) => AddressModel.fromJson(i)).toList();
          addressList = rows;
          // 修改默认地址的获取逻辑，避免空值异常
          if (addressList.isNotEmpty) {
            defaultAddress = addressList.firstWhere(
              (element) => element.isDefault == '0',
              orElse: () => addressList.first, // 如果没有默认地址，使用第一个地址
            );
          } else {
            defaultAddress = null; // 如果地址列表为空，设置为 null
          }
          notifyListeners();
        }
      },
    );
  }

  Future<CleaningResult> addCleaningModel(
    CleaningFormModel cleaningFormModel,
  ) async {
    Loading.showLoading();
    final Completer<CleaningResult> completer = Completer<CleaningResult>();
    DataUtils.submitCleaningOrder(
      cleaningFormModel.toJson(),
      success: (data) {
        Loading.dismissAll();
        completer.complete(CleaningResult(success: true));
      },
      fail: (code, msg) {
        Loading.dismissAll();
        completer.complete(CleaningResult(success: false, errorMessage: msg));
      },
    );
    return completer.future;
  }

  // 获取保洁订单列表
  Future<void> getCleaningOrderList(isRefresh) async {
    final completer = Completer<void>();
    Loading.showLoading();
    if (isRefresh) {
      pageNum = 1;
      cleaningOrderList = [];
      isLoadMore = false;
    } else {
      if (isLoadMore) {
        pageNum++;
      }
    }

    DataUtils.getCleaningOrderList(
      {
        'pageNum': pageNum,
        'pageSize': pageSize,
        'orderStatus': selectedStatus == '-1' ? null : selectedStatus,
      },
      success: (data) {
        var cleaningOrderList = data['rows'] as List;
        List<CleaningViewModel> rows =
            cleaningOrderList
                .map((i) => CleaningViewModel.fromJson(i))
                .toList();
        if (rows.isNotEmpty) {
          if (isRefresh) {
            this.cleaningOrderList = rows;
          } else {
            this.cleaningOrderList.addAll(rows);
          }
        }
        total = data['total'];
        if (this.cleaningOrderList.length >= total) {
          isLoadMore = true;
        }
        notifyListeners();
        Loading.dismissAll();
        completer.complete();
      },
      fail: (code, msg) {
        Loading.dismissAll();
        ProgressHUD.showError(msg);
        completer.complete();
      },
    );
    return completer.future;
  }

  // 获取保洁类型列表
  Future getCleaningTypeList() async {
    DataUtils.getCleaningTypeList(
      {'pageNum': 1, 'pageSize': 10000, 'status': 0},
      success: (data) {
        var cleaningTypeList = data['rows'] as List;
        List<CleaningTypeModel> rows =
            cleaningTypeList.map((i) => CleaningTypeModel.fromJson(i)).toList();
        this.cleaningTypeList = rows;
        notifyListeners();
      },
      fail: (code, msg) {
        ProgressHUD.showError(msg);
      },
    );
  }

  // 获取订单状态
  Future<void> getOrderStatus() async {
    DataUtils.getDictDataList(
      'clean_order_status',
      success: (data) {
        final result =
            BaseListModel<DictModel>.fromJson(
              data,
              (json) => DictModel.fromJson(json),
            ).data ??
            [];
        this.statusList = result;
        this.statusList.insert(0, DictModel(dictLabel: '全部', dictValue: '-1'));
        notifyListeners();
      },
    );
  }

  // 订单评价
  Future<bool> evaluateCleaningOrder(id, score, evaluate) async {
    final completer = Completer<bool>();
    Loading.showLoading();
    DataUtils.evaluateCleaningOrder(
      {'id': id, 'score': score, 'evaluate': evaluate, 'orderStatus': 3},
      success: (data) {
        Loading.dismissAll();
        completer.complete(true);
      },
      fail: (code, msg) {
        Loading.dismissAll();
        ProgressHUD.showError(msg);
        completer.complete(false);
      },
    );
    return completer.future;
  }
}

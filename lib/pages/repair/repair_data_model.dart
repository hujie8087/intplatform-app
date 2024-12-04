import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/repair_utils.dart';
import 'package:logistics_app/http/model/my_address_view_model.dart';
import 'package:logistics_app/http/model/repair_form_model.dart';
import 'package:logistics_app/http/model/repair_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';

class RepairResult {
  final bool success;
  final String? errorMessage;

  RepairResult({required this.success, this.errorMessage});
}

class RepairDataModel with ChangeNotifier {
  List list = [];
  RepairFormModel? repairFormModel;
  List<AddressModel> addressList = [];
  AddressModel? defaultAddress;
  RepairViewModel? repairViewData;
  bool isShowButton = false;

// 获取我的地址列表
  Future getMyAddressList(pageNum, pageSize) async {
    var params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    DataUtils.getPageList(APIs.getMyAddressList, params, success: (data) {
      RowsModel rowsModel =
          RowsModel.fromJson(data, (json) => MyAddressViewModel.fromJson(json));
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
    });
  }

  Future<RepairResult> addRepairModel() async {
    Loading.showLoading();
    final Completer<RepairResult> completer = Completer<RepairResult>();
    RepairUtils.repairPost(repairFormModel, success: (data) {
      Loading.dismissAll();
      completer.complete(RepairResult(success: true));
    }, fail: (code, msg) {
      Loading.dismissAll();
      completer.complete(RepairResult(success: false, errorMessage: msg));
    });
    return completer.future;
  }

  Future getRepairDetail(id) async {
    Loading.showLoading();
    RepairUtils.getRepairDetail(
      id,
      success: (data) async {
        repairViewData = await RepairViewModel.fromJson(data['data']);
        if (repairViewData?.readStatus == '1') {
          RepairUtils.editRepairDetail({
            'id': repairViewData?.id,
            'readStatus': 0,
            'repairRoomId': repairViewData?.repairRoomId,
          });
        }
        isShowButton = repairViewData?.repairState == 1;
        notifyListeners();
        Loading.dismissAll();
      },
      fail: (code, msg) {
        Loading.dismissAll();
      },
    );
  }
}

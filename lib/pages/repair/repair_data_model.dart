import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/http/data/repair_utils.dart';
import 'package:logistics_app/http/model/base_model.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/repair_form_model.dart';
import 'package:logistics_app/http/model/repair_view_model.dart';

class RepairDataModel with ChangeNotifier {
  List list = [];
  RepairFormModel? repairFormModel;
  RepairViewModel? repairViewData;
  final Completer<bool> completer = Completer<bool>();

  Future getBuildingTreeModel() async {
    DataUtils.getBuildingTree(success: (data) {
      BaseModel rowsModel = BaseModel.fromJson(data);
      if (rowsModel.data != null) {
        list = rowsModel.data;
      }
      notifyListeners();
    });
  }

  Future addRepairModel() async {
    Loading.showLoading();
    RepairUtils.repairPost(repairFormModel, success: (data) {
      Loading.dismissAll();
      completer.complete(true);
    }, fail: (code, msg) {
      Loading.dismissAll();
      completer.complete(false);
    });
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
        notifyListeners();
        Loading.dismissAll();
      },
      fail: (code, msg) {
        Loading.dismissAll();
      },
    );
  }
}

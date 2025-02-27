import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/my_address_view_model.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';

class MessageViewModel with ChangeNotifier {
  List<NoticeModel?>? list = [];
  List buildingList = [];
// 获取我的地址列表
  Future geNoticeList(pageNum, pageSize) async {
    var params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'noticeType': 1,
    };
    DataUtils.getPageList('/system/notice/list', params, success: (data) {
      RowsModel rowsModel =
          RowsModel.fromJson(data, (json) => MyAddressViewModel.fromJson(json));
      if (rowsModel.rows != null) {
        var myAddressList = data['rows'] as List;
        List<NoticeModel> rows =
            myAddressList.map((i) => NoticeModel.fromJson(i)).toList();
        list = rows;
      }
      notifyListeners();
    });
  }
}

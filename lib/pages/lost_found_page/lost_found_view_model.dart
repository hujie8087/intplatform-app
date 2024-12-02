import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/rows_model.dart';

import '../../http/model/notice_list_model.dart';

class LostFoundViewModel with ChangeNotifier {
  List<NoticeModel?>? list = [];
  int pageNum = 1;
  int pageSize = 2;
  // 数据加载完成
  bool isLoadComplete = false;

  Future getLostFoundModelList(bool isRefresh) async {
    if (isRefresh) {
      list = null;
      pageNum = 1;
    } else {
      pageNum++;
    }
    var params = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    Loading.showLoading();
    DataUtils.getPageList('/system/notice/list', params, success: (data) {
      RowsModel rowsModel =
          RowsModel.fromJson(data, (json) => NoticeModel.fromJson(json));
      if (rowsModel.rows != null) {
        var noticeList = data['rows'] as List;
        List<NoticeModel> rows =
            noticeList.map((i) => NoticeModel.fromJson(i)).toList();
        if (list == null) {
          list = rows;
        } else {
          list?.addAll(rows);
        }
        if (rowsModel.total == list?.length) {
          isLoadComplete = true;
        }
      }
      notifyListeners();
      Loading.dismissAll();
    }, fail: (code, msg) {
      Loading.dismissAll();
    });
    Loading.dismissAll();
  }
}

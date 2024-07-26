import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/rows_model.dart';

import '../../http/model/notice_list_model.dart';

class NewsViewModel with ChangeNotifier {
  List<NoticeModel?>? list = [];

  Future getNewsModelList(pageNum, pageSize) async {
    var params = {
      'page': pageNum,
      'limit': pageSize,
    };
    Loading.showLoading();
    DataUtils.getPageList('/system/notice/list', params, success: (data) {
      RowsModel rowsModel =
          RowsModel.fromJson(data, (json) => NoticeModel.fromJson(json));
      if (rowsModel.rows != null) {
        var noticeList = data['rows'] as List;
        List<NoticeModel> rows =
            noticeList.map((i) => NoticeModel.fromJson(i)).toList();
        list = rows;
      }
      notifyListeners();
      Loading.dismissAll();
    }, fail: (code, msg) {
      Loading.dismissAll();
    });
    Loading.dismissAll();
  }
}

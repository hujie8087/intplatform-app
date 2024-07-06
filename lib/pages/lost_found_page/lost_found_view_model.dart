import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/loading.dart';
import 'package:logistics_app/repository/api/wan_api.dart';

import '../../repository/model/notice_list_model.dart';

class LostFoundViewModel with ChangeNotifier {
  List<NoticeModel?>? list = [];

  Future getLostFoundModelList() async {
    Loading.showLoading();
    var resp = await WanApi.instance().noticeList();
    if (resp?.isNotEmpty == true) {
      list = resp;
      notifyListeners();
    }
    Loading.dismissAll();
  }
}

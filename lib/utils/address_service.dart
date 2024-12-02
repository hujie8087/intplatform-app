import 'dart:async';
import 'dart:convert';

import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/address_view_model.dart';
import 'package:logistics_app/http/model/base_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class AddressService {
  Future<List> getAddressData() async {
    List cachedData = [];

    String? jsonString = await SpUtils.getString('address');

    // 如果有缓存数据，直接返回
    if (jsonString != null && jsonDecode(jsonString).length > 0) {
      List<dynamic> decodedJson = jsonDecode(jsonString);
      cachedData =
          decodedJson.map((item) => AddressData.fromJson(item)).toList();
      return cachedData;
    }

    // 没有缓存数据，则请求网络数据
    List addressData = await fetchAddressDataFromApi();
    print('addressData${addressData}');
    // 保存数据到本地缓存
    await SpUtils.saveString('address', jsonEncode(addressData));

    return addressData;
  }

  // Future<List<String>> fetchAddressDataFromApi(String level) async {
  //   // 模拟网络请求
  //   await Future.delayed(Duration(seconds: 1));
  //   return ["Data1", "Data2", "Data3"];
  // }
  Future<List> fetchAddressDataFromApi() async {
    var userInfo = await SpUtils.getModel('userInfo');
    List list = [];

    if (userInfo != null) {
      // 使用 Completer 来控制异步返回
      Completer<List> completer = Completer();

      DataUtils.getBuildingTree(success: (data) {
        BaseModel rowsModel = BaseModel.fromJson(data);
        if (rowsModel.data != null) {
          list = rowsModel.data ?? [];
        }
        // 请求完成后通过 completer 返回数据
        completer.complete(list);
      });

      // 等待 completer 返回结果
      return completer.future;
    } else {
      // 如果 userInfo 为空，直接返回空列表
      return list;
    }
  }
}

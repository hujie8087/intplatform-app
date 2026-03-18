import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/meal_delivery_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class MealDeliveryModel with ChangeNotifier {
  List<MealDeliveryPersonModel> people = [];
  List<MealDeliverySiteModel> deliverySites = [];
  // 筛选过后的人员
  List<MealDeliveryPersonModel> filteredPeople = [];
  // 选中的人员
  List<MealDeliveryPersonModel> selectedPeople = [];
  // 可点餐的时间
  List<MealDeliveryTimeListModel> canOrderTimeList = [];
  UserInfoModel userInfo = UserInfoModel();
  List<DictModel> foodTypeList = [];
  // 是否可以点餐
  bool isCanOrder = false;
  // 是否绑定帐号
  bool isBindAccount = false;
  // 是否司机
  bool isDriver = false;
  // 是否斋月
  bool isRamadan = false;

  // 获取用餐人员列表
  Future<List<MealDeliveryPersonModel>> getMealPersonList(parameters) async {
    final completer = Completer<List<MealDeliveryPersonModel>>();
    ProgressHUD.showLoadingText(S.current.deliveryGetPersonList, 100000);
    MealDeliveryUtils.getMealPersonList(
      parameters,
      success: (data) {
        people =
            RowsModel<MealDeliveryPersonModel>.fromJson(
              data,
              (json) => MealDeliveryPersonModel.fromJson(json),
            ).rows ??
            [];
        filteredPeople = people;
        completer.complete(people);
        ProgressHUD.hide();
      },
      fail: (code, msg) {
        ProgressHUD.showError(S.current.deliveryGetPersonListFail);
        ProgressHUD.hide();
      },
    );
    return completer.future;
  }

  //获取用餐地点
  Future<void> getMealPlace(parameters) async {
    ProgressHUD.showLoadingText(S.current.deliveryGetMealPlace);
    deliverySites = [];
    MealDeliveryUtils.getMealPlace(
      parameters,
      success: (data) {
        deliverySites =
            RowsModel<MealDeliverySiteModel>.fromJson(
              data,
              (json) => MealDeliverySiteModel.fromJson(json),
            ).rows ??
            [];
        ProgressHUD.hide();
      },
      fail: (code, msg) {
        ProgressHUD.showError(S.current.deliveryGetMealPlaceFail);
        ProgressHUD.hide();
      },
    );
  }

  packageOrder(BuildContext context, int id, int fcId, String fcName) async {
    //打包
    MealDeliveryUtils.updateOrderMealStatus(
      {'oId': id, 'orderStatus': 2, 'fcId': fcId, 'fcName': fcName},
      success: (res) {
        if (res['code'] == 200 && res['msg'] == '操作成功') {
          ProgressHUD.showSuccess(res['msg']);
          Navigator.pop(context);
        } else {
          ProgressHUD.showError('打包失败');
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(S.current.deliveryPackOrderFail);
      },
    );
  }

  deliverOrder(context, id) async {
    // 司机的操作逻辑
    MealDeliveryUtils.updateOrderMealStatus(
      {'oId': id, 'orderStatus': 3},
      success: (res) {
        if (res['code'] == 200 && res['msg'] == '操作成功') {
          ProgressHUD.showSuccess(S.current.deliveryDeliverOrder);
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(S.current.deliveryDeliverOrderFail);
      },
    );
  }

  teamSubmitOrder(context, id) async {
    // 班组的操作逻辑
    MealDeliveryUtils.submitOrderMeal(
      id,
      success: (res) {
        if (res['code'] == 200 && res['msg'] == '操作成功') {
          ProgressHUD.showSuccess(S.current.deliverySubmitOrderSuccess);
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(S.current.deliverySubmitOrderFail);
      },
    );
  }

  deptSubmitOrder(context, id) async {
    // 部门的操作逻辑
    MealDeliveryUtils.submitOrderMealByDept(
      id,
      success: (res) {
        if (res['code'] == 200 && res['msg'] == '操作成功') {
          ProgressHUD.showSuccess(S.current.deliverySubmitOrderSuccess);
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError(S.current.deliverySubmitOrderFail);
      },
    );
  }

  // 提交订单
  Future<bool> submitOrder(parameters) async {
    final completer = Completer<bool>();
    MealDeliveryUtils.createOrderMeal(
      parameters,
      success: (res) {
        if (res['code'] == 200 && res['msg'] == '操作成功') {
          ProgressHUD.showSuccess(S.current.deliverySubmitOrderSuccess);
          completer.complete(true);
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError('${msg},${code}');
        completer.complete(false);
      },
    );
    return completer.future;
  }

  // 增加人员
  void addSelectedPeople(List<MealDeliveryPersonModel> people) {
    selectedPeople.addAll(people);
    notifyListeners();
  }

  // 删除人员
  void removeSelectedPeople(List<MealDeliveryPersonModel> people) {
    selectedPeople.removeWhere(
      (person) => people.any((p) => p.id == person.id),
    );
    notifyListeners();
  }

  // 搜索部门
  void searchDept(String value) {
    filteredPeople =
        people
            .where(
              (person) =>
                  person.deptPath?.toLowerCase().contains(
                    value.toLowerCase(),
                  ) ??
                  false,
            )
            .toList();
    notifyListeners();
  }

  // 搜索人员
  void searchPerson(String value) {
    filteredPeople =
        people
            .where(
              (person) =>
                  person.username?.toLowerCase().contains(
                    value.toLowerCase(),
                  ) ??
                  false,
            )
            .toList();
    notifyListeners();
  }

  Future<void> onFetchUserInfo() async {
    var userInfoData = await SpUtils.getModel('userInfo');
    UserInfoModel userInfo = UserInfoModel();
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
    }
    this.userInfo = userInfo;
    if (userInfo.mealUser != null) {
      isBindAccount = true;
      if ((userInfo.mealUser?.roles?.contains('leader') ?? false) ||
          (userInfo.mealUser?.roles?.contains('common') ?? false)) {
        isCanOrder = true;
        await getIsRamadan();
        await getCanOrderTimeList();
        await getFoodType();
      }
      if (userInfo.mealUser?.roles?.isNotEmpty ?? false) {
        isDriver =
            userInfo.mealUser?.roles?.any((role) => role.contains("driver")) ??
            false;
      }
    }
    notifyListeners();
  }

  // 获取餐饮名称数据字典
  Future<void> getFoodType() async {
    DataUtils.getDictDataList(
      'food_type',
      success: (data) {
        final result =
            BaseListModel<DictModel>.fromJson(
              data,
              (json) => DictModel.fromJson(json),
            ).data ??
            [];
        if (!isRamadan) {
          // 斋月不显示5和6
          this.foodTypeList =
              result
                  .where(
                    (element) => !['4', '5', '6'].contains(element.dictValue),
                  )
                  .toList();
        } else {
          this.foodTypeList =
              result
                  .where((element) => !['4'].contains(element.dictValue))
                  .toList();
          ;
        }
        notifyListeners();
      },
    );
  }

  //获取可点餐的时间
  Future<void> getCanOrderTimeList() async {
    final completer = Completer<void>();
    MealDeliveryUtils.getCanOrderTimeList(
      success: (data) {
        canOrderTimeList =
            RowsModel<MealDeliveryTimeListModel>.fromJson(
              data,
              (json) => MealDeliveryTimeListModel.fromJson(json),
            ).rows ??
            [];
        completer.complete();
        notifyListeners();
      },
      fail: (code, msg) {
        ProgressHUD.showError('${msg},${code}');
        completer.complete();
      },
    );
    return completer.future;
  }

  // 校验可点餐的时间
  Future<bool> checkCanOrderTime(oId) async {
    final completer = Completer<bool>();
    MealDeliveryUtils.getCanOrderTime(
      oId,
      success: (data) {
        if (data['code'] == 200 && data['msg'] == '操作成功') {
          completer.complete(true);
        } else {
          completer.complete(false);
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError('${msg},${code}');
        completer.complete(false);
      },
    );
    return completer.future;
  }

  // 获取是否斋月
  Future<void> getIsRamadan() async {
    final completer = Completer<void>();
    MealDeliveryUtils.getIsRamadan(
      success: (data) {
        if (data['code'] == 200 && data['msg'] == '操作成功') {
          isRamadan = data['data']['ramadan'];
          completer.complete();
        } else {
          completer.complete();
        }
      },
      fail: (code, msg) {
        ProgressHUD.showError('${msg},${code}');
        completer.complete();
      },
    );
    return completer.future;
  }
}

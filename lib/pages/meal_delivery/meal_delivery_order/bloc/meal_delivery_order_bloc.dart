import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/bloc/meal_delivery_order_event.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/bloc/meal_delivery_order_state.dart';
import 'package:logistics_app/repositories/meal_delivery_order_repository.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class MealDeliveryOrderBloc
    extends Bloc<MealDeliveryOrderEvent, MealDeliveryOrderState> {
  final MealDeliveryOrderRepository repository;
  int page = 1;
  UserInfoModel userInfo = UserInfoModel();
  String keyword; // 改为可变
  DateTime? start;
  DateTime? end;
  List<String>? foodArrays;
  List<String>? strArrays;
  List<String>? statusArrays;
  List<String>? orderStatus;
  List<String>? packageType;
  bool isBindAccount = false;

  List<MealDeliveryOrderModel> orders = [];
  MealDeliveryOrderModel? orderDetail;

  MealDeliveryOrderBloc({
    required this.repository,
    required this.userInfo,
    required this.keyword,
  }) : super(MealDeliveryOrderInitial()) {
    on<FetchMealDeliveryOrder>(_onFetchMealDeliveryOrder);
    on<FetchMealDeliveryOrderDetail>(_onFetchMealDeliveryOrderDetail);
    on<FetchUserInfo>(_onFetchUserInfo);
  }

  void _onFetchMealDeliveryOrder(
    FetchMealDeliveryOrder event,
    Emitter<MealDeliveryOrderState> emit,
  ) async {
    // 如果是刷新，显示加载状态；如果是加载更多，保持当前状态
    if (event.isRefresh) {
      emit(MealDeliveryOrderLoading());
      page = 1;
      orders.clear();
      start = event.start;
      end = event.end;
      // 更新搜索关键词
      keyword = event.keyword;
      foodArrays = event.foodArrays;
      strArrays = event.strArrays;
      statusArrays = event.statusArrays;
      orderStatus = event.orderStatus;
      packageType = event.packageType;
    }

    try {
      final newOrders = await repository.fetchMealDeliveryOrders(
        page,
        10,
        keyword,
        event.start,
        event.end,
        event.foodArrays,
        event.strArrays,
        event.statusArrays,
        event.orderStatus,
        event.packageType,
      );

      if (event.isRefresh) {
        orders = newOrders;
      } else {
        orders.addAll(newOrders);
      }

      final hasMore = orders.length < repository.total;
      if (hasMore) page += 1;

      emit(
        MealDeliveryOrderLoaded(
          orders: List.from(orders),
          hasMore: hasMore,
          userInfo: userInfo,
        ),
      );
    } catch (e) {
      // 错误时保持现有数据
      if (orders.isNotEmpty) {
        emit(
          MealDeliveryOrderLoaded(
            orders: List.from(orders),
            hasMore: true,
            userInfo: userInfo,
          ),
        );
      } else {}
    }
  }

  Future<void> _onFetchUserInfo(
    FetchUserInfo event,
    Emitter<MealDeliveryOrderState> emit,
  ) async {
    var userInfoData = await SpUtils.getModel('userInfo');
    if (userInfoData != null) {
      userInfo = UserInfoModel.fromJson(userInfoData);
      print(userInfo.mealUser?.userId);
      if (userInfo.mealUser?.userId == null) {
        isBindAccount = false;
        emit(MealDeliveryOrderError('请先绑定帐号'));
      } else {
        isBindAccount = true;
        add(FetchMealDeliveryOrder(isRefresh: true));
      }
    }
  }

  void _onFetchMealDeliveryOrderDetail(
    FetchMealDeliveryOrderDetail event,
    Emitter<MealDeliveryOrderState> emit,
  ) async {
    final orderDetail = await repository.fetchMealDeliveryOrderDetail(
      event.orderId,
    );
    print(orderDetail);
    emit(MealDeliveryOrderDetailLoaded(orderDetail: orderDetail));
  }
}

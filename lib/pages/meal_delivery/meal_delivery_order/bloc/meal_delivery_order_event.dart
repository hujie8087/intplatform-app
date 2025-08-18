abstract class MealDeliveryOrderEvent {}

class FetchMealDeliveryOrder extends MealDeliveryOrderEvent {
  final bool isRefresh;
  final String keyword;
  final DateTime? start;
  final DateTime? end;
  final List<String>? foodArrays;
  final List<String>? strArrays;
  final List<String>? statusArrays;
  final List<String>? orderStatus;
  final List<String>? packageType;
  FetchMealDeliveryOrder({
    this.isRefresh = false,
    this.keyword = '',
    this.start,
    this.end,
    this.foodArrays,
    this.strArrays,
    this.statusArrays,
    this.orderStatus,
    this.packageType,
  });
}

class RefreshMealDeliveryOrder extends MealDeliveryOrderEvent {
  RefreshMealDeliveryOrder();
}

class FetchUserInfo extends MealDeliveryOrderEvent {
  FetchUserInfo();
}

class FetchMealDeliveryOrderDetail extends MealDeliveryOrderEvent {
  final String orderId;
  FetchMealDeliveryOrderDetail({required this.orderId});
}

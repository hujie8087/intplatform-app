import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:equatable/equatable.dart';
import 'package:logistics_app/http/model/user_info_model.dart';

abstract class MealDeliveryOrderState extends Equatable {
  @override
  List<Object> get props => [];
}

class MealDeliveryOrderInitial extends MealDeliveryOrderState {}

class MealDeliveryOrderLoading extends MealDeliveryOrderState {}

class MealDeliveryOrderLoaded extends MealDeliveryOrderState {
  final List<MealDeliveryOrderModel> orders;
  final bool hasMore;
  final UserInfoModel userInfo;
  MealDeliveryOrderLoaded({
    required this.orders,
    required this.hasMore,
    required this.userInfo,
  });

  @override
  List<Object> get props => [orders, hasMore, userInfo];
}

class MealDeliveryOrderError extends MealDeliveryOrderState {
  final String message;

  MealDeliveryOrderError(this.message);
  @override
  List<Object> get props => [message];
}

class MealDeliveryOrderDetailLoaded extends MealDeliveryOrderState {
  final MealDeliveryOrderModel orderDetail;
  MealDeliveryOrderDetailLoaded({required this.orderDetail});
  @override
  List<Object> get props => [orderDetail];
}

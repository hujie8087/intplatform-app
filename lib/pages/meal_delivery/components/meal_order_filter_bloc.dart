import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logistics_app/generated/l10n.dart';

// Events
abstract class MealOrderFilterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectCategory extends MealOrderFilterEvent {
  final int index;
  SelectCategory(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleFoodOption extends MealOrderFilterEvent {
  final int index;
  ToggleFoodOption(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleSourceTypeOption extends MealOrderFilterEvent {
  final int index;
  ToggleSourceTypeOption(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleCenterStatusOption extends MealOrderFilterEvent {
  final int index;
  ToggleCenterStatusOption(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleOrderStatusOption extends MealOrderFilterEvent {
  final int index;
  ToggleOrderStatusOption(this.index);

  @override
  List<Object?> get props => [index];
}

class TogglePackageTypeOption extends MealOrderFilterEvent {
  final int index;
  TogglePackageTypeOption(this.index);

  @override
  List<Object?> get props => [index];
}

class ResetFilter extends MealOrderFilterEvent {}

class RemoveSelectedTag extends MealOrderFilterEvent {
  final String type;
  final int index;
  RemoveSelectedTag(this.type, this.index);

  @override
  List<Object?> get props => [type, index];
}

// States
abstract class MealOrderFilterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MealOrderFilterInitial extends MealOrderFilterState {}

class MealOrderFilterLoaded extends MealOrderFilterState {
  final int selectedIndex;
  final List<Map<String, dynamic>> categoryList;
  final List<Map<String, dynamic>> foodNameOptions;
  final List<Map<String, dynamic>> sourceTypeOptions;
  final List<Map<String, dynamic>> centerStatusOptions;
  final List<Map<String, dynamic>> orderStatusOptions;
  // 打包方式
  final List<Map<String, dynamic>> packageTypeOptions;

  MealOrderFilterLoaded({
    required this.selectedIndex,
    required this.categoryList,
    required this.foodNameOptions,
    required this.sourceTypeOptions,
    required this.centerStatusOptions,
    required this.orderStatusOptions,
    required this.packageTypeOptions,
  });

  MealOrderFilterLoaded copyWith({
    int? selectedIndex,
    List<Map<String, dynamic>>? categoryList,
    List<Map<String, dynamic>>? foodNameOptions,
    List<Map<String, dynamic>>? sourceTypeOptions,
    List<Map<String, dynamic>>? centerStatusOptions,
    List<Map<String, dynamic>>? orderStatusOptions,
    List<Map<String, dynamic>>? packageTypeOptions,
  }) {
    return MealOrderFilterLoaded(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      categoryList: categoryList ?? this.categoryList,
      foodNameOptions: foodNameOptions ?? this.foodNameOptions,
      sourceTypeOptions: sourceTypeOptions ?? this.sourceTypeOptions,
      centerStatusOptions: centerStatusOptions ?? this.centerStatusOptions,
      orderStatusOptions: orderStatusOptions ?? this.orderStatusOptions,
      packageTypeOptions: packageTypeOptions ?? this.packageTypeOptions,
    );
  }

  // 获取筛选结果
  Map<String, List<String>> getFilterResult() {
    return {
      'foodArrays':
          foodNameOptions
              .where((item) => item['isSelected'])
              .map((item) => item['foodName'].toString())
              .toList(),
      'strArrays':
          sourceTypeOptions
              .where((item) => item['isSelected'])
              .map((item) => item['sourceType'].toString())
              .toList(),
      'statusArrays':
          centerStatusOptions
              .where((item) => item['isSelected'])
              .map((item) => item['centerStatus'].toString())
              .toList(),
      'orderStatus':
          orderStatusOptions
              .where((item) => item['isSelected'])
              .map((item) => item['orderStatus'].toString())
              .toList(),
      'packageType':
          packageTypeOptions
              .where((item) => item['isSelected'])
              .map((item) => item['packageType'].toString())
              .toList(),
    };
  }

  // 获取当前分类的选项列表
  List<Map<String, dynamic>> getCurrentCategoryOptions() {
    switch (selectedIndex) {
      case 0:
        return foodNameOptions;
      case 1:
        return sourceTypeOptions;
      case 2:
        return centerStatusOptions;
      case 3:
        return orderStatusOptions;
      case 4:
        return packageTypeOptions;
      default:
        return [];
    }
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    categoryList,
    foodNameOptions,
    sourceTypeOptions,
    centerStatusOptions,
    orderStatusOptions,
    packageTypeOptions,
  ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealOrderFilterLoaded &&
        other.selectedIndex == selectedIndex &&
        other.categoryList == categoryList &&
        other.foodNameOptions == foodNameOptions &&
        other.sourceTypeOptions == sourceTypeOptions &&
        other.centerStatusOptions == centerStatusOptions &&
        other.orderStatusOptions == orderStatusOptions &&
        other.packageTypeOptions == packageTypeOptions;
  }

  @override
  int get hashCode {
    return selectedIndex.hashCode ^
        categoryList.hashCode ^
        foodNameOptions.hashCode ^
        sourceTypeOptions.hashCode ^
        centerStatusOptions.hashCode ^
        orderStatusOptions.hashCode ^
        packageTypeOptions.hashCode;
  }
}

// BLoC
class MealOrderFilterBloc
    extends Bloc<MealOrderFilterEvent, MealOrderFilterState> {
  MealOrderFilterBloc({Map<String, List<String>>? initialFilters})
    : super(MealOrderFilterInitial()) {
    on<SelectCategory>(_onSelectCategory);
    on<ToggleFoodOption>(_onToggleFoodOption);
    on<ToggleSourceTypeOption>(_onToggleSourceTypeOption);
    on<ToggleCenterStatusOption>(_onToggleCenterStatusOption);
    on<ToggleOrderStatusOption>(_onToggleOrderStatusOption);
    on<ResetFilter>(_onResetFilter);
    on<RemoveSelectedTag>(_onRemoveSelectedTag);
    on<TogglePackageTypeOption>(_onTogglePackageTypeOption);

    // 初始化状态
    _initializeState(initialFilters);
  }

  void _initializeState([Map<String, List<String>>? initialFilters]) {
    final categoryList = [
      {'name': S.current.mealTime, 'index': 0, 'id': 0},
      {'name': S.current.deliveryOrderType, 'index': 1, 'id': 1},
      {'name': S.current.deliverySubmitStatus, 'index': 2, 'id': 2},
      {'name': S.current.deliveryOrderStatus, 'index': 3, 'id': 3},
      {'name': S.current.deliveryPackageType, 'index': 4, 'id': 4},
    ];

    final foodNameOptions = [
      {
        'name': S.current.breakfast,
        'foodName': 0,
        'index': 0,
        'id': 0,
        'isSelected': false,
      },
      {
        'name': S.current.lunch,
        'foodName': 1,
        'index': 1,
        'id': 1,
        'isSelected': false,
      },
      {
        'name': S.current.dinner,
        'foodName': 2,
        'index': 2,
        'id': 2,
        'isSelected': false,
      },
      {
        'name': S.current.nightSnack,
        'foodName': 3,
        'index': 3,
        'id': 3,
        'isSelected': false,
      },
    ];

    final sourceTypeOptions = [
      {
        'name': S.current.normalOrder,
        'sourceType': 0,
        'index': 0,
        'id': 0,
        'isSelected': false,
      },
      {
        'name': S.current.supplementOrder,
        'sourceType': 1,
        'index': 1,
        'id': 1,
        'isSelected': false,
      },
      {
        'name': S.current.reduceOrder,
        'sourceType': 2,
        'index': 2,
        'id': 2,
        'isSelected': false,
      },
    ];

    final centerStatusOptions = [
      {
        'name': S.current.groupNotSubmitted,
        'centerStatus': 0,
        'index': 0,
        'id': 0,
        'isSelected': false,
      },
      {
        'name': S.current.groupSubmitted,
        'centerStatus': 1,
        'index': 1,
        'id': 1,
        'isSelected': false,
      },
      {
        'name': S.current.departmentSubmitted,
        'centerStatus': 2,
        'index': 2,
        'id': 2,
        'isSelected': false,
      },
      {
        'name': S.current.orderCenterConfirmed,
        'centerStatus': 3,
        'index': 3,
        'id': 3,
        'isSelected': false,
      },
    ];

    final orderStatusOptions = [
      {
        'name': S.current.deliveryOrderPlaced,
        'orderStatus': 0,
        'index': 0,
        'id': 0,
        'isSelected': false,
      },
      {
        'name': S.current.deliveryCooking,
        'orderStatus': 1,
        'index': 1,
        'id': 1,
        'isSelected': false,
      },
      {
        'name': S.current.deliveryPacked,
        'orderStatus': 2,
        'index': 2,
        'id': 2,
        'isSelected': false,
      },
      {
        'name': S.current.deliveryDelivering,
        'orderStatus': 3,
        'index': 3,
        'id': 3,
        'isSelected': false,
      },
      {
        'name': S.current.deliveryDelivered,
        'orderStatus': 4,
        'index': 4,
        'id': 4,
        'isSelected': false,
      },
    ];

    final packageTypeOptions = [
      {
        'name': S.current.deliveryPackedMeal,
        'packageType': 0,
        'index': 0,
        'id': 0,
        'isSelected': false,
      },
      {
        'name': S.current.deliveryBoxedMeal,
        'packageType': 1,
        'index': 1,
        'id': 1,
        'isSelected': false,
      },
    ];

    // 应用初始筛选状态
    if (initialFilters != null) {
      // 应用餐次筛选
      if (initialFilters['foodArrays'] != null) {
        for (final foodId in initialFilters['foodArrays']!) {
          final index = int.tryParse(foodId);
          if (index != null && index < foodNameOptions.length) {
            foodNameOptions[index]['isSelected'] = true;
          }
        }
      }

      // 应用订单种类筛选
      if (initialFilters['strArrays'] != null) {
        for (final sourceId in initialFilters['strArrays']!) {
          final index = int.tryParse(sourceId);
          if (index != null && index < sourceTypeOptions.length) {
            sourceTypeOptions[index]['isSelected'] = true;
          }
        }
      }

      // 应用提交状态筛选
      if (initialFilters['statusArrays'] != null) {
        for (final statusId in initialFilters['statusArrays']!) {
          final index = int.tryParse(statusId);
          if (index != null && index < centerStatusOptions.length) {
            centerStatusOptions[index]['isSelected'] = true;
          }
        }
      }

      // 应用订单状态筛选
      if (initialFilters['orderStatus'] != null) {
        for (final orderId in initialFilters['orderStatus']!) {
          final index = int.tryParse(orderId);
          if (index != null && index < orderStatusOptions.length) {
            orderStatusOptions[index]['isSelected'] = true;
          }
        }
      }
      // 应用打包方式筛选
      if (initialFilters['packageType'] != null) {
        for (final packageId in initialFilters['packageType']!) {
          final index = int.tryParse(packageId);
          if (index != null && index < packageTypeOptions.length) {
            packageTypeOptions[index]['isSelected'] = true;
          }
        }
      }
    }

    emit(
      MealOrderFilterLoaded(
        selectedIndex: 0,
        categoryList: categoryList,
        foodNameOptions: foodNameOptions,
        sourceTypeOptions: sourceTypeOptions,
        centerStatusOptions: centerStatusOptions,
        orderStatusOptions: orderStatusOptions,
        packageTypeOptions: packageTypeOptions,
      ),
    );
  }

  void _onSelectCategory(
    SelectCategory event,
    Emitter<MealOrderFilterState> emit,
  ) {
    print('SelectCategory event: ${event.index}');
    if (state is MealOrderFilterLoaded) {
      final currentState = state as MealOrderFilterLoaded;
      print('Current selectedIndex: ${currentState.selectedIndex}');
      emit(currentState.copyWith(selectedIndex: event.index));
      print('New selectedIndex: ${event.index}');
    }
  }

  void _onToggleFoodOption(
    ToggleFoodOption event,
    Emitter<MealOrderFilterState> emit,
  ) {
    print('ToggleFoodOption event: ${event.index}');
    if (state is MealOrderFilterLoaded) {
      final currentState = state as MealOrderFilterLoaded;
      final updatedOptions = List<Map<String, dynamic>>.from(
        currentState.foodNameOptions,
      );
      final wasSelected = updatedOptions[event.index]['isSelected'];
      updatedOptions[event.index]['isSelected'] = !wasSelected;
      print(
        'Food option ${event.index} changed from $wasSelected to ${updatedOptions[event.index]['isSelected']}',
      );
      emit(currentState.copyWith(foodNameOptions: updatedOptions));
    }
  }

  void _onToggleSourceTypeOption(
    ToggleSourceTypeOption event,
    Emitter<MealOrderFilterState> emit,
  ) {
    if (state is MealOrderFilterLoaded) {
      final currentState = state as MealOrderFilterLoaded;
      final updatedOptions = List<Map<String, dynamic>>.from(
        currentState.sourceTypeOptions,
      );
      final wasSelected = updatedOptions[event.index]['isSelected'];
      updatedOptions[event.index]['isSelected'] = !wasSelected;
      emit(currentState.copyWith(sourceTypeOptions: updatedOptions));
    }
  }

  void _onToggleCenterStatusOption(
    ToggleCenterStatusOption event,
    Emitter<MealOrderFilterState> emit,
  ) {
    if (state is MealOrderFilterLoaded) {
      final currentState = state as MealOrderFilterLoaded;
      final updatedOptions = List<Map<String, dynamic>>.from(
        currentState.centerStatusOptions,
      );
      final wasSelected = updatedOptions[event.index]['isSelected'];
      updatedOptions[event.index]['isSelected'] = !wasSelected;
      emit(currentState.copyWith(centerStatusOptions: updatedOptions));
    }
  }

  void _onToggleOrderStatusOption(
    ToggleOrderStatusOption event,
    Emitter<MealOrderFilterState> emit,
  ) {
    if (state is MealOrderFilterLoaded) {
      final currentState = state as MealOrderFilterLoaded;
      final updatedOptions = List<Map<String, dynamic>>.from(
        currentState.orderStatusOptions,
      );
      final wasSelected = updatedOptions[event.index]['isSelected'];
      updatedOptions[event.index]['isSelected'] = !wasSelected;
      emit(currentState.copyWith(orderStatusOptions: updatedOptions));
    }
  }

  void _onTogglePackageTypeOption(
    TogglePackageTypeOption event,
    Emitter<MealOrderFilterState> emit,
  ) {
    if (state is MealOrderFilterLoaded) {
      final currentState = state as MealOrderFilterLoaded;
      final updatedOptions = List<Map<String, dynamic>>.from(
        currentState.packageTypeOptions,
      );
      final wasSelected = updatedOptions[event.index]['isSelected'];
      updatedOptions[event.index]['isSelected'] = !wasSelected;
      emit(currentState.copyWith(packageTypeOptions: updatedOptions));
    }
  }

  void _onResetFilter(ResetFilter event, Emitter<MealOrderFilterState> emit) {
    // 重置时不应用初始筛选状态
    _initializeState(null);
  }

  void _onRemoveSelectedTag(
    RemoveSelectedTag event,
    Emitter<MealOrderFilterState> emit,
  ) {
    if (state is MealOrderFilterLoaded) {
      final currentState = state as MealOrderFilterLoaded;
      switch (event.type) {
        case 'food':
          final updatedOptions = List<Map<String, dynamic>>.from(
            currentState.foodNameOptions,
          );
          updatedOptions[event.index]['isSelected'] = false;
          print('Removed food tag at index ${event.index}');
          emit(currentState.copyWith(foodNameOptions: updatedOptions));
          break;
        case 'source':
          final updatedOptions = List<Map<String, dynamic>>.from(
            currentState.sourceTypeOptions,
          );
          updatedOptions[event.index]['isSelected'] = false;
          print('Removed source tag at index ${event.index}');
          emit(currentState.copyWith(sourceTypeOptions: updatedOptions));
          break;
        case 'center':
          final updatedOptions = List<Map<String, dynamic>>.from(
            currentState.centerStatusOptions,
          );
          updatedOptions[event.index]['isSelected'] = false;
          print('Removed center tag at index ${event.index}');
          emit(currentState.copyWith(centerStatusOptions: updatedOptions));
          break;
        case 'order':
          final updatedOptions = List<Map<String, dynamic>>.from(
            currentState.orderStatusOptions,
          );
          updatedOptions[event.index]['isSelected'] = false;
          emit(currentState.copyWith(orderStatusOptions: updatedOptions));
          break;
        case 'package':
          final updatedOptions = List<Map<String, dynamic>>.from(
            currentState.packageTypeOptions,
          );
          updatedOptions[event.index]['isSelected'] = false;
          emit(currentState.copyWith(packageTypeOptions: updatedOptions));
      }
    }
  }
}

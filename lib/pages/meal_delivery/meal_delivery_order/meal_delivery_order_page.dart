import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/meal_delivery/components/meal_order_card.dart';
import 'package:logistics_app/pages/meal_delivery/components/meal_order_filter.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/bloc/meal_delivery_order_bloc.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/bloc/meal_delivery_order_event.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/bloc/meal_delivery_order_state.dart';
import 'package:logistics_app/repositories/meal_delivery_order_repository.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MealDeliveryOrderPage extends StatefulWidget {
  const MealDeliveryOrderPage({super.key});

  @override
  State<MealDeliveryOrderPage> createState() => _MealDeliveryOrderPageState();
}

class _MealDeliveryOrderPageState extends State<MealDeliveryOrderPage> {
  TextEditingController searchController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  String languageCode = 'zh';

  // 添加筛选状态管理
  Map<String, List<String>>? currentFilters;

  @override
  void initState() {
    super.initState();
    // 监听搜索控制器变化
    searchController.addListener(() {
      setState(() {}); // 触发重建以更新清除按钮显示
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              MealDeliveryOrderBloc(
                  repository: MealDeliveryOrderRepository(),
                  userInfo: UserInfoModel(),
                  keyword: '',
                )
                ..add(FetchMealDeliveryOrder(isRefresh: true))
                ..add(FetchUserInfo()),
      child: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: Text(
                  S.of(context).deliveryOrderList,
                  style: TextStyle(fontSize: 16.px),
                ),
                actions: [
                  // 选择日期范围
                  IconButton(
                    onPressed: () async {
                      final bloc = context.read<MealDeliveryOrderBloc>();
                      final result = await showDateRangePicker(
                        context: context,
                        initialDateRange: DateTimeRange(
                          start: startDate ?? DateTime.now(),
                          end: endDate ?? DateTime.now(),
                        ),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (result != null) {
                        setState(() {
                          startDate = result.start;
                          endDate = result.end;
                        });
                      }
                      bloc.add(
                        FetchMealDeliveryOrder(
                          isRefresh: true,
                          keyword: searchController.text,
                          start: startDate,
                          end: endDate,
                        ),
                      );
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                  // 条件筛选
                  IconButton(
                    onPressed: () async {
                      final result =
                          await showModalBottomSheet<Map<String, List<String>>>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return MealOrderFilter(
                                initialFilters: currentFilters,
                              );
                            },
                          );
                      if (result != null) {
                        setState(() {
                          currentFilters = result;
                        });
                        final filterData = result;
                        final bloc = context.read<MealDeliveryOrderBloc>();
                        bloc.add(
                          FetchMealDeliveryOrder(
                            isRefresh: true,
                            keyword: searchController.text,
                            start: startDate,
                            end: endDate,
                            foodArrays: filterData['foodArrays'],
                            strArrays: filterData['strArrays'],
                            statusArrays: filterData['statusArrays'],
                            orderStatus: filterData['orderStatus'],
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.tune),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.px),
                      padding: EdgeInsets.symmetric(horizontal: 10.px),
                      height: 40.px,
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (value) {
                          // 获取当前bloc并发送搜索事件
                          final bloc = context.read<MealDeliveryOrderBloc>();
                          bloc.add(
                            FetchMealDeliveryOrder(
                              isRefresh: true,
                              keyword: value,
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.px,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.px),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.px,
                            ),
                          ),
                          // 部门图标
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.search),
                          hintText: S.of(context).deliverySearchOrder,
                          hintStyle: TextStyle(fontSize: 12.px),
                          // 添加清除按钮
                          suffixIcon:
                              searchController.text.isNotEmpty
                                  ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      searchController.clear();
                                      final bloc =
                                          context.read<MealDeliveryOrderBloc>();
                                      bloc.add(
                                        FetchMealDeliveryOrder(
                                          isRefresh: true,
                                          keyword: '',
                                        ),
                                      );
                                    },
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    // 列表内容
                    Expanded(child: MealDeliveryOrderView()),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class MealDeliveryOrderView extends StatelessWidget {
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MealDeliveryOrderBloc>();
    return BlocBuilder<MealDeliveryOrderBloc, MealDeliveryOrderState>(
      builder: (context, state) {
        // 初始化变量
        List<MealDeliveryOrderModel> orders = [];
        bool hasMore = true;

        // 根据状态处理数据
        if (state is MealDeliveryOrderLoading) {
          // 如果是第一页加载，显示加载指示器
          if (bloc.page == 1) {
            return const Center(child: CircularProgressIndicator());
          }
          // 如果是加载更多，保持现有数据
          if (bloc.orders.isNotEmpty) {
            orders = List.from(bloc.orders);
            hasMore = true; // 加载中时保持hasMore为true
          }
        } else if (state is MealDeliveryOrderLoaded) {
          orders = state.orders;
          hasMore = state.hasMore;

          // 处理加载完成状态
          if (!hasMore) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        } else if (state is MealDeliveryOrderError) {
          // 错误时保持现有数据
          if (bloc.orders.isNotEmpty) {
            orders = List.from(bloc.orders);
            hasMore = true;
          }
          return Center(child: Text(state.message));
        }

        return SmartRefreshWidget(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: hasMore,
          onRefresh: () async {
            // 刷新时保持当前搜索关键词
            final currentKeyword = bloc.keyword;
            bloc.add(
              FetchMealDeliveryOrder(
                isRefresh: true,
                keyword: currentKeyword,
                start: bloc.start,
                end: bloc.end,
                foodArrays: bloc.foodArrays,
                strArrays: bloc.strArrays,
                statusArrays: bloc.statusArrays,
                orderStatus: bloc.orderStatus,
              ),
            );
            await Future.delayed(Duration(milliseconds: 500));
            _refreshController.refreshCompleted();
          },
          onLoading: () async {
            // 加载更多时保持当前搜索关键词
            final currentKeyword = bloc.keyword;
            bloc.add(
              FetchMealDeliveryOrder(
                isRefresh: false,
                keyword: currentKeyword,
                start: bloc.start,
                end: bloc.end,
                foodArrays: bloc.foodArrays,
                strArrays: bloc.strArrays,
                statusArrays: bloc.statusArrays,
                orderStatus: bloc.orderStatus,
              ),
            );
            await Future.delayed(Duration(milliseconds: 500));
            if (!hasMore) {
              debugPrint('没有更多数据$hasMore');
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
          },
          child:
              orders.length > 0
                  ? ListView.builder(
                    padding: EdgeInsets.all(10.px),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5.px),
                        child: MealOrderCard(
                          orderInfo: order,
                          userInfo: bloc.userInfo,
                          // 提交成功后，刷新订单列表
                          onSubmitSuccess: () {
                            bloc.add(
                              FetchMealDeliveryOrder(
                                isRefresh: true,
                                keyword: bloc.keyword,
                              ),
                            );
                          },
                          // 完成订单后，刷新订单列表
                          onCompleteSuccess: () {
                            bloc.add(
                              FetchMealDeliveryOrder(
                                isRefresh: true,
                                keyword: bloc.keyword,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                  : EmptyView(),
        );
      },
    );
  }
}

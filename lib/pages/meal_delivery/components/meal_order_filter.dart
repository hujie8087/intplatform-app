import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/pages/meal_delivery/components/meal_order_filter_bloc.dart';

class MealOrderFilter extends StatelessWidget {
  final Map<String, List<String>>? initialFilters;

  const MealOrderFilter({super.key, this.initialFilters});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealOrderFilterBloc(initialFilters: initialFilters),
      child: BlocListener<MealOrderFilterBloc, MealOrderFilterState>(
        listener: (context, state) {
          if (state is MealOrderFilterLoaded) {}
        },
        child: BlocBuilder<MealOrderFilterBloc, MealOrderFilterState>(
          buildWhen: (previous, current) {
            // 确保状态变化时重建UI
            return true;
          },
          builder: (context, state) {
            if (state is MealOrderFilterLoaded) {
              return _buildFilterContent(context, state);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildFilterContent(
    BuildContext context,
    MealOrderFilterLoaded state,
  ) {
    return Container(
      height: 500.px,
      padding: EdgeInsets.symmetric(vertical: 10.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.px),
          topRight: Radius.circular(15.px),
        ),
      ),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).deliveryCancel,
                      style: TextStyle(fontSize: 14.px, color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<MealOrderFilterBloc>().add(ResetFilter());
                    },
                    child: Text(
                      S.of(context).deliveryReset,
                      style: TextStyle(fontSize: 14.px, color: secondaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, state.getFilterResult());
                    },
                    child: Text(
                      S.of(context).deliveryConfirm,
                      style: TextStyle(fontSize: 14.px, color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1.px, color: Colors.grey),
            // 已选条件
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
              child: Row(
                children: [
                  Text(S.of(context).deliverySelectedConditions),
                  SizedBox(width: 10.px),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...state.foodNameOptions
                              .where((item) => item['isSelected'])
                              .map((item) => _buildTag(context, item, 'food')),
                          ...state.sourceTypeOptions
                              .where((item) => item['isSelected'])
                              .map(
                                (item) => _buildTag(context, item, 'source'),
                              ),
                          ...state.centerStatusOptions
                              .where((item) => item['isSelected'])
                              .map(
                                (item) => _buildTag(context, item, 'center'),
                              ),
                          ...state.orderStatusOptions
                              .where((item) => item['isSelected'])
                              .map((item) => _buildTag(context, item, 'order')),
                          ...state.packageTypeOptions
                              .where((item) => item['isSelected'])
                              .map(
                                (item) => _buildTag(context, item, 'package'),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // 左边分类列表
                  Container(
                    width: 100,
                    color: Colors.grey[200],
                    child: ListView.builder(
                      itemCount: state.categoryList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context.read<MealOrderFilterBloc>().add(
                              SelectCategory(index),
                            );
                          },
                          child: Container(
                            height: 40.px,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 10.px),
                            decoration: BoxDecoration(
                              color:
                                  state.selectedIndex == index
                                      ? Colors.white
                                      : Colors.grey[200],
                            ),
                            child: Text(
                              state.categoryList[index]['name'],
                              style: TextStyle(fontSize: 12.px),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // 右边内容列表
                  Expanded(child: _buildRightItem(context, state)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(
    BuildContext context,
    Map<String, dynamic> item,
    String type,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 5.px),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
          minimumSize: Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: primaryColor.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.px),
          ),
        ),
        onPressed: () {
          final index = item['index'] as int;
          context.read<MealOrderFilterBloc>().add(
            RemoveSelectedTag(type, index),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item['name'],
              style: TextStyle(color: primaryColor, fontSize: 12.px),
            ),
            SizedBox(width: 4.px),
            Icon(Icons.close, size: 14.px, color: primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildRightItem(BuildContext context, MealOrderFilterLoaded state) {
    final itemList = state.getCurrentCategoryOptions();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
      child: Column(
        children:
            itemList.map((item) {
              return Container(
                height: 40.px,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.px),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.px),
                      onTap: () {
                        _toggleOption(
                          context,
                          state.selectedIndex,
                          item['index'],
                        );
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: item['isSelected'],
                            onChanged: (value) {
                              _toggleOption(
                                context,
                                state.selectedIndex,
                                item['index'],
                              );
                            },
                          ),
                          Text(item['name'], style: TextStyle(fontSize: 12.px)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _toggleOption(BuildContext context, int categoryIndex, int optionIndex) {
    switch (categoryIndex) {
      case 0:
        context.read<MealOrderFilterBloc>().add(ToggleFoodOption(optionIndex));
        break;
      case 1:
        context.read<MealOrderFilterBloc>().add(
          ToggleSourceTypeOption(optionIndex),
        );
        break;
      case 2:
        context.read<MealOrderFilterBloc>().add(
          ToggleCenterStatusOption(optionIndex),
        );
        break;
      case 3:
        context.read<MealOrderFilterBloc>().add(
          ToggleOrderStatusOption(optionIndex),
        );
        break;
      case 4:
        context.read<MealOrderFilterBloc>().add(
          TogglePackageTypeOption(optionIndex),
        );
        break;
    }
  }
}

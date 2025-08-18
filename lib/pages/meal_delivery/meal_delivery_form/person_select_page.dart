import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/meal_delivery_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';

class PersonSelectPage extends StatefulWidget {
  final bool? isEdit;
  final int? oId;
  final Map? order;
  final bool? isAdd;
  final bool isTeam;
  final List<MealDeliveryPersonModel> people;
  final List<MealDeliveryPersonModel> selectedPeople;
  const PersonSelectPage({
    Key? key,
    this.isEdit,
    this.oId,
    this.order,
    this.isAdd,
    this.isTeam = false,
    this.people = const [],
    this.selectedPeople = const [],
  }) : super(key: key);

  @override
  _PersonSelectionPageState createState() => _PersonSelectionPageState();
}

class _PersonSelectionPageState extends State<PersonSelectPage> {
  List<MealDeliveryPersonModel> selectedPeople = [];
  late TextEditingController searchController = TextEditingController();
  late TextEditingController searchDeptController = TextEditingController();
  MealDeliveryModel mealDeliveryModel = MealDeliveryModel();
  bool allSelected = true;

  Map<String, bool> searchSelections = {}; // 添加搜索状态映射

  @override
  void initState() {
    super.initState();
    mealDeliveryModel.filteredPeople = widget.people;
    mealDeliveryModel.people = widget.people;
    // 过滤已选人员
    selectedPeople = widget.selectedPeople;
    mealDeliveryModel.selectedPeople = selectedPeople;
  }

  Future<void> handleTeamEdit(List<Map> selectedPeopleMaps) async {
    // final orderMealProvider = Provider.of<OrderMealInfo>(
    //   context,
    //   listen: false,
    // );
    // 处理编辑状态的逻辑
    // 发送更新请求
    // await updateMealOrder(widget.oId, selectedPeople);
    // final orderInfo = {
    //   "oId": widget.order!['oId'],
    //   "deliverySite": widget.order!['deliverySite'],
    //   "foodOrdersDetil": selectedPeopleMaps,
    //   "pNum": selectedPeopleMaps.length,
    // };
    // final res = await updateOrderMealByTeam(orderInfo);
    // if (res['code'] == 200 && res['msg'] == '操作成功') {
    //   showToast(context, '更新成功');
    //   // 返回上一级
    //   orderMealProvider.clearOrderMealInfo();
    //   Navigator.pushNamedAndRemoveUntil(
    //     context,
    //     '/tab',
    //     arguments: 1,
    //     (Route<dynamic> route) => false,
    //   );
    // } else {
    //   showToast(context, '更新失败');
    // }
  }

  Future<void> handleEdit(List<Map> selectedPeopleMaps) async {
    Navigator.pop(context);
  }

  Future<void> handleAdd(List<Map> selectedPeopleMaps) async {
    // 处理添加人员信息的逻辑
    // 例如：发送添加请求
    // await addMealOrder(selectedPeople);
    // final orderInfo = {
    //   ...?widget.order,
    //   "pNum": selectedPeopleMaps.length,
    //   "foodOrdersDetil": selectedPeopleMaps,
    // };
    // final res = await addMealPerson(orderInfo);
    // if (res['code'] == 200 && res['msg'] == '操作成功') {
    //   showToast(context, '添加成功');
    //   Navigator.pushNamedAndRemoveUntil(
    //     context,
    //     '/tab',
    //     arguments: 1,
    //     (Route<dynamic> route) => false,
    //   );
    // } else {
    //   showToast(context, '添加失败');
    // }
  }

  void handleDefault(List<Map> selectedPeopleMaps) {
    // 默认操作，仅更新状态管理
    // final orderMealProvider = Provider.of<OrderMealInfo>(
    //   context,
    //   listen: false,
    // );
    // orderMealProvider.addOrderMealInfo(selectedPeopleMaps);
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: mealDeliveryModel,
      child: Consumer<MealDeliveryModel>(
        builder: (context, mealDeliveryModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                S.of(context).deliverySelectPerson,
                style: TextStyle(fontSize: 16.px),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    Navigator.pop(context, selectedPeople);
                  },
                ),
              ],
            ),
            body: Column(
              children: [_buildTopBar(), Expanded(child: _buildPersonList())],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchDeptController,
                  onChanged: (value) {
                    setState(() {
                      searchDeptController.text = value;
                      mealDeliveryModel.searchDept(value);
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.px),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.px),
                      borderSide: BorderSide(color: Colors.grey, width: 1.px),
                    ),
                    filled: true,
                    // 背景颜色
                    fillColor: Colors.white,
                    // 部门图标
                    prefixIcon: Icon(Icons.apartment),
                    hintText: S.of(context).deliveryDept,
                    hintStyle: TextStyle(fontSize: 12.px),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.px),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchController.text = value;
                      mealDeliveryModel.searchPerson(value);
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.px),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.px),
                      borderSide: BorderSide(color: Colors.grey, width: 1.px),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                    hintText: S.of(context).deliverySearchPerson,
                    hintStyle: TextStyle(fontSize: 12.px),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.px),
                    ),
                  ),
                ),
                onPressed: toggleSelectAll,
                child: Text(
                  S.of(context).selectAllOrDeselectAll,
                  style: TextStyle(fontSize: 12.px),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonList() {
    List<MealDeliveryPersonModel> displayPeople;
    if (searchDeptController.text.isNotEmpty) {
      displayPeople = mealDeliveryModel.filteredPeople;
    } else if (searchController.text.isNotEmpty) {
      displayPeople = mealDeliveryModel.filteredPeople;
    } else {
      displayPeople = mealDeliveryModel.filteredPeople;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 5.px),
      child: ListView.builder(
        itemCount: displayPeople.length,
        itemBuilder: (context, index) {
          final person = displayPeople[index];
          return PersonListItem(
            person: person,
            isSelected: selectedPeople.any(
              (selectedPerson) => selectedPerson.id == person.id,
            ),
            onSelectedChanged: (value) {
              setState(() {
                if (value) {
                  mealDeliveryModel.addSelectedPeople([person]);
                } else {
                  mealDeliveryModel.removeSelectedPeople([person]);
                }
                selectedPeople = mealDeliveryModel.selectedPeople;
              });
            },
          );
        },
      ),
    );
  }

  List<dynamic> getCurrentDisplayPeople() {
    if (searchDeptController.text.isNotEmpty) {
      return widget.people
          .where(
            (person) =>
                person.deptName?.toLowerCase().contains(
                  searchDeptController.text.toLowerCase(),
                ) ??
                false,
          )
          .toList();
    } else if (searchController.text.isNotEmpty) {
      return widget.people
          .where(
            (person) =>
                person.username?.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ??
                false,
          )
          .toList();
    }
    return widget.people;
  }

  void toggleSelectAll() {
    List<dynamic> displayPeople = getCurrentDisplayPeople();
    setState(() {
      if (allSelected) {
        for (var person in displayPeople) {
          if (person.status != "1") {
            selectedPeople.add(person);
          } else {
            selectedPeople.remove(person);
          }
        }
      } else {
        selectedPeople.clear();
      }
      allSelected = !allSelected;
    });
  }
}

class PersonListItem extends StatelessWidget {
  final MealDeliveryPersonModel person;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;

  const PersonListItem({
    Key? key,
    required this.person,
    required this.isSelected,
    required this.onSelectedChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        person.status == "1"
            ? Colors.grey[300]!
            : Colors.white; // Grey for status "0", white otherwise
    return Card(
      margin: EdgeInsets.only(bottom: 10.px),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.px)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.px),
        onTap:
            person.status != "1"
                ? () => onSelectedChanged(!isSelected)
                : null, // Ensure onTap is correct
        child: Container(
          color: backgroundColor, // Apply the background color
          child: ListTile(
            title: Text(
              person.username ?? '',
              style: TextStyle(fontSize: 16), // Font size updated to 16
            ),
            subtitle: Text(
              '${S.of(context).deliveryJobNumber}: ${person.jobNumber}\n${S.of(context).deliveryDeptName}: ${person.deptPath ?? ''}',
              style: TextStyle(fontSize: 12), // Subtitle font size
            ),
            trailing: Checkbox(
              value: isSelected,
              onChanged:
                  person.status != "1"
                      ? (bool? value) {
                        // Ensure onChanged is correct
                        onSelectedChanged(value!);
                      }
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}

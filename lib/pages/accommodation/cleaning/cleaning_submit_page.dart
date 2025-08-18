import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/cleaning_form_model.dart';
import 'package:logistics_app/pages/accommodation/cleaning/cleaning_data_model.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/add_address_page.dart';
import 'package:logistics_app/pages/accommodation/cleaning/my_address_view.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';

class CleaningSubmitPage extends StatefulWidget {
  @override
  _CleaningSubmitPageState createState() => _CleaningSubmitPageState();
}

class _CleaningSubmitPageState extends State<CleaningSubmitPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var model = CleaningDataModel();

  // 表单控制器
  TextEditingController _contactPersonController = TextEditingController();
  TextEditingController _contactPhoneController = TextEditingController();
  TextEditingController _roomNumberController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();

  // 选择的值
  @override
  void dispose() {
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _roomNumberController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  // 选择日期
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: model.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        model.selectedDate = picked;
      });
    }
  }

  // 第一个页面
  void _navigateToSecondPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAddressPage()),
    );
    // 处理返回值
    if (result == true) {
      model.getMyAddressList(1, 10000).then((value) {
        // _refreshController.refreshCompleted();
        setState(() {});
      });
    }
  }

  // 选择保洁项目
  void _selectItems(BuildContext context) {
    if (model.cleaningTypeList.isEmpty) {
      ProgressHUD.showError(S.of(context).cleaning_loading);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(8.px),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).cleaning_select_cleaning_project,
                    style: TextStyle(
                      fontSize: 16.px,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.px),
              Expanded(
                child: ListView.builder(
                  itemCount: model.cleaningTypeList.length,
                  itemBuilder: (context, index) {
                    final item = model.cleaningTypeList[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(8.px)),

                        onTap: () {
                          setState(() {
                            model.selectedItem = item;
                          });
                          Navigator.pop(context);
                        },
                        child: Ink(
                          padding: EdgeInsets.all(4.px),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.px),
                            ), // 确保边框效果
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text(
                                  item.chargeType == 0
                                      ? S.of(context).cleaning_deep_cleaning
                                      : S.of(context).cleaning_special_cleaning,
                                  style: TextStyle(
                                    fontSize: 10.px,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor:
                                    item.chargeType == 1
                                        ? primaryColor
                                        : secondaryColor,
                              ),
                              SizedBox(width: 8.px),
                              Text(
                                item.projectDetails ?? '',
                                style: TextStyle(fontSize: 14.px),
                              ),
                              Expanded(
                                child: Text(
                                  item.chargePrice.toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 14.px,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 提交订单
  void _submitOrder(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (model.defaultAddress == null) {
      ProgressHUD.showError(S.of(context).cleaning_select_address);
      return;
    }

    if (model.selectedItem == null) {
      ProgressHUD.showError(S.of(context).cleaning_select_cleaning_project);
      return;
    }

    if (model.selectedDate == null) {
      ProgressHUD.showError(S.of(context).cleaning_select_date);
      return;
    }
    // 判断选择区域是否包含在保洁项目的区域里
    if (model.selectedItem?.ancestors
            ?.split(',')
            .contains(model.defaultAddress?.areaId.toString()) ==
        false) {
      ProgressHUD.showError(S.of(context).cleaning_select_address_error);
      return;
    }

    // print({
    //   'contacts': model.defaultAddress?.name,
    //   'tel': model.defaultAddress?.tel,
    //   'clArea': model.defaultAddress?.area,
    //   'roomNo': model.defaultAddress?.roomNo,
    //   'rlaId': model.defaultAddress?.areaId,
    //   'rlId': model.defaultAddress?.region,
    //   'remark': _remarkController.text,
    //   'cleanPrice': model.selectedItem?.chargePrice,
    //   'cpId': model.selectedItem?.id,
    //   'reserveDate': model.selectedDate?.toString().split(' ')[0],
    // });
    model
        .addCleaningModel(
          CleaningFormModel(
            contacts: model.defaultAddress?.name,
            tel: model.defaultAddress?.tel,
            clArea: model.defaultAddress?.area,
            roomNo: model.defaultAddress?.roomNo,
            rlaId: model.defaultAddress?.areaId,
            rlId: int.parse(model.defaultAddress?.region ?? '0'),
            cpId: model.selectedItem?.id,
            reserveDate: model.selectedDate?.toString().split(' ')[0],
            cleanPrice: model.selectedItem?.chargePrice.toString(),
            remark: _remarkController.text,
          ),
        )
        .then((value) {
          if (value.success) {
            ProgressHUD.showSuccess(S.of(context).submitSuccess);
            // 延迟2秒后关闭
            Future.delayed(Duration(seconds: 1), () {
              ProgressHUD.hide();
              Navigator.pop(context, true);
            });
          } else {
            ProgressHUD.hide();
            ProgressHUD.showError(S.of(context).submitFail);
          }
        });
  }

  @override
  void initState() {
    super.initState();
    model.getCleaningTypeList();
    model.getMyAddressList(1, 10000);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).cleaning_submit,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ChangeNotifierProvider.value(
        value: model,
        child: Consumer<CleaningDataModel>(
          builder: (context, cleaningDataModel, child) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.px),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(8.px)),
                      onTap:
                          () => {
                            Picker.showModalSheet(
                              context,
                              child: ChangeNotifierProvider.value(
                                value: model,
                                child: MyAddressView(
                                  addressList: model.addressList,
                                  defaultAddress: model.defaultAddress,
                                  onAddressSelected: (address) {
                                    Navigator.pop(context, address);
                                  },
                                  onAddAddress: _navigateToSecondPage,
                                ),
                              ),
                            ).then((value) {
                              if (value != null) {
                                model.defaultAddress = value;
                                setState(() {
                                  print(value);
                                });
                              }
                            }),
                          },
                      child: Ink(
                        padding: EdgeInsets.all(8.px),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.px),
                          ), // 确保边框效果
                        ),
                        child:
                            model.defaultAddress != null
                                ? Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model
                                                    .defaultAddress
                                                    ?.detailedAddress ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 14.px,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5.px),
                                          Row(
                                            children: [
                                              Text(
                                                model.defaultAddress?.name ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 12.px,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(width: 8.px),
                                              Text(
                                                model.defaultAddress?.tel ?? '',
                                                style: TextStyle(
                                                  fontSize: 12.px,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                      size: 18.px,
                                    ),
                                  ],
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      S
                                          .of(context)
                                          .pleaseSelect(S.of(context).address),
                                      style: TextStyle(
                                        fontSize: 12.px,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: primaryColor,
                                    ),
                                  ],
                                ),
                      ),
                    ),
                    // 保洁项目
                    SizedBox(height: 16.px),
                    _buildSelectField(
                      context: context,
                      label: S.of(context).cleaning_project,
                      value:
                          model.selectedItem == null
                              ? S
                                  .of(context)
                                  .pleaseSelect(S.of(context).cleaning_project)
                              : model.selectedItem?.projectDetails ??
                                  '' +
                                      '（${model.selectedItem?.chargePrice}元）' +
                                      '（${model.selectedItem?.chargeType == 0 ? S.of(context).cleaning_deep_cleaning : S.of(context).cleaning_special_cleaning}）',
                      onTap: () {
                        _selectItems(context);
                      },
                      icon: Icons.cleaning_services,
                      isRequired: true,
                    ),

                    SizedBox(height: 16.px),

                    // 预约日期
                    _buildSelectField(
                      context: context,
                      label: S.of(context).cleaning_date,
                      value:
                          model.selectedDate == null
                              ? S
                                  .of(context)
                                  .pleaseSelect(S.of(context).cleaning_date)
                              : '${model.selectedDate!.year}-${model.selectedDate!.month.toString().padLeft(2, '0')}-${model.selectedDate!.day.toString().padLeft(2, '0')}',
                      onTap: _selectDate,
                      icon: Icons.calendar_today,
                      isRequired: true,
                    ),

                    SizedBox(height: 16.px),

                    // 备注
                    _buildFormField(
                      label: S.of(context).cleaning_remark,
                      controller: _remarkController,
                      icon: Icons.note,
                      maxLines: 5,
                      hintText: S
                          .of(context)
                          .pleaseInput(S.of(context).cleaning_remark),
                    ),

                    SizedBox(height: 32.px),

                    // 提交按钮
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _submitOrder(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            primaryColor[500],
                          ),
                          minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 36.px),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.px),
                            ),
                          ),
                        ),
                        child: Text(
                          S.of(context).cleaning_order_submit,
                          style: TextStyle(
                            fontSize: 14.px,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 构建表单字段
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.px, color: Colors.grey[600]),
              SizedBox(width: 4.px),
            ],
            Text(
              label,
              style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.w500),
            ),
            if (validator != null) ...[
              Text(' *', style: TextStyle(color: Colors.red, fontSize: 12.px)),
            ],
          ],
        ),
        SizedBox(height: 8.px),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(fontSize: 12.px),
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            isDense: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.px),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.px),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.px),
              borderSide: BorderSide(color: primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.px,
              vertical: 8.px,
            ),
          ),
        ),
      ],
    );
  }

  // 构建选择字段
  Widget _buildSelectField({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
    IconData? icon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.px, color: Colors.grey[600]),
              SizedBox(width: 4.px),
            ],
            Text(
              label,
              style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.w500),
            ),
            if (isRequired) ...[
              Text(' *', style: TextStyle(color: Colors.red, fontSize: 12.px)),
            ],
          ],
        ),
        SizedBox(height: 8.px),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8.px),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 12.px,
                      color:
                          value.startsWith(
                                S
                                    .of(context)
                                    .pleaseSelect(S.of(context).address),
                              )
                              ? Colors.grey[500]
                              : Colors.black,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[500]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

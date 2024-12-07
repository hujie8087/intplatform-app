import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/cascade_tree_picker.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/address_form_model.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/my_address_model.dart';
import 'package:logistics_app/utils/address_service.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage>
    with TickerProviderStateMixin {
  var model = MyAddressModel();
  List<dynamic> values = [];
  String roomValue = S.current.pleaseSelect('');
  int? selectRoomId;
  String selectRoom = '';
  int? selectAreaId;
  String selectArea = '';
  final _formKey = GlobalKey<FormState>();
  bool isDefault = false;
  final nameController = TextEditingController();
  final telController = TextEditingController();
  List<dynamic>? buildingData;

  void _fetchData() async {
    buildingData = await SpUtils.getModel('building');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 获取楼栋信息
    // model.getBuildingTreeModel();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return model;
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              S.of(context).addAddress,
              style: TextStyle(fontSize: 16.px),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(top: 20.px, right: 15.px, left: 15.px),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.px))),
                padding: EdgeInsets.only(top: 20.px, right: 15.px, left: 15.px),
                width: double.infinity,
                child: Column(
                  children: [
                    if (selectRoom.isEmpty)
                      Container(
                        margin: EdgeInsets.only(bottom: 10.px),
                        width: double.infinity,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: primaryColor,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10.px), // 设置圆角半径
                              ),
                            ),
                            onPressed: () async {
                              if (buildingData != null) {
                                CascadeTreePicker.show(context,
                                    data: buildingData ?? [],
                                    values: values,
                                    labelKey: 'title',
                                    valuesKey: 'id',
                                    title: S.of(context).selectAddress,
                                    clickCallBack: (selectItem, selectArr) {
                                  print(selectItem);
                                  print(selectArr);
                                  selectRoom = selectItem['title'];
                                  selectRoomId = selectItem['id'];
                                  selectArea = selectArr[0]['title'];
                                  selectAreaId = selectArr[0]['id'];
                                  setState(() {
                                    values = selectArr;
                                    List<Map<String, dynamic>> mappedSelectArr =
                                        List<Map<String, dynamic>>.from(
                                            selectArr);
                                    roomValue = mappedSelectArr
                                        .map((item) => item['title'])
                                        .join('/');
                                  });
                                  Navigator.pop(context);
                                });
                              } else {
                                AddressService().refreshAddressData();
                                _fetchData();
                                setState(() {});
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).selectAddress,
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 12.px),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: primaryColor,
                                )
                              ],
                            )),
                      ),
                    if (selectRoom.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10.px),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectRoom,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.px),
                                  ),
                                  Text(
                                    roomValue,
                                    style: TextStyle(fontSize: 12.px),
                                  )
                                ],
                              ),
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  CascadeTreePicker.show(context,
                                      data: buildingData ?? [],
                                      values: values,
                                      labelKey: 'title',
                                      valuesKey: 'id',
                                      title: S.of(context).selectAddress,
                                      clickCallBack: (selectItem, selectArr) {
                                    selectRoom = selectItem['title'];
                                    selectRoomId = selectItem['id'];
                                    selectAreaId = selectArr[0]['id'];
                                    selectArea = selectArr[0]['title'];
                                    setState(() {
                                      values = selectArr;
                                      List<Map<String, dynamic>>
                                          mappedSelectArr =
                                          List<Map<String, dynamic>>.from(
                                              selectArr);
                                      roomValue = mappedSelectArr
                                          .map((item) => item['title'])
                                          .join('/');
                                    });
                                    Navigator.pop(context);
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: secondaryColor,
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8.px), // 设置圆角半径
                                  ),
                                ),
                                child: Text(
                                  S.of(context).modifyAddress,
                                  style: TextStyle(
                                      color: secondaryColor, fontSize: 12.px),
                                ))
                          ],
                        ),
                      ),
                    // 输入框联系人
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10.px),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(10, 0, 0, 0)))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).contactPerson,
                                  style: TextStyle(
                                      fontSize: 12.px, color: Colors.black),
                                ),
                                Expanded(
                                    child: TextFormField(
                                  textAlign: TextAlign.right,
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: S.of(context).inputMessage(
                                        S.of(context).contactPerson),
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                  ),

                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      ProgressHUD.showError(S
                                          .of(context)
                                          .inputMessage(
                                              S.of(context).contactPerson));
                                    }
                                    return null;
                                  },
                                ))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(10, 0, 0, 0)))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).contactPhone,
                                  style: TextStyle(
                                      fontSize: 12.px, color: Colors.black),
                                ),
                                Expanded(
                                    child: TextFormField(
                                  textAlign: TextAlign.right,
                                  controller: telController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: S.of(context).inputMessage(
                                        S.of(context).contactPhone),
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.px),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.px, vertical: 10.px),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      ProgressHUD.showError(S
                                          .of(context)
                                          .inputMessage(
                                              S.of(context).contactPhone));
                                    }
                                    return null;
                                  },
                                ))
                              ],
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(10, 0, 0, 0)))),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).isDefault,
                                      style: TextStyle(
                                          fontSize: 12.px, color: Colors.black),
                                    ),
                                    Checkbox(
                                        value: isDefault,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        onChanged: (value) {
                                          setState(() {
                                            isDefault = !isDefault;
                                          });
                                        }),
                                  ])),
                          Container(
                            margin: EdgeInsets.only(top: 20.px),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(primaryColor[500]),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8), // 设置圆角半径
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  if (selectRoomId == null) {
                                    ProgressHUD.showError(S
                                        .of(context)
                                        .inputMessage(
                                            S.of(context).selectAddress));
                                    return;
                                  }
                                  model.addressFormModel = AddressFormModel(
                                    tel: telController.text,
                                    name: nameController.text,
                                    isDefault: isDefault ? '0' : '1',
                                    region: selectRoomId.toString(),
                                    roomNo: selectRoom,
                                    area: selectArea,
                                    areaId: selectAreaId,
                                    detailedAddress: roomValue,
                                  );
                                  await model.addAddress().then((res) {
                                    if (res.success) {
                                      ProgressHUD.showSuccess(
                                          S.of(context).saveAddressSuccess);
                                      Navigator.pop(context, true);
                                    } else {
                                      ProgressHUD.showError(res.errorMessage ??
                                          S.of(context).saveAddressFail);
                                    }
                                  });
                                }
                              },
                              child: Text(
                                S.of(context).saveAddress,
                                style: TextStyle(fontSize: 12.px),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

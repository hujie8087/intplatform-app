import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/cascade_tree_picker.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/address_form_model.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/my_address_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:provider/provider.dart';

class EditAddressPage extends StatefulWidget {
  EditAddressPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage>
    with TickerProviderStateMixin {
  var model = MyAddressModel();
  List<dynamic> values = [];
  String roomValue = S.current.pleaseSelect;
  int? selectRoomId;
  String selectRoom = '';
  final _formKey = GlobalKey<FormState>();
  bool isDefault = false;
  final nameController = TextEditingController();
  final telController = TextEditingController();

  Future<void> _fetchData() async {
    // 模拟异步数据获取
    if (widget.id.toString() != '') {
      model.getMyAddressDetail(widget.id.toString()).then((value) {
        if (value.success) {
          print('data:${value.data}');
          setState(() {
            nameController.text = value.data!.name ?? '';
            telController.text = value.data!.tel ?? '';
            selectRoom = value.data!.detailedAddress.toString().substring(
                value.data!.detailedAddress.toString().lastIndexOf('/') + 1);
            selectRoomId = value.data!.id ?? 0;
            roomValue = value.data!.detailedAddress.toString();
            if (value.data!.isDefault == '0') {
              isDefault = true;
            } else {
              isDefault = false;
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    // 获取楼栋信息
    model.getBuildingTreeModel();
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
              '编辑收货地址',
              style: TextStyle(fontSize: 18),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: EdgeInsets.only(top: 20, right: 15, left: 15),
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10),
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
                                      fontSize: 16),
                                ),
                                Text(
                                  roomValue,
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () {
                                CascadeTreePicker.show(context,
                                    data: model.buildingList,
                                    values: values,
                                    labelKey: 'title',
                                    valuesKey: 'id',
                                    title: S.of(context).repairAddress,
                                    clickCallBack: (selectItem, selectArr) {
                                  selectRoom = selectItem['title'];
                                  selectRoomId = selectItem['id'];
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
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: secondaryColor,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // 设置圆角半径
                                ),
                              ),
                              child: Text(
                                '修改地址',
                                style: TextStyle(color: secondaryColor),
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
                                  '联系人',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Expanded(
                                    child: TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '请填写收货人的姓名',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                  ),

                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      ProgressHUD.showError('请填写收货人的姓名');
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
                                  '手机号',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Expanded(
                                    child: TextFormField(
                                  controller: telController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '请填写收货人的手机号码',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      ProgressHUD.showError('请填写收货人的手机号码');
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
                                      '是否默认',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                    Checkbox(
                                      value: isDefault,
                                      onChanged: (value) {
                                        setState(() {
                                          isDefault = !isDefault;
                                        });
                                      },
                                      activeColor: primaryColor[700],
                                      shape: CircleBorder(
                                        side: BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize
                                              .shrinkWrap, // 去掉额外的边距
                                    )
                                  ])),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(primaryColor[700]),
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
                                    ProgressHUD.showError('请选择收货地址');
                                    return;
                                  }
                                  model.addressFormModel = AddressFormModel(
                                    tel: telController.text,
                                    name: nameController.text,
                                    isDefault: isDefault ? '0' : '1',
                                    region: selectRoomId.toString(),
                                    detailedAddress: roomValue,
                                  );
                                  await model.addAddress().then((res) {
                                    if (res.success) {
                                      ProgressHUD.showSuccess('保存地址成功');
                                      Navigator.pop(context, true);
                                    } else {
                                      ProgressHUD.showError(
                                          res.errorMessage ?? "保存地址失败，请稍后再试");
                                    }
                                  });
                                }
                              },
                              child: const Text('保存地址'),
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

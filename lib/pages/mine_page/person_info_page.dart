import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/divider_widget.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/repair/repair_form_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PersonInfoPage extends StatefulWidget {
  @override
  _PersonInfoPageState createState() => _PersonInfoPageState();
}

class _PersonInfoPageState extends State<PersonInfoPage> {
  String avatar = 'assets/images/userImage.png';
  UserInfoModel? userInfo;
  List<AssetEntity> selectedAssets = [];
  String? selectedValue;
  String imagePrefix = '';
  final List<DictModel> sexOptions = [
    DictModel(dictValue: '0', dictLabel: '男'),
    DictModel(dictValue: '1', dictLabel: '女'),
    DictModel(dictValue: '2', dictLabel: '保密'),
  ];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    DataUtils.getUserInfo(
      success: (res) async {
        UserInfoModel userInfoModel = UserInfoModel.fromJson(res['data']);
        await SpUtils.saveModel('userInfo', userInfoModel);
        await SpUtils.saveString(
            Constants.SP_USER_NAME, userInfoModel.user?.nickName ?? '');
        await SpUtils.saveString(
            Constants.SP_USER_DEPT, userInfoModel.user?.dept?.deptName ?? '');
        if (userInfoModel.user?.avatar != '') {
          avatar = userInfoModel.user!.avatar!;
        }
        userInfo = userInfoModel;
        imagePrefix = await SpUtils.getString(Constants.SP_IMAGE_PREFIX);
        setState(() {});
      },
      fail: (code, msg) {
        ProgressHUD.showText(msg);
      },
    );
  }

  Future<void> _updateData() async {
    DataUtils.editUserInfo(
      userInfo!.user!.toJson(),
      success: (res) async {
        ProgressHUD.showText('修改成功');
        _fetchData();
        setState(() {});
      },
      fail: (code, msg) {
        ProgressHUD.showText(msg);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '个人信息',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // 自适应键盘弹起不遮挡
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _PersonInfoForm(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _PersonInfoForm() {
    return Column(
      children: [
        // 头像
        GestureDetector(
          onTap: () async {
            final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: AssetPickerConfig(
                    textDelegate: AssetPickerTextDelegate(), maxAssets: 1));
            if (result == null) {
              return;
            }
            final res = await uploadImages(result);
            if (res.isNotEmpty) {
              userInfo?.user?.avatar = res[0];
              print(userInfo);
              _updateData();
            }
          },
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: avatar.startsWith('assets')
                        ? AssetImage(avatar) as ImageProvider
                        : NetworkImage(imagePrefix + avatar),
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Text(
                '点击更换头像',
                style: TextStyle(color: secondaryColor, fontSize: 12),
              )
            ],
          ),
        ),
        _PersonInfoItem('姓名', userInfo?.user?.nickName ?? '', Icons.person,
            () async {
          _controller.text = '';
          final result = await _showEditDialog(_controller, title: '姓名');
          if (result != null) {
            userInfo!.user!.nickName = result;
            _updateData();
          }
        }, isEdit: true),
        // 工号
        _PersonInfoItem('工号', userInfo?.user?.userName ?? '',
            Icons.workspace_premium, () {}),
        _PersonInfoItem('性别', userInfo?.user?.sex == '0' ? '男' : '女', Icons.wc,
            () {
          Picker.showModalSheet(context,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (final sex in sexOptions)
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, sex.dictValue ?? '');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: Text(sex.dictLabel ?? ''),
                            ),
                          ),
                          DividerWidget()
                        ],
                      ),
                  ],
                ),
              )).then((value) {
            if (value != null) {
              userInfo!.user!.sex = value;
              _updateData();
            }
          });
        }, isEdit: true),
        _PersonInfoItem('电话', userInfo?.user?.phonenumber ?? '', Icons.phone,
            () async {
          _controller.text = '';
          final result = await _showEditDialog(_controller,
              title: '电话', keyboardType: TextInputType.phone);
          if (result != null) {
            userInfo!.user!.phonenumber = result;
            _updateData();
          }
        }, isEdit: true),
        _PersonInfoItem('邮箱', userInfo?.user?.email ?? '', Icons.email,
            () async {
          _controller.text = '';
          final result = await _showEditDialog(_controller,
              title: '邮箱', keyboardType: TextInputType.emailAddress);
          if (result != null) {
            userInfo!.user!.email = result;
            _updateData();
          }
        }, isEdit: true),
        // 部门
        _PersonInfoItem(
            '部门', userInfo?.user?.dept?.deptName ?? '', Icons.work, () {},
            isEdit: false),
      ],
    );
  }

  Widget _PersonInfoItem(String title, String value, IconData icon, onTap,
      {bool isEdit = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Row(
              children: [
                // 图标
                Icon(
                  icon,
                  color: primaryColor,
                  size: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14),
                )
              ],
            )),
            Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (isEdit) Icon(Icons.chevron_right, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showEditDialog(controller,
      {required String title,
      TextInputType keyboardType = TextInputType.text}) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(hintText: "请输入${title}"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
    return result;
  }
}
